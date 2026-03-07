#!/bin/bash

# 1. Download Flutter if it doesn't exist
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
else
  echo "Flutter already exists, skipping clone."
fi

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

echo "Build finished!"
