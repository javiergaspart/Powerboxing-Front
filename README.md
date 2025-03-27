# Frontend - FitBoxing App

## Overview

This is the **Flutter** frontend for the FitBoxing application. It provides a sleek and responsive UI for users to book sessions, manage memberships, and make payments.

## Tech Stack

- **Flutter** (Dart)
- **Provider** (State Management)
- **Firebase Authentication** (For OTP Login)
- **Razorpay** (For Payments)
- **REST API** (Backend Integration)

---

## Getting Started

### 1️⃣ Installation

Clone the repository and install dependencies:

```bash
  git clone https://github.com/ShrutiVerma28/Frontend_Fitboxing.git
  cd frontend
  flutter pub get
  flutter run
```

### 2️⃣ Configuration

Add the following **.env** variables (or modify `config.dart` if using a constant approach):

```dart
const String API_BASE_URL = "https://your-backend-url.com";
const String RAZORPAY_KEY = "your_razorpay_key_id";
```

### 3️⃣ Running the App

#### For Android:
```bash
  flutter run
```

#### For iOS:
```bash
  open ios/Runner.xcworkspace
  flutter run
```

---

## Features

✅ **User Authentication** (OTP-based Login via Firebase)  
✅ **Session Booking**  
✅ **Membership Management**  
✅ **Razorpay Payment Integration**  
✅ **Profile & Settings**  
✅ **Real time results from sensors**  
✅ **Notifications & Trainer Contact**  

---

## Deployment

### 🔹 Generate APK for Android
```bash
  flutter build apk --release
```

### 🔹 Generate iOS Build
```bash
  flutter build ios --release
```

---

## Screenshots

<p align="center">
  <img src="https://github.com/user-attachments/assets/44d2b4f8-2ebe-44ec-a4bf-42041412d1e5" width="400">
  <img src="https://github.com/user-attachments/assets/cdfe8569-51c5-4b65-98f1-c39eabf7b03a" width="400">
  <br>
  <img src="https://github.com/user-attachments/assets/29d16f9e-23d3-43e2-8039-cec6ac53eb73" width="400">
  <img src="https://github.com/user-attachments/assets/0fefec6f-c6fe-41e3-b8d8-72ee6bca1380" width="400">
  <br>
  <img src="https://github.com/user-attachments/assets/8f825650-4a22-48f0-a8e7-05b940786fe9" width="400">
  <img src="https://github.com/user-attachments/assets/d9cd1b19-2c82-4baf-a536-63b6abe17942" width="400">
  <br>
  <img src="https://github.com/user-attachments/assets/968beb3b-c921-4206-945d-1c9b3655a5cd" width="400">
  <img src="https://github.com/user-attachments/assets/5625c6d8-f6c6-4c16-b471-c7df6936d4b6" width="400">
</p>


## 🔗 Useful Links

- **Backend Repo**: [FitBoxing Backend](https://github.com/ShrutiVerma28/FitBoxing/tree/dev)
- **Live App (Play Store)**: [Your Play Store Link]

---

## 📌 Notes

- Make sure to enable **Developer Mode** on your Android phone for local testing.
- Ensure that your **Firebase Configuration** is properly set up for OTP login.
- If experiencing API issues, check backend deployment.

---

**👨‍💻 Developed by SHRUTI VERMA**

