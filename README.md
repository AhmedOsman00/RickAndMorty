# Rick and Morty

Rick and Morty is a modular iOS application that displays a list of characters from the Rick and Morty series along with detailed information for each character. This application follows clean architecture principles and leverages modern iOS technologies to ensure maintainability, scalability, and efficiency.

## Features

- **Swift Concurrency with async/await** for smooth and non-blocking API calls
- **Clean Architecture** for enhanced modularity and separation of concerns
- **Modularization** to separate core and feature functionalities
- **Combine Framework** for reactive programming and data binding
- **UIKit & SwiftUI** integration for a versatile and modern UI
- **Efficient Dependency Management** using a custom dependency injection container
- **String Catalogue** for centralized and localized string management
- **Unit Testing** to ensure robust functionality and code quality

<p align="center">
  <img src="README Files/1.png" alt="Screenshot 1" width="30%">
  <img src="README Files/2.png" alt="Screenshot 2" width="30%">
  <img src="README Files/3.png" alt="Screenshot 3" width="30%">
</p>

---

## Getting Started

### Requirements

- Xcode 16.0 or newer
- Minimum iOS version: 15

### Running the Application

Clone the repository, open the project in Xcode, and select a target device or simulator. Then, build and run the app.

```bash
git clone https://github.com/AhmedOsman00/RickAndMorty.git
cd rickandmorty
open rickandmorty.xcodeproj
```

Please change the remote URL if you using SSH to `git@github.com:AhmedOsman00/RickAndMorty.git`

## Architecture

This application is built following **Clean Architecture** and **modularization** principles to separate concerns and improve testability.

### Modular Structure

The project is divided into multiple modules to isolate functionalities and promote reusability:

1. **Core Modules**: Shared across feature modules and include:

   - **Networking**: Manages network requests using Swift concurrency for non-blocking API calls.
   - **UIExtensions**: Contains reusable UIKit and SwiftUI extensions to enhance the UI.
   - **Resources**: Houses all assets like images, colors, and localizable strings via a **String Catalogue**.

2. **Feature Modules**:
   - Each feature module is structured into **Data**, **Domain** (optional), and **Presentation** layers.
   - **Presentation** follows the **MVVM (Model-View-ViewModel)** pattern with a blend of UIKit and SwiftUI.
   - **Combine** is used for data binding between ViewModels and Views, ensuring a responsive UI.

---

### Dependency Injection

A custom **Dependency Injection Container** is implemented to manage dependencies and support **Dependency Inversion**. This container allows each module to define its dependencies, ensuring a clear and isolated architecture.

> **Note**: Currently, this container does not support threading. Dependency instances should be accessed on the main thread.

---

### Navigation

Navigation is managed by **Routers**, which handle the flow between screens in a modular and maintainable way.

---

## Usage

To fetch and view character information, simply open the app. You’ll see a list of characters, and selecting one will show detailed information.

---

## Unit Testing

This project uses **Swift Testing** to validate the logic within core and feature modules. Unit tests cover networking, data transformations, and ViewModel behaviors to ensure reliability and maintainability.

---

## Future Enhancements

- **Thread-Safe Dependency Injection**: Improve the DI container to support multithreading.
- **UI Testing**: Implement UI tests to validate interactions and user flows.
- **Improve Code Coverage**: Add more unit tests to improve the code coverage.
