@echo off
echo ========================================
echo  Job Application Analytics Migration
echo ========================================
echo.

echo 🚀 Starting migration process...
echo.

echo 📋 Step 1: Running migration script
node migrate_applications_to_main_document.js

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Migration failed! Please check the error logs.
    pause
    exit /b 1
)

echo.
echo ✅ Migration completed successfully!
echo.

echo 📋 Step 2: Running verification tests
echo.
flutter run test_enhanced_analytics_system.dart

if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Some tests failed. Please review the results.
) else (
    echo ✅ All tests passed!
)

echo.
echo 📋 Next Steps:
echo    1. Review the test results above
echo    2. Test the new analytics dashboard in your app
echo    3. Verify application data integrity
echo    4. Update your application submission code to use EnhancedJobApplicationService
echo    5. Consider running cleanup script after verification
echo.

echo 🎉 Migration process completed!
echo.
pause