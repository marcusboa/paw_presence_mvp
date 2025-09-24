@echo off
echo ========================================
echo    Paw Presence MVP - Web Build Script
echo ========================================
echo.

echo [1/4] Enabling Flutter web support...
flutter config --enable-web
if %errorlevel% neq 0 (
    echo ERROR: Failed to enable web support
    pause
    exit /b 1
)

echo.
echo [2/4] Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo [3/4] Cleaning previous build...
if exist "build\web" rmdir /s /q "build\web"

echo.
echo [4/4] Building for web (production)...
flutter build web --release --base-href "/demo/"
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo           BUILD SUCCESSFUL!
echo ========================================
echo.
echo Your web app is ready in: build\web\
echo.
echo Next steps:
echo 1. Upload the build\web\ folder contents to your hosting service
echo 2. Update the iframe src in your Squarespace page
echo 3. Test the demo on different devices
echo.
echo Popular hosting options:
echo - GitHub Pages: https://pages.github.com/
echo - Netlify: https://netlify.com/
echo - Firebase Hosting: https://firebase.google.com/docs/hosting
echo.
pause
