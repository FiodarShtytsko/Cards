# Cards - iOS App with Firebase Remote Config

This iOS application demonstrates the use of Firebase Remote Config (FRC) to dynamically control and update content displayed in the app. This README provides instructions on how to manipulate the FRC to test different behaviors in the app.

## Getting Started

These instructions will get you up and running with a copy of the project on your local machine for development and testing purposes.

### Prerequisites

- Xcode 15.0
- iOS 15.0
- Swift Package Manager (SPM) for dependency management

### Installation

1. Clone the repository
2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode. Xcode should automatically resolve and fetch the dependencies using SPM.

## Configuring Firebase Remote Config

To modify the Firebase Remote Config values, follow these steps:

1. **Login to Firebase Console:**
   - Access the Firebase Console at [Firebase Console](https://console.firebase.google.com/).
   - Select the project linked to this app.

2. **Navigate to Remote Config:**
   - In the Firebase project dashboard, go to `Grow` > `Remote Config`.

3. **Modify Config Values:**
   - You will see parameters that the app uses. For example, you might have a parameter representing a JSON object like this:
     ```json
     {
       "id": 2,
       "name": "card_2",
       "image_url": "https://via.placeholder.com/600/771796",
       "priority": 2
     }
     ```
   - Click on the parameter to modify its value.
   - Update the JSON structure as needed, ensuring that it matches the format expected by the app.
   - Save the changes.

4. **Publish Changes:**
   - After making changes to the config values, click `Publish changes` to make these changes effective.

## Testing the App

Once you have made changes in the Firebase Remote Config:

1. **Run the App:**
   - Build and run the app in Xcode on an emulator or physical device.

2. **Observe Changes:**
   - The app should reflect the changes made in the Firebase Remote Config.
   - For example, changing the `image_url` in the JSON object in FRC should update the image displayed in the app.

## Troubleshooting

- If changes are not reflecting, ensure the app has a proper internet connection and there are no caching issues.
- Make sure that the Firebase project is correctly linked to your app.
