# Glass_M - Discord Message Overlay

A minimalist overlay for streamers to display real-time Discord DMs without interrupting gameplay or workflow.

[![YouTube](http://i.ytimg.com/vi/-CHMBG14lEg/hqdefault.jpg)](https://www.youtube.com/watch?v=-CHMBG14lEg)

## ✨ Features

- 🕶️ Transparent floating window (always on top)
- ⚡ Real-time message display from specific users
- 🕒 Auto-removal after 5 seconds
- 🔒 Local network communication (port 8080)
- 🎨 Clean design with timestamps

## 🚀 Quick Start

### Requirements
- Node.js 16+ & Xcode 13+
- macOS 12+ & Discord account

### Bot Setup
```bash
git clone https://github.com/PRATIKK0709/glass-overlay.git
cd glass-overlay/bot
npm install discord.js-selfbot-v13
```

1. Edit `index.js`:
```javascript
const TARGET_USER = 'FRIEND_DISCORD_ID'; // Replace ID
client.login('YOUR_DISCORD_TOKEN'); // Add your token
```

2. Run bot:
```bash
node index.js
```

### App Setup
1. Open `GlassApp.xcodeproj` in Xcode
2. Build & Run (⌘R)
3. Grant screen recording permissions

## 🖥 Usage
1. Launch both bot (VSCode) and app (Xcode)
2. Receive DMs from specified user:
   - Messages appear bottom-left
   - Auto-fade after 5 seconds
   - Timestamps in HH:mm:ss format

## ⚠️ Important Notice
This project uses selfbot functionality that **violates Discord's ToS**. Use at your own risk:

- Personal/educational use only
- Read-only implementation
- No automation/message sending

> **Warning**  
> I am not responsible for any account actions taken by Discord. This is a technical demonstration only.

---

**Architecture**  
SwiftUI Overlay ← HTTP Server (8080) ← Discord Selfbot → Discord API
