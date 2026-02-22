@echo off
echo ========================================
echo    KEYSTORE VERIFICATION
echo ========================================
echo.

if exist "jobber-release-key.jks" (
    echo ✓ Keystore file found: jobber-release-key.jks
    echo.
    echo Keystore details:
    keytool -list -v -keystore jobber-release-key.jks -storepass "JobberApp2024!"
) else (
    echo ✗ Keystore file NOT found!
    echo Please run create_production_keystore.bat first.
)

echo.
if exist "android\key.properties" (
    echo ✓ Key properties file found
    echo.
    echo Contents:
    type android\key.properties
) else (
    echo ✗ Key properties file NOT found!
)

echo.
pause