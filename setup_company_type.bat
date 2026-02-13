@echo off
echo Setting up Company Type dropdown in Firebase...
echo.

echo Checking if Node.js is installed...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo Checking if firebase-admin is installed...
npm list firebase-admin >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing firebase-admin...
    npm install firebase-admin
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install firebase-admin
        pause
        exit /b 1
    )
)

echo.
echo Running Firebase setup script...
node setup_company_type_firebase.js

if %errorlevel% equ 0 (
    echo.
    echo SUCCESS: Company Type dropdown has been set up in Firebase!
    echo The dropdown should now work in the candidate registration screen.
) else (
    echo.
    echo ERROR: Setup failed. Please check your Firebase credentials.
    echo Make sure you have:
    echo 1. Firebase CLI installed and logged in
    echo 2. Proper permissions to write to Firestore
    echo 3. GOOGLE_APPLICATION_CREDENTIALS environment variable set
)

echo.
pause