# Windsurf Rules for Tanga iOS

This document outlines the coding conventions and patterns to maintain consistency and quality in the Tanga iOS project.

## Architecture

*   **MVVM (Model-View-ViewModel):** Adhere to the MVVM architectural pattern for structuring features.
    *   ViewModels should be observable and emit state variations.
    *   Views should be responsible for rendering UI based on ViewModel state.
    *   Models should encapsulate data and business logic.
*   **Repository Pattern:** Use the repository pattern for data access, particularly for Firebase Firestore resources. Repositories should abstract data sources from ViewModels.

## Code Style & Linting

*   **SwiftLint:** This project uses SwiftLint to enforce code style. All code should comply with the rules defined in `.swiftlint.yml`. Key rules include:
    *   `line_length`: warning at 150, error at 200 (ignores function declarations, comments, URLs).
    *   `function_body_length`: warning at 300, error at 500.
    *   `function_parameter_count`: warning at 6, error at 8.
    *   `type_body_length`: warning at 300, error at 500.
    *   `file_length`: warning at 1000, error at 1500 (ignores comment-only lines).
    *   `cyclomatic_complexity`: warning at 15, error at 25.
    *   Opt-in rules: `empty_count`, `empty_string`.
    *   Disabled rules: `trailing_whitespace`.
*   **Git Hooks:** Pre-commit Git hooks are in place to run linters. Ensure these hooks are set up as per the README instructions.

## Specific SwiftUI rules

  You are an expert iOS developer using Swift and SwiftUI. Follow these guidelines:


  # Code Structure

  - Use Swift's latest features and protocol-oriented programming
  - Prefer value types (structs) over classes
  - Use MVVM architecture with SwiftUI
  - Structure: Features/, Data/, Errors/, Models/
  - Follow Apple's Human Interface Guidelines if not UI guidelines is provided

  
  # Naming
  - camelCase for vars/funcs, PascalCase for types
  - Verbs for methods (fetchData)
  - Boolean: use is/has/should prefixes
  - Clear, descriptive names following Apple style


  # Swift Best Practices

  - Strong type system, proper optionals
  - async/await for concurrency
  - Result type for errors
  - @Published, @StateObject for state
  - Prefer let over var
  - Protocol extensions for shared code


  # UI Development

  - SwiftUI first, UIKit only when needed
  - SafeArea and GeometryReader for layout
  - We only support phones in portrait orientation for now
  - Implement proper keyboard handling


  # Performance

  - Profile with Instruments
  - Lazy load views and images
  - Optimize network requests
  - Background task handling
  - Proper state management
  - Memory management


  # Data & State

  - UserDefaults for preferences
  - Async/Await for data fetching 


  # Testing & Quality

  - Testing for unit tests
  - Test common user flows
  - Error scenarios


  # Essential Features

  - Deep linking support (not yet implemented)
  - Push notifications
  - Background tasks
  - Error handling
  - Analytics/logging
  - In-app purchases
  - Feature flags (not yet implemented)


  # Development Process

  - Use SwiftUI previews
  - Git branching strategy
  - Code review process
  - CI/CD pipeline (we use GitHub Actions)
  - Documentation


  # App Store Guidelines

  - Privacy descriptions
  - App capabilities
  - In-app purchases
  - Review guidelines
  - App thinning
  - Proper signing


  Follow Apple's documentation for detailed implementation guidance.

## Naming Conventions

*   **Types (classes, structs, enums, protocols):** Use UpperCamelCase (e.g., `MyClass`, `MyStruct`).
*   **Functions and Methods:** Use lowerCamelCase (e.g., `myFunction()`).
*   **Constants and Variables:** Use lowerCamelCase (e.g., `myConstant`, `myVariable`).
*   **Private members:** Consider prefixing with an underscore `_` if it aligns with team preference (though not strictly enforced by Swift conventions, it was not observed in the sample).


## Testing

*   **Unit Tests:** Write unit tests for ViewModels, interactors, repositories, and other business logic components. Aim for good test coverage of these critical parts of the application. Store these in the `TangaTests` target.
*   **UI Tests:** Implement UI tests for key user flows to ensure the application behaves as expected from a user perspective. Store these in the `TangaUITests` target.
*   Strive to follow testing best practices, such as Arrange-Act-Assert.

## Dependencies

*   **Firebase:** Used extensively for backend services (Authentication, Firestore, Analytics, Crashlytics, Remote Config, Performance Monitoring, Messaging, Storage).
*   **RevenueCat:** Used for in-app purchases and subscriptions.
*   Manage dependencies carefully and keep them up-to-date using Dependabot.

## Documentation

*   Document new features and significant code changes.
*   Update the README.md as the project evolves.

## Best Practices

*   Write clear and concise code.
*   Optimize for performance where necessary.
*   Handle errors gracefully.
*   Follow Apple's Human Interface Guidelines for UI/UX design.

## Collaboration

*   Use pull requests for code review.
*   Address feedback from reviewers before merging.

## Product Principles

*   **Core Value:** Deliver a solid foundation of book summaries, offering both text and audio formats for user convenience.
*   **Affordability & Engagement:** Strive to make Tanga accessible and move beyond a traditional, potentially "boring" summary app experience.
*   **AI-Driven Innovation:** Actively explore and implement AI-powered features to provide unique value and help users get the most out of book content without necessarily reading the entire book. The aim is to offer more than just text and audio.

---

This is a living document and will be updated as the project evolves.
