@echo off
echo 🧹 Starting Clean Build Process...
echo.

echo 📱 Step 1: Flutter Clean
flutter clean
if %errorlevel% neq 0 (
    echo ❌ Flutter clean failed
    pause
    exit /b 1
)
echo ✅ Flutter clean completed
echo.

echo 📦 Step 2: Get Dependencies
flutter pub get
if %errorlevel% neq 0 (
    echo ❌ Flutter pub get failed
    pause
    exit /b 1
)
echo ✅ Dependencies downloaded
echo.

echo 🔥 Step 3: Clear Firebase Cache (if exists)
if exist "build" rmdir /s /q build
if exist ".dart_tool" rmdir /s /q .dart_tool
echo ✅ Build cache cleared
echo.

echo 🏗️  Step 4: Build APK (Debug)
flutter build apk --debug
if %errorlevel% neq 0 (
    echo ❌ Build failed
    pause
    exit /b 1
)
echo ✅ APK built successfully
echo.

echo 📱 Step 5: Install and Run on Device
flutter install
if %errorlevel% neq 0 (
    echo ❌ Installation failed
    pause
    exit /b 1
)
echo ✅ App installed on device
echo.

echo 🚀 Step 6: Launch App
flutter run --debug
if %errorlevel% neq 0 (
    echo ❌ App launch failed
    pause
    exit /b 1
)

echo.
echo 🎉 Clean build and run completed successfully!
echo 📱 App should now be running on your device with fresh data
echo.
pause