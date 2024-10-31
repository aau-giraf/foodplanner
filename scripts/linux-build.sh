#!/bin/bash
cd ../foodplanner
flutter clean
flutter pub get
flutter build linux
flutter run --host-vmservice-port=8081