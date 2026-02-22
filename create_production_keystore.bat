@echo off
echo ========================================
echo    JOBBER APP - Production Keystore Setup
echo ========================================
echo.
echo This will create a production keystore for Play Store deployment.
echo IMPORTANT: Keep the keystore file and passwords SAFE!
echo You cannot update your app without them.
echo.
pause

echo Creating production keystore...
echo.

REM Create keystore with production-ready settings
keytool -genkey -v ^
  -keystore jobber-release-key.jks ^
  -keyalg RSA ^
  -keysize 2048 ^
  -validity 25000 ^
  -alias jobber-key ^
  -dname "CN=Jobber App, OU=Mobile Development, O=Jobber Technologies, L=Mumbai, ST=Maharashtra, C=IN" ^
  -storepass JobberApp2024! ^
  -keypass JobberApp2024!

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo    KEYSTORE CREATED SUCCESSFULLY!
    echo ========================================
    echo.
    echo Keystore Details:
    echo File: jobber-release-key.jks
    echo Store Password: JobberApp2024!
    echo Key Password: JobberApp2024!
    echo Key Alias: jobber-key
    echo Validity: 68+ years
    echo.
    echo CRITICAL: Save these details securely!
    echo.
    
    REM Update key.properties automatically
    echo Updating key.properties file...
    echo storePassword=JobberApp2024!> android\key.properties
    echo keyPassword=JobberApp2024!>> android\key.properties
    echo keyAlias=jobber-key>> android\key.properties
    echo storeFile=../jobber-release-key.jks>> android\key.properties
    
    echo key.properties updated successfully!
    echo.
    echo Ready to build production AAB!
    
) else (
    echo.
    echo ERROR: Failed to create keystore.
    echo Please ensure Java/keytool is installed and try again.
)

echo.
pause