#!/bin/bash
echo "Building AAB file for Play Store deployment..."
echo

echo "Step 1: Cleaning previous builds..."
flutter clean

echo "Step 2: Getting dependencies..."
flutter pub get

echo "Step 3: Building AAB file..."
flutter build appbundle --release

echo
echo "Build completed!"
echo "AAB file location: build/app/outputs/bundle/release/app-release.aab"
echo
echo "Next steps:"
echo "1. Test the AAB file using bundletool (optional)"
echo "2. Upload to Google Play Console"
echo