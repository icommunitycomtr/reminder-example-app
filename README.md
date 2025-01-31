# Reminder Example App

A task management tool designed to help users create, manage, and track their reminders efficiently. Built using **Swift** and **UIKit**, this application provides a clean and intuitive interface for users to interact with their reminders.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Data Exchange](#data-exchange)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Screenshots](#screenshots)

---

## Overview

The Reminder application enables users to create, track, and manage reminders for specific dates and times. It uses **MVVM** to separate business logic (ViewModel) from the UI (View), and leverages **UserDefaults** for data persistence.

---

## Features

- **User-Friendly Interface**  
  A clean and intuitive UI that allows users to easily navigate through their reminders.

- **Date Selection**  
  The app provides a date picker and a custom horizontal date selector using `UICollectionView`, enabling precise date selection.

- **Dynamic Updates**  
  The application updates the reminder list dynamically as reminders are added or modified.

- **Dynamic Text Support**  
  The text fields and labels handle multiline and extended text gracefully.

- **UserDefaults Storage**  
  Reminders persist locally on the device through `UserDefaults` (managed by `StorageManager`).

- **Native Date Picker Components**  
  Utilizes Apple’s `UIDatePicker` for a consistent iOS look and feel.

- **Light/Dark Mode Support**  
  Uses system colors (`.label`, `.secondaryLabel`, etc.) to support dynamic appearance across both light and dark modes.

---

## Architecture

![MVVM Architecture Diagram](https://github.com/user-attachments/assets/c59af913-bf75-4e9c-9791-f44e831ef9e7)

The application adopts a **Model-View-ViewModel (MVVM)** architecture:

- **Model**  
  Represents the data structure of the reminders. The `Reminder` struct encapsulates properties such as title, date, and completion status.

- **View**  
  - Built programmatically using **UIKit**.
  - Includes `HomeViewController` (main screen with reminders list), `CreateViewController` (reminder creation screen), and custom UI components like `HomeTopView`.

- **ViewModel**  
  - `HomeViewModel` and `CreateViewModel` contain the core logic:
    - Filtering, toggling completion status, sorting reminders (`HomeViewModel`).
    - Managing new reminder creation (`CreateViewModel`).
  - Serves as the bridge between the Model and View, ensuring the View remains lightweight.

---

## Data Exchange

This project uses multiple patterns to pass data and events between components:

1. **Protocols & Delegates**  
   - `CreateViewModelOutputProtocol` and other protocol definitions allow the ViewModel to communicate changes back to the View.
   - `UITextViewDelegate`, `UIPopoverPresentationControllerDelegate`, and similar UIKit delegates handle UI events.

2. **Closures**  
   - In `DatePickerManager`, closures capture user-selected date/time and pass it back to the presenting controller.

3. **Observers (NotificationCenter)**  
   - When a new reminder is created, a `.didCreateNewReminder` notification is posted.  
   - `HomeViewController` listens for this notification to refresh the list dynamically.

4. **Dependency Injection**  
   - The `SceneDelegate` injects `HomeViewModel` into `HomeViewController`.
   - The `CreateViewController` is initialized with a `CreateViewModel` to ensure the ViewModel is available from creation time.

---

## Technologies Used

- **Swift**  
  The primary language for iOS development in this project.

- **UIKit**  
  For building the user interface programmatically (no Storyboards).

- **UserDefaults**  
  Used to persist and retrieve reminders through a dedicated `StorageManager`.

- **UIDatePicker**  
  Provides native date and time picking functionality.

- **UICollectionView & UITableView**  
  - `UICollectionView` for the horizontal date selector at the top of the home screen.
  - `UITableView` for listing reminders (with custom cells).

---

## Installation

1. **Clone the repository**  
   ```bash
   git clone https://github.com/yourusername/reminder-example-app.git
   ```
   This command will download all the project files to your local machine.
   
2. **Navigate into the Project Folder**
   ```bash
   cd reminder-example-app/Reminder
   ```
   Change your current directory to the folder that contains the Xcode project.
   
3. **Open the Project in Xcode**
   ```bash
   open Reminder.xcodeproj
   ```
   Launch the Xcode project by opening the .xcodeproj file
   
4. **Build and Run**
   - Select a simulator or a connected iOS device from the Scheme menu in the Xcode toolbar.
   - Click the Run (▶) button to build the project and launch the app.


---

## Usage

1. **Home Screen**
   - At the top, you’ll find a horizontal date selector implemented via a collection view.
   - Below the selector, a list of reminders is displayed for the currently focused date.

2. **Adding a Reminder**
   - Tap the **plus (+)** icon on the home screen to open `CreateViewController`.
   - Enter your reminder’s title, select the desired date/time, and tap **Save**.
   - The new reminder instantly appears on the home screen for the selected date.

3. **Viewing & Managing Reminders**
   - The `HomeViewController` dynamically filters and shows only the reminders belonging to the selected date.
   - Tap any reminder in the list to toggle its completion status (marked as complete or incomplete).

4. **Changing Dates**
   - Swipe or tap through the horizontal date selector to quickly view different dates.
   - Alternatively, tap the **calendar icon** (in `HomeTopView`) to use a date picker popover for more precise selection.

---

 ## Screenshots

| Image 1                | Image 2                | Image 3                |
|------------------------|------------------------|------------------------|
| ![emptyDarkHome](https://github.com/user-attachments/assets/d38393fd-b329-4cb2-a418-4a4989aa417b) | ![darkHome](https://github.com/user-attachments/assets/4ae0bd71-19ba-4584-a7da-2520d41f31ef) | ![darkAddReminder](https://github.com/user-attachments/assets/cdc627c4-1709-492b-bd39-84bb7777c076) |
| Empty Home (Dark Mode)    | Home (Dark Mode)    | Add Reminder (Dark Mode)    |

| Image 4                | Image 5                | Image 6                |
|------------------------|------------------------|------------------------|
| ![emptyLightHome](https://github.com/user-attachments/assets/100afb4a-c52a-45df-b093-089437ec996c) | ![lightHome](https://github.com/user-attachments/assets/0e692901-9601-4dd8-b918-47856b9e9cb1) | ![lightAddReminder](https://github.com/user-attachments/assets/37430490-d67a-47af-be0e-b6c670534b6a) |
| Empty Home (Light Mode)    | Home (Light Mode)    | Add Reminder (Light Mode)    |

| Image 7                | Image 8                | Image 9                |
|------------------------|------------------------|------------------------|
| ![dateHomeDark](https://github.com/user-attachments/assets/7f23fd27-0d70-4925-887e-7c274a876902) | ![dateAddDark](https://github.com/user-attachments/assets/9c121fcf-a4c2-4d61-b22f-5ee53fe6bf75) | ![hourAddDark](https://github.com/user-attachments/assets/ced37d16-cc8a-4c72-996d-5c0082df1b22) |
| Date Picker Home (Dark Mode)    | Date Picker Add Reminder Day (Dark Mode)    | Date Picker Add Reminder Hour (Dark Mode)    |

| Image 10                | Image 11                | Image 12                |
|------------------------|------------------------|------------------------|
| ![dateHomeLight](https://github.com/user-attachments/assets/e02ca480-7d32-4fc8-81a4-67f618f4f657) | ![dateAddLight](https://github.com/user-attachments/assets/151befaf-5f84-4db5-8479-1ea47c755c5d) | ![hourAddLight](https://github.com/user-attachments/assets/bd0d0445-c2c2-4434-bbe1-3b5cc053aa6b) |
| Date Picker Home (Light Mode)    | Date Picker Add Reminder Day (Light Mode)    | Date Picker Add Reminder Hour (Light Mode)    |
