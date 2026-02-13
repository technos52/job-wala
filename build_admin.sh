#!/bin/bash
echo "Building JobEase Admin Panel..."

# Build Flutter web app with admin main
flutter build web --web-renderer html --target lib/admin_panel/admin_main.dart --output build/admin_web

# Copy built files to admin directory
if [ -d "build/admin_web" ]; then
  echo "Copying admin files..."
  cp -r build/admin_web/* web/admin/
  echo "✅ Admin panel built successfully!"
  echo "📁 Files available in: web/admin/"
  echo "🌐 Deploy admin directory to your hosting service"
else
  echo "❌ Build failed - admin_web directory not found"
fi