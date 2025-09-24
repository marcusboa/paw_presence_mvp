# Paw Presence MVP - Squarespace Deployment Guide

## Overview
This guide will help you deploy your Flutter Paw Presence MVP as a web demo on your Squarespace website.

## Prerequisites
- Flutter SDK installed
- Squarespace Business plan or higher (required for custom code injection)
- Access to your Squarespace site's developer tools

## Step 1: Build the Flutter Web App

1. Open terminal in your project directory
2. Enable web support (if not already done):
   ```bash
   flutter config --enable-web
   ```

3. Get dependencies:
   ```bash
   flutter pub get
   ```

4. Build for web production:
   ```bash
   flutter build web --release --base-href "/demo/"
   ```

This creates a `build/web` folder with all necessary files.

## Step 2: Prepare Files for Upload

After building, you'll have these key files in `build/web/`:
- `index.html` - Main app file
- `main.dart.js` - Compiled Flutter code
- `flutter_service_worker.js` - Service worker
- `manifest.json` - Web app manifest
- `assets/` folder - Images and other assets
- `canvaskit/` folder - Flutter's rendering engine

## Step 3: Upload to Squarespace

### Option A: Code Injection (Recommended)
1. In Squarespace, go to **Settings > Advanced > Code Injection**
2. Add this to the **Header**:
```html
<style>
  .demo-container {
    width: 100%;
    height: 100vh;
    border: none;
    background: #f5f5f5;
  }
  .demo-wrapper {
    position: relative;
    width: 100%;
    height: 100vh;
    overflow: hidden;
  }
</style>
```

3. Create a new page for your demo
4. Add a **Code Block** with this content:
```html
<div class="demo-wrapper">
  <iframe 
    src="https://your-domain.com/demo/" 
    class="demo-container"
    title="Paw Presence Demo">
  </iframe>
</div>
```

### Option B: File Upload Method
1. Upload all files from `build/web/` to your site's file storage
2. Create a new page and embed using the iframe method above

## Step 4: Host the Flutter Files

### Recommended Hosting Options:

#### Option 1: GitHub Pages (Free)
1. Create a new GitHub repository
2. Upload all files from `build/web/` to the repository
3. Enable GitHub Pages in repository settings
4. Your demo will be available at: `https://username.github.io/repository-name/`

#### Option 2: Netlify (Free tier available)
1. Create account at netlify.com
2. Drag and drop the `build/web` folder
3. Get your demo URL (e.g., `https://amazing-demo-123.netlify.app`)

#### Option 3: Firebase Hosting (Free tier available)
1. Install Firebase CLI: `npm install -g firebase-tools`
2. In your project: `firebase init hosting`
3. Set public directory to `build/web`
4. Deploy: `firebase deploy`

## Step 5: Integrate with Squarespace

1. Create a new page in Squarespace called "Demo" or "App Preview"
2. Add a **Code Block** to the page
3. Insert this HTML:

```html
<div style="width: 100%; height: 100vh; position: relative;">
  <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
              color: white; text-align: center; padding: 15px; 
              font-family: -apple-system, BlinkMacSystemFont, sans-serif;">
    <h2>🐾 Paw Presence Demo</h2>
    <p>Interactive demo of our pet sitting management platform</p>
  </div>
  
  <iframe 
    src="YOUR_HOSTED_DEMO_URL_HERE"
    style="width: 100%; height: calc(100vh - 80px); border: none;"
    title="Paw Presence Interactive Demo"
    loading="lazy">
  </iframe>
  
  <div style="background: #f8f9fa; padding: 10px; text-align: center; 
              font-size: 14px; color: #666;">
    <p>💡 This is a fully interactive demo. Try navigating through different screens!</p>
  </div>
</div>
```

## Step 6: Optimize for Mobile

Add this CSS to your Squarespace **Custom CSS**:

```css
/* Mobile optimization for demo */
@media (max-width: 768px) {
  .demo-wrapper iframe {
    height: 70vh;
  }
  
  .sqs-block-code {
    padding: 0 !important;
  }
}

/* Demo page specific styles */
.demo-page {
  .sqs-layout .sqs-row {
    margin: 0 !important;
  }
  
  .content-wrapper {
    padding: 0 !important;
  }
}
```

## Step 7: Add Demo Instructions

Create a section above or below your demo with instructions:

```html
<div style="max-width: 800px; margin: 20px auto; padding: 20px; 
            background: white; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
  <h3>🎯 How to Use This Demo</h3>
  <ul style="line-height: 1.6;">
    <li><strong>Sign In:</strong> Use any email/password to enter the demo</li>
    <li><strong>Role Selection:</strong> Choose "Pet Sitter" to explore the full platform</li>
    <li><strong>Navigation:</strong> Use the bottom tabs to explore Jobs, Messages, and Profile</li>
    <li><strong>Interactive Features:</strong> Tap cards, buttons, and menus to see the app in action</li>
    <li><strong>Demo Data:</strong> All data is simulated for demonstration purposes</li>
  </ul>
  
  <div style="background: #e3f2fd; padding: 15px; border-radius: 5px; margin-top: 15px;">
    <strong>💼 Key Features to Explore:</strong>
    <br>• Job management and scheduling
    <br>• Real-time messaging system
    <br>• Photo album creation
    <br>• Invoice generation
    <br>• Profile management
  </div>
</div>
```

## Troubleshooting

### Common Issues:

1. **CORS Errors**: Ensure your hosting service allows iframe embedding
2. **Loading Issues**: Check that all asset paths are correct
3. **Mobile Display**: Test on various devices and adjust CSS as needed
4. **Performance**: Consider lazy loading for better page speed

### Performance Tips:

1. Enable gzip compression on your hosting service
2. Use a CDN if available
3. Optimize images in the assets folder
4. Consider preloading critical resources

## Security Considerations

- The demo runs in an iframe, providing isolation
- No real user data is processed
- All demo data is client-side only
- Consider adding rate limiting if needed

## Analytics Integration

Add Google Analytics or Squarespace Analytics to track demo usage:

```html
<!-- Add to Squarespace Header Code Injection -->
<script>
  // Track demo interactions
  function trackDemoEvent(action) {
    if (typeof gtag !== 'undefined') {
      gtag('event', action, {
        'event_category': 'Demo',
        'event_label': 'Paw Presence'
      });
    }
  }
</script>
```

## Next Steps

1. Build and host your Flutter web app
2. Test the demo thoroughly on different devices
3. Add the iframe to your Squarespace page
4. Customize the styling to match your site
5. Add analytics tracking
6. Monitor performance and user engagement

## Support

For technical issues:
- Check Flutter web documentation
- Verify Squarespace plan supports custom code
- Test hosting service compatibility
- Ensure all files are properly uploaded

Your Paw Presence demo will showcase the full functionality of your pet sitting platform directly on your Squarespace website!
