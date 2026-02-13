#!/bin/bash

echo "Building JobEase Admin Panel for Web Deployment..."
echo

# Clean any previous builds
echo "Cleaning previous builds..."
flutter clean
flutter pub get
echo

# Build the admin panel for web
echo "Building admin panel for web..."
flutter build web --target=lib/admin_main.dart --web-renderer html --release
echo

# Deploy to Firebase Hosting
echo "Deploying to Firebase Hosting..."
firebase deploy --only hosting
echo

echo "========================================"
echo " JobEase Admin Panel Deployed!"
echo " Access your admin panel at:"
echo " https://jobease-edevs.web.app"
echo "========================================"
echo