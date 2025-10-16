# 🧩 ModularSwiftUIUsersApp

![Swift](https://img.shields.io/badge/Swift-5.10-orange?logo=swift)
![Xcode](https://img.shields.io/badge/Xcode-16.4-blue?logo=xcode)
![Platform](https://img.shields.io/badge/iOS-Simulator--Only-lightgrey)
![Coverage](https://img.shields.io/badge/Test%20Coverage-84%25-success)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A modular iOS application built using SwiftUI, Combine, and async/await.
It displays a list of users fetched from a sample API and allows navigation to detailed user information.

The goal is to demonstrate clean architecture, dependency injection, modern Swift concurrency, and comprehensive unit testing — all while keeping the app simple and focused.

🧭 Overview

This project demonstrates:

🧩 Modular architecture with separate layers for Networking, Services, ViewModels, and Views

⚙️ Use of Swift Concurrency (async/await) and Combine for reactive data flow

💡 Lightweight Dependency Injection (DI) via AppContainer for configurability and testing

📱 Two SwiftUI screens:
1️⃣ Users List — Fetches and displays user data
2️⃣ User Detail — Displays details for a selected user

🧪 Unit tests covering all major logical layers (Networking, Services, DI, ViewModel)

✨ Focus: Architecture, readability, and testability — not UI complexity.


ModularSwiftUIUsersApp/
┣ App/
┃ ┣ AppContainer.swift
┃ ┗ ModularSwiftUIUsersApp.swift
┣ Models/
┃ ┗ User.swift
┣ Networking/
┃ ┣ NetworkClientProtocol.swift
┃ ┗ NetworkClient.swift
┣ Services/
┃ ┗ UserService.swift
┣ ViewModels/
┃ ┗ UsersViewModel.swift
┣ Views/
┃ ┣ UsersListView.swift
┃ ┗ UserDetailView.swift
┣ Tests/
┃ ┣ NetworkClientTests.swift
┃ ┗ UserServiceTests.swift
┗ README.md

Each layer is modular, independently testable, and loosely coupled:

| Layer            | Responsibility                                 |
| ---------------- | ---------------------------------------------- |
| **Networking**   | Handles low-level async URLSession requests    |
| **Service**      | Fetches and decodes API data                   |
| **ViewModel**    | Bridges Combine publishers with SwiftUI views  |
| **Views**        | Declarative SwiftUI components                 |
| **AppContainer** | Central dependency injection and configuration |


🌐 API Endpoint

Data is fetched from:

https://fake-json-api.mock.beeceptor.com/users

If this endpoint is unavailable, the app can be easily reconfigured to use any public user API (e.g. JSONPlaceholder
) within AppContainer.swift.

🧪 Unit Tests

All unit tests are located in ModularSwiftUIUsersAppTests/.

| Test Suite             | Description                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------- |
| **NetworkClientTests** | Validates data fetching and error handling with MockURLProtocol                       |
| **UserServiceTests**   | Tests parsing, Combine integration, async/await behavior, and graceful error handling |


🧠 Note:
Only unit tests were required and implemented.
UI tests are intentionally excluded to keep the focus on logic correctness.

Run all tests using ⌘ + U in Xcode.


| Category             | Technology   |
| -------------------- | ------------ |
| Language             | Swift 5.10   |
| IDE                  | Xcode 16.4   |
| UI Framework         | SwiftUI      |
| Reactive Layer       | Combine      |
| Async Handling       | async/await  |
| Dependency Injection | AppContainer |
| Testing              | XCTest       |


💡 Assumptions

The app focuses on architecture and testability, not production-level UI polish.

API response matches the Beeceptor mock structure.

The app targets iOS Simulator (no signing or provisioning required).

Network and business logic are designed for real-world scalability.

🧱 Code Coverage Summary

| File                       | Coverage   |
| -------------------------- | ---------- |
| `NetworkClient.swift`      | 100%       |
| `UserService.swift`        | 100%       |
| `AppContainer.swift`       | 90%        |
| `UsersViewModel.swift`     | 97%        |
| `UsersListView.swift`      | 96%        |
| **Total Project Coverage** | **~84% ✅** |


84% meaningful coverage — focusing on testable business logic.
Declarative SwiftUI structs and entry points are intentionally excluded from metrics.

🚀 How to Run

Open ModularSwiftUIUsersApp.xcodeproj in Xcode 16.4 or later

Select an iPhone simulator (e.g., iPhone 15 Pro)

Press ⌘ + R → Run the app

Press ⌘ + U → Run the unit tests

🔮 Future Improvements

Add local caching and offline persistence

Extend SwiftUI Previews for faster design iteration

Expand ViewModel test coverage

Improve error and loading state UI

Add UI Tests for end-to-end validation (optional)

Testing & Code Quality

The project includes isolated and deterministic unit tests for networking, services, and dependency injection.
Tests are written using async/await, Combine, and mocked dependencies to ensure isolation and reliability.


👨‍💻 Author

Rahul Bhalla
Role: Senior iOS Engineer / Team Lead
Experience: 12.7 years in mobile development
Objective: Technical coding assessment submission showcasing clean architecture, modularity, and test-driven SwiftUI design with async/await and Combine.
