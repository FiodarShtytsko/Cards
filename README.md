# Cards - iOS App with Firebase Remote Config

## Getting Started

This iOS application showcases the integration and dynamic control of content using Firebase Remote Config. Detailed below are instructions for configuring and testing the app's response to changes in Firebase Remote Config.

### Prerequisites

- **Xcode:** 15.0
- **iOS:** 15.0
- **Swift Package Manager (SPM):** Used for managing dependencies.

### Installation

1. **Clone the repository.
2. **Open the project in Xcode:**
   Open `.xcodeproj` or `.xcworkspace` file. Dependencies are managed through SPM and should resolve automatically.

## Configuring Firebase Remote Config

The app relies on certain properties defined in Firebase Remote Config. Here’s how to set them up and modify them:

### Firebase Properties

The key properties used by the app include:

1. **`id` (Integer):** Unique identifier for each card. 
   - *Example:* `2`

2. **`name` (String):** A descriptive name for the card.
   - *Example:* `"card_2"`

3. **`image_url` (String):** URL of the image displayed on the card.
   - *Example:* `"https://via.placeholder.com/600/771796"`
   - This URL points to an image resource on the web. Changing this URL in the FRC will change the image displayed in the app.

4. **`priority` (Integer):** Determines the display order of the cards.
   - *Example:* `2`
   - Cards with lower priority numbers are displayed first.

### Steps to Modify Config Values

1. **Access Firebase Console:**
   - Go to [Firebase Console](https://console.firebase.google.com/).
   - Choose the associated project.

2. **Edit Remote Config:**
   - Open Remote Config
   - On the left-hand side panel, look for the "Remote Config" option. It might be under a section like "Engage" or directly accessible on the panel.
   - Click on "Remote Config" to manage the parameters for your app.

3. **Publish Changes:**
   - Save and publish your changes.
   - It might take some time for changes to propagate to all users due to caching.

## Testing the App

After updating Remote Config:

1. **Run the App:**
   - Compile and run the app on an emulator or device.

2. **Verify Changes:**
   - Check if the app reflects the changes made in Firebase Remote Config.
   - For instance, updating `image_url` should change the respective image in the app.

## Troubleshooting

- **Changes Not Reflecting:**
  - Ensure the app has a proper internet connection.
  - Remember, changes may not be instantaneous.

- **Linking Issues:**
  - Verify that the Firebase project is correctly linked to your iOS app.
