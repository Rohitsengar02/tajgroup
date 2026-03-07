#!/bin/bash

# 1. Download Flutter
echo "Downloading Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1

# 2. Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Enable Web support
echo "Enabling Web support..."
flutter config --enable-web

# 4. Install dependencies
echo "Installing dependencies..."
flutter pub get

# 5. Build Web
echo "Building Web Release..."
flutter build web --release

# 6. Cleanup (optional, Vercel cleans up anyway)
echo "Build finished!"
