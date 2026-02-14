💡 Idea
The application is an iOS app developed using SwiftUI, focused on supporting mental well-being and encouraging daily self-reflection.
Its main purpose is to provide users with a simple and calming space for motivation, reflection, and building positive habits without overwhelming them with too much content.
The app is designed to be minimalistic, user-friendly, and structured around consistent daily engagement.

🏗️ Architecture & Structure
The project is built using a modular approach with cleanly separated SwiftUI views and a well-structured data model.
The main development focus is placed on:
  •	maintainability and scalability
  •	simplicity in UI/UX
  •	clear separation of features
  •	clean and structured codebase
The overall architecture ensures that the application can easily be extended with additional content types and new features in the future.

🗓️ WidgetKit Integration
The application integrates WidgetKit to provide a calendar-based widget that enhances daily accessibility and user engagement.
The widget:
  •	displays the current day using a dynamically changing emoji
  •	automatically updates every day
  •	works as a quick entry point into the application
  •	opens a detailed calendar view when tapped
This allows users to interact with the app directly from their home screen, making daily check-ins more natural and effortless.

✅ Core Features
📅 Calendar-Based System
The app is structured around a calendar logic, where each day represents a unique entry point.
The calendar functions as the main navigation element and encourages users to return regularly.

🌟 Daily Generated Content
Each day, the application generates exactly one content type, ensuring the experience stays minimal and consistent.
Daily content can be:
  •	a motivational message
  •	a simple daily challenge
  •	a reflection question
This design prevents content overload while supporting daily personal development and mental clarity.

🔄 Consistent Daily Engagement
Because content is tightly integrated with both the calendar system and the widget, the application naturally supports:
  •	daily user interaction
  •	habit-building routines
  •	structured self-reflection

⚙️ Technologies Used
  •	SwiftUI – UI development and modular screen structure
  •	WidgetKit – home screen widget integration
  •	Calendar Logic – date-driven content generation and navigation
  •	Dynamic Emoji System – emoji updates automatically each day
  •	Clean Data Model – structured data handling for daily content

🔄 App Flow Overview
1.	The user sees the widget on the home screen
2.	The widget displays the current day using an emoji
3.	The widget updates automatically each day
4.	The user taps the widget
5.	The app opens directly into the detailed calendar view
6.	The user selects a specific day
7.	The app displays one daily-generated content type:
   • motivational message / daily challenge / reflection question
8.	The cycle repeats the next day with new content








