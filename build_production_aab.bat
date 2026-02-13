@echo off
echo ========================================
echo    JOBBER APP - Production AAB Build
echo ========================================
echo.

REM Check if keystore exists
if not exist "jobber-release-key.jks" (
    echo ERROR: Production keystore not found!
    echo Please run create_production_keystore.bat first.
    pause
    exit /b 1
)

echo Building production AAB with release signing...
echo.

echo Step 1: Cleaning previous builds...
flutter clean

echo Step 2: Getting dependencies...
flutter pub get

echo Step 3: Building production AAB...
flutter build appbundle --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo    BUILD SUCCESSFUL!
    echo ========================================
    echo.
    echo Production AAB created at:
    echo build\app\outputs\bundle\release\app-release.aab
    echo.
    echo File size:
    for %%I in ("build\app\outputs\bundle\release\app-release.aab") do echo %%~zI bytes
    echo.
    echo This AAB is signed with your production keystore and ready for Play Store!
    echo.
    echo Next steps:
    echo 1. Test the AAB (optional)
    echo 2. Upload to Google Play Console
    echo 3. Fill in store listing details
    echo 4. Submit for review
    echo.
) else (
    echo.
    echo BUILD FAILED!
    echo Please check the error messages above.
)

pause