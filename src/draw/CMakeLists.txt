# Draw library sources
set(DRAW_SOURCES
    draw.c
    draw_menu.c
    draw2p.c
    draw2p_menu.c
)

# Create static library
add_library(draw_lib STATIC ${DRAW_SOURCES})

# Add compile definitions
target_compile_definitions(draw_lib PRIVATE ${COMPILE_DEFINITIONS})

# Include directories
target_include_directories(draw_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Compiler flags
target_compile_options(draw_lib PRIVATE -Wall -O2)
