# Foodplanner

## Setting up the local development environment
To install dependencies.

`dart pub get`

### Generate API
Running the application requires generating the API code using OpenAPI. Before running the command below, **the backend must be running**.

`dart run build_runner build --delete-conflicting-outputs`