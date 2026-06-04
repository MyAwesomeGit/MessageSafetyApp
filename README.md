# MessageSafetyApp

## ⚠️ Important: This app was created solely for educational purposes to improve digital literacy.

## 👁️ About the Project

MessageSafetyApp is an educational iOS application that demonstrates the importance of internet safety. The app simulates a chat that visually shows how companies, servers, and administrators can see and save personal messages and photos — even when the user thinks they've deleted them.

## 💬 Features

- Chat Simulation — send text messages and photos
- Image Sending — select photos from your device gallery
- Server Log Viewer — visual demonstration of what data gets saved
- Deletion Illusion — swipe left to "delete" a message (it actually remains in the logs)
- Server Warnings — notifications about data retention, admin access, and ad usage

## How It Works

The app demonstrates the following security concepts:

All Messages Are Saved — every sent message or photo is recorded in the server console
Third-Party Access — users are informed how many outsiders can access their data
Irreversibility of Sending — even when deleted from the chat, the message record remains in logs
Photo Metadata — images are analyzed for size and other information
Data Usage — warnings about potential use of data for advertising and sale to third parties

## Technologies

SwiftUI — modern framework for building interfaces
Combine — reactive programming and state management
PhotosUI — working with image gallery
MVVM — architectural pattern via @StateObject and ObservableObject
