#!/bin/bash
set -e

echo "=== MyWingsFinder Build Script ==="
echo "Current directory: $PWD"
echo "Current user: $(whoami)"

# Check if Flutter is already available
if command -v flutter &> /dev/null; then
    echo "Flutter is already available in PATH"
    FLUTTER_PATH=$(which flutter)
    echo "Flutter path: $FLUTTER_PATH"
else
    echo "Flutter not found in PATH, installing..."
    
    # Try to download Flutter
    echo "Downloading Flutter..."
    if curl -L -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz; then
        echo "Flutter downloaded successfully"
        
        echo "Extracting Flutter..."
        tar -xf flutter.tar.xz
        
        echo "Setting up Flutter path..."
        export PATH="$PATH:$PWD/flutter/bin"
        
        echo "Verifying Flutter installation..."
        if $PWD/flutter/bin/flutter --version; then
            echo "Flutter installed successfully"
        else
            echo "Flutter installation failed"
            exit 1
        fi
    else
        echo "Failed to download Flutter, trying alternative method..."
        
        # Try alternative download method
        if wget -O flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz; then
            echo "Flutter downloaded with wget"
            tar -xf flutter.tar.xz
            export PATH="$PATH:$PWD/flutter/bin"
        else
            echo "All Flutter download methods failed"
            exit 1
        fi
    fi
fi

echo "Configuring Git..."
git config --global --add safe.directory $PWD/flutter || echo "Git config warning (continuing...)"

echo "Flutter version:"
flutter --version

echo "Checking Flutter doctor..."
flutter doctor --verbose || echo "Flutter doctor warnings (continuing...)"

echo "Getting Flutter dependencies..."
flutter pub get

echo "Building Flutter web app..."
flutter build web --release --base-href /

echo "Build completed successfully!"
echo "Build output directory: $PWD/build/web"
ls -la build/web/
