# GIRAF Foodplanner

GIRAF Foodplanner is a Flutter-based application designed to streamline meal planning. The app integrates a Flutter frontend with an ASP.NET backend connected to a PostgreSQL database. This project is part of the GIRAF ecosystem and is optimized for iOS devices.

## Features

- **User Roles**: Customizable roles like teacher or parent for tailored experiences.
- **Meal Planning**: Create, edit, and manage daily meal plans.
- **Responsive Design**: Optimized for iOS devices, particularly iPhones.
- **Backend Integration**: Powered by an ASP.NET backend connected to a PostgreSQL database.

## Technologies Used

- **Frontend**: Flutter
- **Backend**: ASP.NET
- **Database**: PostgreSQL
- **Build Tools**: Xcode (for iOS development)

## Project Structure

```plaintext
lib/
├── components/          # Reusable UI components
├── config/              # Default design variables including colors and Text formats.
├── models/              # Data models and domain entities
├── pages/               # Application screens (pages)
├── routes/              # Route handling by GoRouter
├── services/            # API and database interaction
```

## Getting Started

### Prerequisites

Ensure you have the following installed:
	•	Flutter SDK
	•	Xcode (for iOS development)
	•	ASP.NET Core SDK
	•	PostgreSQL

### Installation

1.	Clone the repository:
```bash
git clone https://github.com/your-username/giraf-foodplanner.git
```
2. Navigate to the project directory:
```bash
cd giraf-foodplanner
```
3. Install dependencies
```bash
flutter pub get
```

## Setting Up the Backend
Follow the setup information in the ASP.NET backend repository: [foodplanner-api](https://github.com/aau-giraf/foodplanner-api).

## Running the App for the First Time
1.	Connect your iOS device or start an iOS simulator.
2.	Configure the API base URL in the ```lib/services/api_service.dart``` file to point to your running backend.
3.	Run the app using Flutter:
```bash
flutter run
```
For IOS-specific builds:
```bash
flutter build ios
open ios/Runner.xcworkspace
```
Then build and run using Xcode.

## Troubleshooting
- <b>Missing Dependencies:</b> Ensure you’ve run ```flutter pub get``.
- <b>Backend Not Connecting:</b> Verify the API URL and ensure the backend service is running.
- <b>iOS Build Issues:</b> Open the project in Xcode and ensure signing and team credentials are correctly configured.


# Contributing
Contributions are welcome! Follow these steps:
1. Create a branch for your feature or bugfix:
```bash
git checkout -b feature-name
```
2. Commit your changes:
```bash
git commit -m "Add feature name"
```
3. Push to the branch:
```bash
git push origin feature-name
```
5. Open a pull request to staging, test it out, and then create a new one for the main.


