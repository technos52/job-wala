#!/bin/bash

echo "🧹 Starting Clean Build Process..."
echo

echo "📱 Step 1: Flutter Clean"
flutter clean
if [ $? -ne 0 ]; then
    echo "❌ Flutter clean failed"
    exit 1
fi
echo "✅ Flutter clean completed"
echo

echo "📦 Step 2: Get Dependencies"
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Flutter pub get failed"
    exit 1
fi
echo "✅ Dependencies downloaded"
echo

echo "🔥 Step 3: Clear Firebase Cache"
rm -rf build
rm -rf .dart_tool
echo "✅ Build cache cleared"
echo

echo "🏗️  Step 4: Build APK (Debug)"
flutter build apk --debug
if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ APK built successfully"
echo

echo "📱 Step 5: Install and Run on Device"
flutter install
if [ $? -ne 0 ]; then
    echo "❌ Installation failed"
    exit 1
fi
echo "✅ App installed on device"
echo

echo "🚀 Step 6: Launch App"
flutter run --debug
if [ $? -ne 0 ]; then
    echo "❌ App launch failed"
    exit 1
fi

echo
echo "🎉 Clean build and run completed successfully!"
echo "📱 App should now be running on your device with fresh data"
echo