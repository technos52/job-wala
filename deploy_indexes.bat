@echo off
echo Deploying Firestore indexes...
firebase deploy --only firestore:indexes
echo.
echo Index deployment complete!
echo Note: It may take a few minutes for the indexes to build in Firebase.
pause