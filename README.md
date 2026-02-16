🗓️ WidgetKit Integration 

The widget was implemented using the WidgetKit framework combined with SwiftUI. The integration of the widget was chosen because widgets are a modern feature of iOS applications and many users use them daily as part of their home screen. The widget therefore works as a simple calendar and supports regular interaction with the application without the need to manually search for the app in the menu.

📌 Widget Content and Visual Elements

The widget displays:

    • the current day of the week
    • the current date (dominant day number)
    • an emoji as a visual element representing the day
    • a subtle background calendar view of the month

🎲 Dynamic Emoji System (Random Selection)

The widget contains a set of multiple emojis stored in the application. Every day, one emoji is automatically selected randomly from this set, ensuring variability and preventing the widget from appearing static.

⏱️ Automatic Widget Updates

The widget uses the timeline mechanism in WidgetKit. The update is set so that the widget refreshes automatically every day. This ensures:

    • correct display of the current date
    • automatic emoji change
    • consistent functionality without the need for manual refresh

📅 Calendar Logic of the Application

The main functionality of the application is based on a calendar system, which serves as the main navigation element. Using the Calendar API, the application generates the correct structure of days for the current month and allows switching between months. Each day represents an individual content unit. After selecting a date, the day is stored as an active state and the application displays or generates the corresponding daily content (motivation, challenge, or reflection).

🌟 Daily Content Generation (Motivation / Challenge / Reflection)

The application follows the principle “one day = one content” to prevent overwhelming the user with multiple activities at once. Daily content is selected from predefined lists and can be:

    • Motivation – a short encouraging message
    • Mini challenge – a simple daily task
    • Reflection:
            o a reflective question is generated for a specific day
            o after clicking “Open reflection”, a white canvas (text field) opens
            o the user can write their own answer
            o the answer is saved and remains linked to the specific day

🔒 Locking Future Days

The application uses date validation with Date() and Calendar, comparing the selected day with the current system date. If the user selects a future day, the daily content is not displayed, an informational card “Unlocks at midnight” appears, and it is not possible to mark the day as completed.
 
✅ Marking Content as Completed and Visual Changes

The user can mark daily content as completed using the “Mark as completed” button. After pressing the button, the state of the selected day is updated in the data model (e.g., completed = true) and the change is immediately reflected in the user interface.
The UI update includes:
    • displaying the status “completed” on the content card
    • displaying a completion indicator in the calendar (green dot)

🔥 Streak System

The streak system was implemented as a calculation logic based on the application’s data model. Each day contains a state value (e.g., completed) which determines whether the daily content has been completed. Based on these stored values, the application evaluates the number of completed days in the current month when loading the calendar.


![IMG_7277](https://github.com/user-attachments/assets/91d3188d-fe5a-433f-b6db-2dee032fe5b1)

![IMG_7278](https://github.com/user-attachments/assets/9cb5718e-2d7b-40bf-b9cc-4d8b9c07b1ec)
![IMG_7279](https://github.com/user-attachments/assets/f809f0ee-2268-4c5b-93a1-33cbf341efdb)

![IMG_7280](https://github.com/user-attachments/assets/4c9f9a92-d0ac-4ca3-977d-5b2d5ba49fb5)










