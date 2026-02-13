#!/bin/bash

# CMake build script for vitetris
# Usage: ./build-cmake.sh [options]

BUILD_DIR="build"
BUILD_TYPE="Release"
INSTALL_PREFIX="/usr/local"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        --build-dir=*)
            BUILD_DIR="${1#*=}"
            shift
            ;;
        --prefix=*)
            INSTALL_PREFIX="${1#*=}"
            shift
            ;;
        --curses)
            CMAKE_OPTIONS="${CMAKE_OPTIONS} -DCURSES=ON"
            shift
            ;;
        --allegro)
            CMAKE_OPTIONS="${CMAKE_OPTIONS} -DALLEGRO=ON"
            shift
            ;;
        --no-network)
            CMAKE_OPTIONS="${CMAKE_OPTIONS} -DNETWORK=OFF"
            shift
            ;;
        --no-twoplayer)
            CMAKE_OPTIONS="${CMAKE_OPTIONS} -DTWOPLAYER=OFF"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --debug                  Build in debug mode"
            echo "  --build-dir=DIR         Set build directory (default: build)"
            echo "  --prefix=PREFIX         Set installation prefix (default: /usr/local)"
            echo "  --curses                Enable curses backend"
            echo "  --allegro               Enable Allegro backend"
            echo "  --no-network            Disable network support"
            echo "  --no-twoplayer          Disable two-player support"
            echo "  --help, -h              Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure
echo "Configuring vitetris with CMake..."
cmake .. \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    $CMAKE_OPTIONS

if [ $? -ne 0 ]; then
    echo "CMake configuration failed!"
    exit 1
fi

# Build
echo "Building vitetris..."
cmake --build . --parallel $(nproc)

if [ $? -ne 0 ]; then
    echo "Build failed!"
    exit 1
fi

echo ""
echo "Build completed successfully!"
echo "Executable: $BUILD_DIR/src/tetris"
echo ""
echo "To install: cmake --install $BUILD_DIR"
echo "To run: ./$BUILD_DIR/src/tetris"
