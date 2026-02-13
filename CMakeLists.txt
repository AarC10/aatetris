cmake_minimum_required(VERSION 3.10)
project(vitetris VERSION 0.59.1 LANGUAGES C)

# Set C standard
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Build options (similar to config.mk)
option(TWOPLAYER "Enable two-player support" ON)
option(JOYSTICK "Enable joystick support" OFF)
option(NETWORK "Enable network support" ON)
option(TTY_SOCKET "Enable TTY socket support" ON)
option(TERM_RESIZING "Enable terminal resizing support" ON)
option(MENU "Enable menu support" ON)
option(BLOCKSTYLES "Enable block styles" ON)
option(CURSES "Use curses backend" OFF)
option(ALLEGRO "Use Allegro backend" OFF)
option(XLIB "Use X11/Xlib support" OFF)

# Input system options
set(INPUT_SYS "unixterm" CACHE STRING "Input system to use")
set_property(CACHE INPUT_SYS PROPERTY STRINGS unixterm curses allegro)

# Installation directories
include(GNUInstallDirs)
set(DOCDIR "${CMAKE_INSTALL_DATAROOTDIR}/doc/vitetris" CACHE PATH "Documentation directory")
set(PIXMAPDIR "${CMAKE_INSTALL_DATAROOTDIR}/pixmaps" CACHE PATH "Pixmaps directory")
set(DESKTOPDIR "${CMAKE_INSTALL_DATAROOTDIR}/applications" CACHE PATH "Desktop files directory")
set(DATADIR_ALLEGRO "${CMAKE_INSTALL_DATAROOTDIR}/allegro" CACHE PATH "Allegro data directory")

# Optional paths
set(HISCORE_FILENAME "" CACHE PATH "High score file location (leave empty for default)")
set(XLIB_INC "" CACHE PATH "X11 include directory")

# PC Timer options for DOS/Windows
set(PCTIMER "" CACHE STRING "PC Timer implementation")
set(PCTIMER_INC "" CACHE PATH "PC Timer include directory")

# Find required packages
if(CURSES)
    find_package(Curses REQUIRED)
endif()

if(ALLEGRO)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(ALLEGRO REQUIRED allegro)
endif()

if(XLIB)
    find_package(X11 REQUIRED)
endif()

# Set up compiler definitions based on options
set(COMPILE_DEFINITIONS)

if(TWOPLAYER)
    list(APPEND COMPILE_DEFINITIONS TWOPLAYER=1)
endif()

if(JOYSTICK)
    list(APPEND COMPILE_DEFINITIONS JOYSTICK=1)
endif()

if(NETWORK)
    list(APPEND COMPILE_DEFINITIONS SOCKET=1 INET=1)
endif()

if(TTY_SOCKET AND NETWORK)
    list(APPEND COMPILE_DEFINITIONS TTY_SOCKET=1)
endif()

if(CURSES)
    list(APPEND COMPILE_DEFINITIONS CURSES=1)
endif()

if(ALLEGRO)
    list(APPEND COMPILE_DEFINITIONS ALLEGRO=1)
endif()

if(XLIB)
    list(APPEND COMPILE_DEFINITIONS XLIB=1)
endif()

if(TERM_RESIZING)
    list(APPEND COMPILE_DEFINITIONS TERM_RESIZING=1)
endif()

if(NOT MENU)
    list(APPEND COMPILE_DEFINITIONS NO_MENU=1)
endif()

if(NOT BLOCKSTYLES)
    list(APPEND COMPILE_DEFINITIONS NO_BLOCKSTYLES=1)
endif()

if(HISCORE_FILENAME)
    list(APPEND COMPILE_DEFINITIONS HISCORE_FILENAME="${HISCORE_FILENAME}")
endif()

if(PCTIMER)
    list(APPEND COMPILE_DEFINITIONS PCTIMER=1)
endif()

# Detect Unix-like system
if(UNIX)
    list(APPEND COMPILE_DEFINITIONS UNIX=1)
endif()

# Set output name
if(WIN32)
    set(EXECUTABLE_NAME tetris.exe)
else()
    set(EXECUTABLE_NAME tetris)
endif()

# Add subdirectories
add_subdirectory(src)

# Create install targets
install(TARGETS vitetris_exe
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES README licence.txt
    DESTINATION ${DOCDIR}
)

if(PIXMAPDIR)
    install(FILES vitetris.xpm
        DESTINATION ${PIXMAPDIR}
    )
endif()

if(DESKTOPDIR)
    install(FILES vitetris.desktop
        DESTINATION ${DESKTOPDIR}
    )
endif()

if(ALLEGRO AND DATADIR_ALLEGRO)
    install(FILES pc8x16.fnt
        DESTINATION ${DATADIR_ALLEGRO}
    )
endif()

# Custom target for high scores installation
add_custom_target(install-hiscores
    COMMAND ${CMAKE_COMMAND} -E echo "Installing high score file..."
    COMMAND ${CMAKE_COMMAND} -E make_directory /var/games
    COMMAND ${CMAKE_COMMAND} -E touch /var/games/vitetris-hiscores
    COMMENT "Installing system-wide high score file"
)

# Print configuration summary
message(STATUS "vitetris configuration:")
message(STATUS "  Two-player support: ${TWOPLAYER}")
message(STATUS "  Joystick support: ${JOYSTICK}")
message(STATUS "  Network support: ${NETWORK}")
message(STATUS "  TTY socket support: ${TTY_SOCKET}")
message(STATUS "  Terminal resizing: ${TERM_RESIZING}")
message(STATUS "  Menu support: ${MENU}")
message(STATUS "  Block styles: ${BLOCKSTYLES}")
message(STATUS "  Backend: ${INPUT_SYS}")
message(STATUS "  Curses: ${CURSES}")
message(STATUS "  Allegro: ${ALLEGRO}")
message(STATUS "  X11 support: ${XLIB}")
