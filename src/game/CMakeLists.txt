# Game library sources
set(GAME_SOURCES
    tetris.c
    game.c
    wonlost.c
)

# Conditional sources
if(TWOPLAYER)
    list(APPEND GAME_SOURCES tetris2p.c)
endif()

# Create static library
add_library(game_lib STATIC ${GAME_SOURCES})

# Add compile definitions
target_compile_definitions(game_lib PRIVATE ${COMPILE_DEFINITIONS})

# Include directories
target_include_directories(game_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Compiler flags
target_compile_options(game_lib PRIVATE -Wall -O2)
