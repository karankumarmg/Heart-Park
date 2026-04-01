# 💜 HEART PARK — Flutter Dating App

> **Purple & Pink Vibrant Theme · Firebase Backend · AI Matching**

---

## 🚀 Quick Start

### 1. Install Flutter
```bash
# Make sure Flutter is installed
flutter --version  # Should be 3.x or above
```

### 2. Get Dependencies
```bash
cd heart_park
flutter pub get
```

### 3. Run the App (Mock Data — no Firebase needed)
```bash
flutter run
```
> The app works fully with mock data out of the box!

---

## 🔥 Firebase Setup

### Step 1 — Create Firebase Project
1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Add project** → Name it `heart-park`
3. Enable **Google Analytics** (optional)

### Step 2 — Add Android App
1. Click Android icon in Firebase console
2. Package name: `com.heartpark.app`
3. Download `google-services.json`
4. Place it at: `android/app/google-services.json`

### Step 3 — Add iOS App
1. Click iOS icon in Firebase console
2. Bundle ID: `com.heartpark.app`
3. Download `GoogleService-Info.plist`
4. Place it at: `ios/Runner/GoogleService-Info.plist`

### Step 4 — Enable Services in Firebase Console

#### Authentication
- Go to **Authentication → Sign-in method**
- Enable **Email/Password**
- Enable **Google** (optional)

#### Firestore Database
- Go to **Firestore Database → Create database**
- Start in **production mode**
- Choose region closest to your users (e.g., `asia-south1` for India)

**Firestore Rules:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth.uid == userId;
    }
    match /likes/{doc} {
      allow read, write: if request.auth != null;
    }
    match /matches/{doc} {
      allow read: if request.auth != null &&
        resource.data.users.hasAny([request.auth.uid]);
      allow write: if request.auth != null;
    }
    match /chats/{chatId}/messages/{msgId} {
      allow read, write: if request.auth != null;
    }
    match /chats/{chatId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Storage (for profile photos)
- Go to **Storage → Get started**
- Default rules are fine for development

### Step 5 — Uncomment Firebase in main.dart
```dart
// In lib/main.dart, uncomment:
import 'package:firebase_core/firebase_core.dart';
// ...
await Firebase.initializeApp();
```

---

## 📁 Project Structure

```
heart_park/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── theme/
│   │   └── app_theme.dart           # Purple & Pink color system
│   ├── models/
│   │   └── user_model.dart          # User model + mock data
│   ├── widgets/
│   │   └── common_widgets.dart      # Reusable UI components
│   ├── services/
│   │   └── firebase_service.dart    # Firestore + Auth service
│   └── screens/
│       ├── splash_screen.dart       # Splash + Onboarding (4 pages)
│       ├── home_screen.dart         # Discover + Swipe cards
│       ├── chat_list_screen.dart    # Chat list + Chat screen
│       └── profile_screen.dart      # My profile + Settings
└── pubspec.yaml                     # All dependencies
```

---

## ✨ Features

| Feature | Status |
|---------|--------|
| 🎨 Splash Screen with animation | ✅ Done |
| 📖 4-page Onboarding | ✅ Done |
| 🔍 Discover / Swipe Cards | ✅ Done |
| 🤖 AI Match Score (UI) | ✅ Done |
| 👻 Anonymous Mode toggle | ✅ Done |
| 💬 Chat List with unread badges | ✅ Done |
| 📩 Real-time Chat with auto-reply | ✅ Done |
| 💜 Typing indicator animation | ✅ Done |
| 👤 Profile screen with stats | ✅ Done |
| 🔥 Firebase Auth integration | ✅ Ready |
| 📊 Firestore real-time data | ✅ Ready |
| 📹 Video call (UI skeleton) | 🔜 Next |
| 💳 Premium subscription | 🔜 Next |

---

## 🎨 Color System

```dart
Primary Purple  : #7C3AED  (violet-600)
Deep Purple     : #4C1D95  (violet-900)
Primary Pink    : #EC4899  (pink-500)
Hot Pink        : #DB2777  (pink-600)
Background Dark : #0F0A1E
Card Background : #1A1033
Surface         : #251B44
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `firebase_core` | Firebase initialization |
| `firebase_auth` | User authentication |
| `cloud_firestore` | Real-time database |
| `google_fonts` | DM Sans + Playfair Display |
| `smooth_page_indicator` | Onboarding dots |
| `provider` | State management |
| `cached_network_image` | Profile photo caching |
| `intl` | Date/time formatting |

---

## 🛠 Next Steps

1. **Video Calling** → Integrate `agora_rtc_engine` or `zego_uikit`
2. **AI Matching** → Connect to ML model via Firebase Functions
3. **Push Notifications** → `firebase_messaging`
4. **Google Sign-In** → `google_sign_in` package
5. **Photo Upload** → `image_picker` + Firebase Storage
6. **Premium Features** → `in_app_purchase`

---

*Built with 💜 for Heart Park*
