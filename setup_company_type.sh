#!/bin/bash

echo "Setting up Company Type dropdown in Firebase..."
echo

echo "Checking if Node.js is installed..."
if ! command -v node &> /dev/null; then
    echo "ERROR: Node.js is not installed or not in PATH"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo "Node.js version: $(node --version)"

echo "Checking if firebase-admin is installed..."
if ! npm list firebase-admin &> /dev/null; then
    echo "Installing firebase-admin..."
    npm install firebase-admin
    if [ $? -ne 0 ]; then
        echo "ERROR: Failed to install firebase-admin"
        exit 1
    fi
fi

echo
echo "Running Firebase setup script..."
node setup_company_type_firebase.js

if [ $? -eq 0 ]; then
    echo
    echo "SUCCESS: Company Type dropdown has been set up in Firebase!"
    echo "The dropdown should now work in the candidate registration screen."
else
    echo
    echo "ERROR: Setup failed. Please check your Firebase credentials."
    echo "Make sure you have:"
    echo "1. Firebase CLI installed and logged in"
    echo "2. Proper permissions to write to Firestore"
    echo "3. GOOGLE_APPLICATION_CREDENTIALS environment variable set"
fi

echo