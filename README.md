# Foodplanner

## Setting up the local development environment
To install dependencies.

`dart pub get`

### Generate API
Running the application requires generating the API code using OpenAPI. Before running the command below, **the backend must be running**.

`dart run build_runner build --delete-conflicting-outputs`

### Running tests
Tests are found under the test folder. You can run them in vscode by right clicking a folder with tests in it and clicking 'Run Tests' in vscode.
Or use your terminal.

To run **all** tests, run this command
`flutter test test`
To run **page_tests**
`flutter test test/page_tests`
To run **service_tests** run
`flutter test test/service_tests`