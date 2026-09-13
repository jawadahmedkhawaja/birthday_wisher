# 🎂 Birthday Wisher

A romantic and interactive Flutter app to surprise your loved one on their special day with personalized birthday wishes, memories, and heartfelt messages.

## ✨ Features

- **🔐 Passcode Lock Screen** - Enter a special date to unlock the surprise
- **💌 Love Letter** - A customizable heartfelt message from you
- **📸 Shared Memories** - Browse through sweet memories together
- **💖 Reasons to Love** - Display personalized reasons why they're special
- **🎉 Birthday Cake Celebration** - Animated cake with interactive elements
- **🎨 Beautiful UI** - Romantic gradient backgrounds with smooth animations
- **⚙️ Easy Customization** - Configure names, dates, and messages via `.env` file

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.13.0 or later)
- Dart SDK
- iOS/Android development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/jawadahmedkhawaja/birthday_wisher.git
   cd birthday_wisher
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure your surprise**
   Create a `.env` file in the project root:
   ```env
   YOUR_NAME=Your Name
   HER_NAME=Their Name
   BIRTHDAY=YYYY-MM-DD
   BIRTHDAY_GREETING=Happy Birthday, My Love ❤️
   BIRTHDAY_MESSAGE=Your heartfelt message here...
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔓 Passcode

The app is protected with a passcode derived from the birthday date in the `.env` file:
- Format: `BIRTHDAY=2005-09-10`
- Passcode: `10092005` (DDMMYYYY format)

## 🎯 How It Works

1. **Unlock** - Enter the birthday date passcode to unlock
2. **Read** - Tap to open the love letter with your custom message
3. **Remember** - Navigate through shared memories
4. **Celebrate** - See reasons why they're loved
5. **Enjoy** - Animated birthday cake celebration

## 📱 Customization

All text, names, and messages can be customized through the `.env` file:

- `YOUR_NAME` - Your name
- `HER_NAME` - Their name
- `BIRTHDAY` - Birth date in YYYY-MM-DD format
- `BIRTHDAY_GREETING` - The greeting message
- `BIRTHDAY_MESSAGE` - The full birthday message
- `BIRTHDAY_WISHER_LOGO` - Optional: app logo path

## 🛠️ Built With

- **Flutter** - UI Framework
- **Dart** - Programming Language
- **flutter_dotenv** - Environment configuration
- **flutter_launcher_icons** - App icon management

## 📊 Tech Stack

- 46.9% Dart
- 26.7% C++ (Flutter engine)
- 20.9% CMake
- 2.2% Swift
- 1.6% HTML
- 1.6% C

## 💝 Features Highlights

### Page 1: Passcode Lock
- Secure entry with beautiful number pad
- Heart emoji indicators for entered digits
- Error messages with encouraging messages

### Page 2: Love Letter
- Tap to open animated envelope
- Customizable greeting and message
- Personalized signature

### Page 3: Memories
- Swipeable memory carousel
- Emoji-based visual representation
- Titles and descriptions for each memory

### Page 4: Reasons to Love
- List of reasons they're special
- Beautiful card-based layout

### Page 5: Birthday Cake
- Animated confetti
- Interactive celebration
- Festive countdown

## 🎨 Design

- Romantic color palette (soft pinks and purples)
- Smooth page transitions
- Animated UI elements
- Heart and sparkle animations
- Responsive design

## 🤝 Contributing

Feel free to fork this project and customize it for your loved one. Consider these enhancements:
- Add photo gallery integration
- Include music or sound effects
- Add more memory pages
- Implement countdown timer
- Add custom animations

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ❤️ A Little Note

This app was created with love 💕. Feel free to personalize every aspect to make it special and unique for your loved one. The best gifts are those made with thought and care.

---

Made with ❤️ using Flutter
