@echo off
echo Creating keystore for release signing...
echo.
echo Please provide the following information when prompted:
echo - Use a strong password for the keystore
echo - Use the same password for the key
echo - Fill in your organization details
echo.
pause

keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

echo.
echo Keystore created successfully!
echo IMPORTANT: Keep the upload-keystore.jks file and passwords safe!
echo You'll need them for future app updates.
pause