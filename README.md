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
- **Image Database**: Minio
- **Build Tools**: Xcode (for iOS development)

## Project Structure

```plaintext
lib/
├── api/          	 # Auto generated Endpoints
├── auth/          	 # Authentication components
├── components/          # Reusable UI components
├── config/              # Default design variables including colors and Text formats.
├── models/              # Data models and domain entities
├── pages/               # Application screens (pages)
├── routes/              # Route handling by GoRouter
└── services/            # API and database interaction
```

## Getting Started

### Prerequisites

Ensure you have the following installed:
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Xcode](https://developer.apple.com/xcode/) (for iOS development)
- [ASP.NET Core SDK](https://dotnet.microsoft.com/en-us/download)
- [PostgreSQL](https://www.postgresql.org/download/)


### Setting Up the Backend
To generate API endpoints, the backend needs to have been started, to provide the OpenAPI spec.
Follow the setup information in the ASP.NET backend repository: [foodplanner-api](https://github.com/aau-giraf/foodplanner-api).

### Setup the project

1.	Clone the repository:
```bash
git clone https://github.com/aau-giraf/foodplanner.git
```
2. Navigate to the project directory:
```bash
cd foodplanner/foodplanner
```
3. Install dependencies
```bash
dart pub get
```
4. Generate API endpoints
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Running the App for the First Time
1.  Connect your iOS device, start an iOS simulator, or run it in Chrome.
2.  Configure the API base URL in the ```lib/services/api_service.dart``` file to point to your running backend.
3.  Configure the image API hardcoded URL in the ```lib/components/image.dart``` file to point to your Minio instance (as described in foodplanner-api).
4.  Run the app using Flutter:
```bash
flutter run
```
To run the app in Chrome
```bash
flutter run -d chrome --web-port=8081
```

## Troubleshooting
- <b>Missing Dependencies:</b> Ensure you’ve run ```flutter pub get```.
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
5. Open a pull request to the staging branch, test it, and then create a new pull request for main.


