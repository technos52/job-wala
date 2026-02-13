@echo off
echo ===============================================
echo   Creating Admin User in Firestore
echo ===============================================
echo.

echo Step 1: Opening Firestore Console...
start https://console.firebase.google.com/project/jobease-edevs/firestore

echo.
echo Step 2: Follow these instructions in the console:
echo.
echo 1. Click "Start collection"
echo 2. Collection ID: admins
echo 3. Click "Next"
echo 4. Document ID: c1KEyBgDJFhwhiz6hZe1uOvU1Da2
echo 5. Add the following fields:
echo.
echo    Field 1:
echo    - Field name: isAdmin
echo    - Field type: boolean
echo    - Field value: true
echo.
echo    Field 2:
echo    - Field name: email
echo    - Field type: string
echo    - Field value: technos52h@gmail.com
echo.
echo 6. Click "Save"
echo.
echo ===============================================
echo  After completing the steps above:
echo  Visit: https://jobease-52.web.app
echo  Login with: technos52h@gmail.com
echo ===============================================
echo.

pause