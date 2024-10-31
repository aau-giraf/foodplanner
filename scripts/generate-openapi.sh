#!/bin/bash
cd ../foodplanner
dart pub get
dart run build_runner build --delete-conflicting-outputs