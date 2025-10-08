#!/usr/bin/env bash
set -euo pipefail

# Netlify build script for Flutter Web
# Installs Flutter SDK in the build environment and builds the app

FLUTTER_VERSION="3.22.2"
FLUTTER_CHANNEL="stable"

echo "==> Installing Flutter ${FLUTTER_VERSION}-${FLUTTER_CHANNEL}"
mkdir -p "$HOME"
cd "$HOME"
# Download Flutter SDK (Linux x64)
curl -L "https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz" -o flutter.tar.xz
mkdir -p "$HOME/flutter-sdk"
tar -xJf flutter.tar.xz -C "$HOME"
rm -f flutter.tar.xz

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"

# Enable web support and fetch dependencies
echo "==> Flutter version"
flutter --version

echo "==> Enabling web support"
flutter config --enable-web

# Workaround for analytics prompts in CI
echo "==> Disabling analytics"
flutter --disable-analytics || true

echo "==> Pub get"
cd "$NETLIFY_BUILD_BASE/repo" || cd "$BITBUCKET_CLONE_DIR" || cd "$REPOSITORY_ROOT" || cd "$PWD"
flutter pub get

echo "==> Building web (release)"
flutter build web --release

echo "==> Build complete. Output at build/web"
