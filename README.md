# HabitLy

An intelligent habit tracking Flutter application powered by AI and Firebase. HabitLy goes beyond simple tracking by offering AI-powered features to help you build and maintain a productive lifestyle.

## 🌟 Key Features

*   **Habit Management**: Easily create, edit, and track your daily habits. Organize them with customized icons and colors.
*   **Firebase Authentication**: Secure sign-up, login, and user profile management.
*   **Analytics & Progress Tracking**: Keep track of your consistency with current streaks, best streaks, and perfect days.
*   **Smart Reminders**: Local notifications to ensure you never miss a habit schedule.
*   **Responsive UI**: Built with modern, aesthetic, and highly responsive components.

### 🤖 AI-Powered Capabilities (Powered by OpenRouter)
HabitLy leverages advanced AI agents to provide a next-generation user experience—**this is what sets it apart!**
*   **AI Chat Assistant**: Brainstorm, plan, and create habits directly through a conversational interface. The AI agent can automatically set up habits for you directly from the chat!
*   **AI-Driven Onboarding**: Get personalized habit recommendations during your first app setup based on your personal goals and lifestyle.
*   **AI Insights**: Receive smart, data-driven feedback and motivational insights directly based on your habit tracking progress and consistency.

## 🛠️ Setup & Installation

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (version ^3.10.7 or compatible)
*   Dart SDK
*   [Firebase CLI](https://firebase.google.com/docs/cli)

### 1. Setup Firebase

The `lib/firebase_options.dart` is excluded from version control because it contains API keys. To set it up:

1.  Install the FlutterFire CLI globally: 
    ```bash
    dart pub global activate flutterfire_cli
    ```
2.  Configure Firebase for your project: 
    ```bash
    flutterfire configure
    ```
3.  Select your Firebase project (`habitly-361f0` or create a new one) and your target platforms (Android, iOS).
    
The CLI will generate `lib/firebase_options.dart` automatically. You can check `lib/firebase_options.dart.example` for the expected file structure if needed.

### 2. Environment Variables (.env)

This project requires environment variables for its AI functionalities to work.
Create a `.env` file in the root directory of your project and add your OpenRouter API Key:

```env
OPENROUTER_API_KEY=your_openrouter_api_key_here
```
*(Note: Do not commit the `.env` file to version control. It is already included in `.gitignore`)*

### 3. Run the Project

1.  Get all the Flutter dependencies:
    ```bash
    flutter pub get
    ```
2.  Run the app on your preferred emulator or physical device:
    ```bash
    flutter run
    ```

## 📚 Learn More

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
