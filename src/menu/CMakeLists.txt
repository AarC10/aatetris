# Menu library - split into core and extended like original
set(MENU_CORE_SOURCES
    menucore.c dropdown.c inputset.c inputdev.c gamemenu.c hslist.c gameover.c
)

set(MENU_EXT_SOURCES
    startup.c invit.c netplay.c optsmenu.c blockstyle.c
)

if(TWOPLAYER)
    list(APPEND MENU_CORE_SOURCES gm_2p.c)
endif()

if(NETWORK)
    list(APPEND MENU_CORE_SOURCES gm_sock.c netplay.c)
endif()

# Backend-specific extended menu files
if(INPUT_SYS STREQUAL "curses")
    list(APPEND MENU_EXT_SOURCES men_curses.c)
elseif(INPUT_SYS STREQUAL "allegro")
    list(APPEND MENU_EXT_SOURCES men_allegro.c)
else()
    list(APPEND MENU_EXT_SOURCES men_ansi.c)
endif()

# Create two separate static libraries like original
add_library(menu_lib STATIC ${MENU_CORE_SOURCES})
add_library(menuext_lib STATIC ${MENU_EXT_SOURCES})

target_compile_definitions(menu_lib PRIVATE ${COMPILE_DEFINITIONS})
target_compile_definitions(menuext_lib PRIVATE ${COMPILE_DEFINITIONS})

target_include_directories(menu_lib PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR})
target_include_directories(menuext_lib PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/.. ${CMAKE_CURRENT_SOURCE_DIR})

target_compile_options(menu_lib PRIVATE -Wall -O2)
target_compile_options(menuext_lib PRIVATE -Wall -O2)

# Menu library
