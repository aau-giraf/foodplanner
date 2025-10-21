# foodplanner

A new Flutter project.

## Getting Started

This is a short explanation of how to get the app running locally.

Initial setup:

0. Setup the backend project and make sure all services are running
1. Install Flutter + Dart
2. Clone the repo locally
3. Install dependencies: `dart pub get`
4. (This step requires backend services) Generate frontend: `dart run build_runner build --delete-conflicting-outputs`
5. Open Flutter in the browser: `flutter run -d chrome --web-port=8081`


Whenever you make changes to the code, you'll need to repeat step 4.


### Troubleshooting Windows


### Troubleshooting Linux/Unix

`Chrome isn't found` when `flutter run -d chrome --web-port=8081`: Make sure that chrome is installed, and `CHROME_EXECUTABLE` is configured
