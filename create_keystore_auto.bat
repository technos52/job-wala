@echo off
echo Creating keystore automatically for release signing...
echo.

REM Create keystore with default values - you can change these later
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass jobber123 -keypass jobber123 -dname "CN=Jobber App, OU=Development, O=Jobber, L=City, S=State, C=US"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Keystore created successfully!
    echo File: upload-keystore.jks
    echo Store Password: jobber123
    echo Key Password: jobber123
    echo Alias: upload
    echo.
    echo IMPORTANT: Change these passwords in production!
) else (
    echo.
    echo Error creating keystore. Please check if Java/keytool is installed.
)

pause