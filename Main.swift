import SwiftUI
import Network

@main
struct GlassApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    @State private var messages: [MessageData] = []
    @State private var listener: NWListener?
    @State private var timer: Timer?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(messages.reversed()) { message in
                    HStack {
                        Text("\(formatDate(message.timestamp)): \(message.content)")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.4))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .transition(.opacity)
                }
            }
            .padding(.top, 12)
        }
        .background(WindowAccessor())
        .frame(width: 400, height: 600)
        .onAppear(perform: startServer)
        .onAppear {
            startAutoRemovalTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    // MARK: - Server Setup
    private func startServer() {
        do {
            let listener = try NWListener(using: .tcp, on: 8080)
            listener.stateUpdateHandler = { state in
                if case .failed = state { listener.cancel() }
            }
            
            listener.newConnectionHandler = { newConnection in
                newConnection.start(queue: .main)
                self.handleConnection(newConnection)
            }
            
            listener.start(queue: .main)
            self.listener = listener
        } catch {
            print("Server error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Timer Setup
    private func startAutoRemovalTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            withAnimation {
                messages.removeAll { message in
                    now.timeIntervalSince(message.receivedDate) > 5
                }
            }
        }
    }
    
    // MARK: - Connection Handling
    private func handleConnection(_ connection: NWConnection) {
        var buffer = Data()
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, _, error in
            if let data = data, !data.isEmpty {
                buffer.append(data)
                
                if let request = self.parseHTTPRequest(buffer) {
                    if let messageData = self.parseMessageData(from: request.body) {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.messages.append(messageData)
                            }
                        }
                    }
                    connection.cancel()
                    return
                }
                self.handleConnection(connection)
            }
            
            if let error = error {
                print("Connection error: \(error.localizedDescription)")
                connection.cancel()
            }
        }
    }
    
    // MARK: - Helpers
    private func parseHTTPRequest(_ data: Data) -> (headers: [String: String], body: Data)? {
        guard let requestString = String(data: data, encoding: .utf8) else { return nil }
        let components = requestString.components(separatedBy: "\r\n\r\n")
        guard components.count >= 2 else { return nil }
        
        let headersPart = components[0]
        let body = components[1].data(using: .utf8) ?? Data()
        
        var headers: [String: String] = [:]
        headersPart.components(separatedBy: .newlines).forEach { line in
            let parts = line.components(separatedBy: ": ")
            if parts.count == 2 { headers[parts[0].lowercased()] = parts[1] }
        }
        
        return (headers, body)
    }
    
    private func parseMessageData(from bodyData: Data) -> MessageData? {
        do {
            return try JSONDecoder().decode(MessageData.self, from: bodyData)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm:ss"
        outputFormatter.timeZone = TimeZone.current
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: isoDate) {
            return outputFormatter.string(from: date)
        }
        
        let customFormatter = DateFormatter()
        customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        customFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = customFormatter.date(from: isoDate) {
            return outputFormatter.string(from: date)
        }
        
        return ""
    }
}

// MARK: - Supporting Types
struct MessageData: Decodable, Identifiable {
    let id = UUID()
    let content: String
    let timestamp: String
    let receivedDate: Date
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decode(String.self, forKey: .content)
        timestamp = try container.decode(String.self, forKey: .timestamp)
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: timestamp) {
            receivedDate = date
        } else {
            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            customFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = customFormatter.date(from: timestamp) {
                receivedDate = date
            } else {
                throw DecodingError.dataCorruptedError(forKey: .timestamp, in: container, debugDescription: "Invalid timestamp format")
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case content, timestamp
    }
}

struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.backgroundColor = .clear
                window.isOpaque = false
                window.styleMask = [.borderless, .fullSizeContentView]
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.level = .floating
                window.hasShadow = false
                window.isMovableByWindowBackground = true
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
