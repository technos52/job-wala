@echo off
echo Building JobEase Admin Panel...

:: Build Flutter web app with admin main
flutter build web --web-renderer html --target lib/admin_panel/admin_main.dart --output build/admin_web

:: Check if build succeeded
if exist "build\admin_web" (
    echo Copying admin files...
    
    :: Create admin directory if it doesn't exist
    if not exist "web\admin" mkdir "web\admin"
    
    :: Copy all built files to admin directory
    xcopy "build\admin_web\*" "web\admin\" /E /Y /Q
    
    echo ✅ Admin panel built successfully!
    echo 📁 Files available in: web\admin\
    echo 🌐 Deploy admin directory to your hosting service
) else (
    echo ❌ Build failed - admin_web directory not found
    pause
)