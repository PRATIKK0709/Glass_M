# Glass_M- Discord Message Overlay for Streamers


A minimalist solution to display Discord DMs as an overlay while streaming, helping you stay focused without missing important messages or needing to switch your tabs.

---

## Project Description

**Glass** is a lightweight and user-friendly application designed for streamers who want to stay connected with their friends or important contacts on Discord without interrupting their streams. It features a transparent, real-time message overlay that integrates seamlessly with your workflow, ensuring you never miss a message while keeping your screen clutter-free. With customization options and secure local communication, Glass offers a modern solution for hassle-free Discord message management.

---

## ✨ Features

- **Real-time DM Display**: Instantly shows DMs from specific users
- **Floating Overlay**: Transparent window stays on top of other applications
- **Auto-Clean Interface**: Messages automatically disappear after 5 seconds
- **Custom Styling**: Modern, sleek design with timestamp tracking
- **Local Network Communication**: Secure HTTP communication between bot and app


## 🎥 Video Preview

<iframe width="1440" height="683" src="https://www.youtube.com/embed/-CHMBG14lEg" title="GLASS_M" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 🛠️ Technologies Used

- **Discord.js Selfbot v13** ([repo](https://github.com/aiko-chan-ai/discord.js-selfbot-v13))
- **Node.js** HTTP server/client
- **SwiftUI** for macOS interface
- **Network Framework** for local communication

## 🚀 Installation

### Prerequisites
- Node.js v16+
- npm
- Xcode 13+
- macOS 12+
- Visual Studio Code

### SelfBot Setup
1. Clone the repository
   ```bash
   git clone https://github.com/PRATIKK0709/glass-overlay.git
   cd glass-overlay/bot
   ```

2. Install dependencies
   ```bash
   npm install discord.js-selfbot-v13
   ```

3. Configure the bot
   ```javascript
   // In index.js
   const TARGET_USER = 'YOUR_FRIEND_DISCORD_ID'; // Replace with actual ID
   client.login('YOUR_DISCORD_TOKEN'); // Replace with your token
   ```

4. Run the bot
   ```bash
   node index.js
   ```

### macOS App Setup

1. Open `GlassApp.xcodeproj` in Xcode
2. Build and run the project (`⌘R`)
3. Grant necessary permissions when prompted

## 🖥️ Usage

Start both applications simultaneously:

1. Run the Node.js selfbot in Visual Studio Code
2. Launch the macOS app from Xcode

The transparent overlay will appear automatically. When your friend sends DMs:

- Messages appear in the bottom-left corner
- Automatically fade after 5 seconds
- Timestamp shows message arrival time

## 🔧 Technical Overview

### Bot Component

- Monitors DMs from specified user
- Forwards messages via HTTP POST
- Uses lightweight logger system

### macOS App

- SwiftUI-based interface
- Local HTTP server on port 8080
- Network framework for message handling
- Custom window styling with rounded corners

## ⚠️ Important Disclaimer

### Notice Regarding Discord Terms of Service

This project uses a selfbot implementation through `discord.js-selfbot-v13`, which technically violates Discord's Terms of Service as using self bot is against discord tos. However, this project is designed for:

- **Personal Use**: Single-user message display
- **Non-Intrusive**: Read-only access to specific DMs
- **Zero Automation**: No message sending/automated responses

Use at your own risk. I am not responsible for any account actions taken by Discord. This project is shared for educational purposes only.


