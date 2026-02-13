@echo off
echo Building AAB file...
echo.

echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building AAB file...
flutter build appbundle --release

echo.
echo Build completed!
echo AAB file location: build\app\outputs\bundle\release\app-release.aab
pause