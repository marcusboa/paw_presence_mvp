#!/usr/bin/env bash
set -e

# Netlify build script for Flutter Web
echo "==> Starting Flutter Web build process"

# Set Flutter version
FLUTTER_VERSION="3.24.3"
FLUTTER_CHANNEL="stable"

echo "==> Installing Flutter ${FLUTTER_VERSION}-${FLUTTER_CHANNEL}"

# Create flutter directory in home
cd "$HOME"
echo "Working directory: $(pwd)"

# Download and extract Flutter
echo "==> Downloading Flutter SDK..."
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz" -o flutter.tar.xz

echo "==> Extracting Flutter SDK..."
tar -xf flutter.tar.xz
rm flutter.tar.xz

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"
echo "Flutter path: $HOME/flutter/bin"

# Verify Flutter installation
echo "==> Verifying Flutter installation"
flutter --version

# Navigate back to project directory
echo "==> Navigating to project directory"
cd "$PWD"
echo "Project directory: $(pwd)"

# Configure Flutter for web and CI
echo "==> Configuring Flutter"
flutter config --enable-web --no-analytics

# Get dependencies
echo "==> Getting Flutter dependencies"
flutter pub get

# Build for web
echo "==> Building Flutter web app"
flutter build web --release --web-renderer canvaskit

echo "==> Build completed successfully!"
echo "Output directory contents:"
ls -la build/web/ || echo "build/web directory not found"
