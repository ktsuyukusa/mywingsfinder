#!/bin/bash
set -e

echo "Installing Flutter..."
curl -o- https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz | tar -xJf -

echo "Configuring Git..."
git config --global --add safe.directory $PWD/flutter

echo "Setting up PATH..."
export PATH="$PATH:$PWD/flutter/bin"

echo "Building Flutter web app..."
flutter build web --release --base-href /

echo "Build completed successfully!"
