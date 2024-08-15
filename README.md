<p align="center">
  <img width="146" alt="logo2" src="https://github.com/user-attachments/assets/1df27585-a891-468c-b23c-4ba128d1d3e9">
</p>

<div align="center">
  <h1>CollabCards - Task Management Application</h1>
</div>

Welcome to CollabCards! This application is a task management tool where users can create cards, organize, and manage their tasks. The app enhances your task management experience with real-time data synchronization, QR code functionality, and customizable settings.

# Table of Contents
- [Features](#features)
  - [Screenshots](#screenshots)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
  - [Unit Tests](#unit-tests)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Board Management](#board-management)
  - [Card Management](#card-management)
  - [Create Board](#create-board)
  - [Settings](#settings)
- [Known Issues](#known-issues)

## Features

**Board Management:**
- Create and manage boards to organize your tasks.
  
**Card Management:**
- Add, edit, and delete cards within boards. Cards come with titles, descriptions, and statuses.
- Drag and drop cards between columns.

**Real-Time Synchronization:**
- All your boards and cards are synchronized across all your devices in real-time using [Firebase Firestore](https://firebase.google.com/).
  
**QR Code Integration:**
- Quickly join boards or access specific tasks by scanning QR codes or manually entering IDs. This feature is powered by the [QRCode](https://github.com/twostraws/QRCode) Swift Package.

**Customizable Settings:**
- Personalize your experience by customizing your username, visibility, and task durations.
  
**Data Persistence:**
- The app uses **UserDefaults** to store small and simple data like user preferences and settings. UserDefaults ensures that these settings are retained between app sessions, providing a fast and efficient way to manage user preferences.

**iPad Support:**
- CollabCards is designed to be responsive on iPads as well, optimized for different screen sizes and orientations.

<p align="center">
  <img src="https://github.com/yourusername/CollabCards/blob/main/Screenshots/iPadResponsive.png" alt="iPad Responsive View" width="400">
</p>

## Screenshots

| Image 1                | Image 2                | Image 3                |
|------------------------|------------------------|------------------------|
| ![EmptyView](https://github.com/user-attachments/assets/66480944-2e43-47ca-b2ac-8d77431331e0) | ![CreateView](https://github.com/user-attachments/assets/09926689-e3ee-41e1-8d7f-c049d58c658e) | ![HomeView](https://github.com/user-attachments/assets/7c6a0fa9-d629-450a-81d4-26f240701ee6) |
| Empty View | Create Board View | Home View |

| Image 4                | Image 5                | Image 6                |
|------------------------|------------------------|------------------------|
| ![BoardInfoView](https://github.com/user-attachments/assets/c2248d16-4574-4a3b-9805-b32f148864e3) | ![BoardView](https://github.com/user-attachments/assets/7897438c-bf5f-4093-826c-e36c2c666ad4) | ![SettingsView](https://github.com/user-attachments/assets/33e963c1-c5aa-4499-afa6-4d441102434d) |
| Board Info View | Board View | Settings View |

## Tech Stack

- **Xcode:** Version 15.4
- **Language:** Swift 5.10
- **Minimum iOS Version:** 16.0
- **Dependency Management:** Swift Package Manager (SPM)
- **Backend:** [Firebase Firestore](https://firebase.google.com/) & Firebase Crashlytics
- **QR Code Functionality:** Library integrated with Swift Package Manager [QRCode](https://github.com/EFPrefix/EFQRCode)

## Architecture

![Architecture](https://github.com/user-attachments/assets/16c2195c-c32a-4d10-897a-df4685d2ab14)

CollabCards is developed using the MVVM (Model-View-ViewModel) architecture for the following reasons:

- **Separation of Concerns:** MVVM provides a clear separation between UI and business logic, making the codebase more maintainable and scalable.
- **Reusability:** ViewModels can be reused across different views, reducing duplicated code.
- **Testability:** Isolating business logic in ViewModels makes it easier to write unit tests for the application.

### Unit Tests

- **BoardViewModel:** The logic for creating, updating, and deleting boards has been tested.
- **CardViewModel:** The card management functions, including adding, editing, and deleting cards, have been tested.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following:

- Xcode installed
- An active Firebase project for real-time synchronization and crash logging.

Also, make sure the following dependencies are added to your project target:

- **[FirebaseFirestore](https://firebase.google.com/):** For real-time data synchronization.
- **[FirebaseCrashlytics](https://firebase.google.com/):** For crash monitoring and logging.
- **[QRCode](https://github.com/EFPrefix/EFQRCode):** For QR code functionality.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/CollabCards.git
    ```

2. Open the project in Xcode:

    ```bash
    cd CollabCards
    open CollabCards.xcodeproj
    ```
3. Add the required dependencies using Swift Package Manager:

   ```bash
   - FirebaseFirestore
   - FirebaseCrashlytics
   - QRCode
    ```

4. Complete the Firebase configuration by adding your `GoogleService-Info.plist` file to the project.

5. Build and run the project.

## Usage

### Board Management

1. Open the app on your simulator or device.
2. Create a new board or select an existing one to start organizing your tasks.
3. Add cards to your board.

<p align="left">
  <img src="https://github.com/youf" alt="Board Management" width="200" height="400">
</p>

---

### Card Management 

1. Tap the "+" button to add a new card to a column.
2. Edit card details, such as the title and status, and move cards between columns.
3. Delete cards that are no longer needed.

<p align="left">
  <img src="https://github.com/us" alt="Card Management" width="200" height="400">
</p>

---

### Create Board

1. To create a new board, click on the "Create Board" option.
2. In the board creation screen, fields such as `username`, `password`, and `new board` must be filled out.
3. These fields cannot be left blank; if they are, the board creation process cannot be completed.

<p align="left">
  <img src="https://github.com/user-attachments/assets/fc826b9c-2f2e-4468-8617-475fdea9071e" alt="Create Board" width="200" height="400">
</p>

---

### Settings

1. Go to the settings view to customize your experience.
2. Toggle the visibility of your username and the date on the cards.
3. Adjust task duration settings to your preference.

<p align="left">
  <img src="https://github.com/yourusername/CollabCards/blob/main/Screenshots/SettingsGIF.gif" alt="Settings" width="200" height="400">
</p>

---

## Known Issues

- **QR Code Scanner:** The QR code scanner may sometimes respond slowly during scanning.
