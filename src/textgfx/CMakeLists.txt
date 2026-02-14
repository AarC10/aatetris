# TextGFX library sources
set(TEXTGFX_SOURCES
    print.c
    block.c
    resize.c
    win.c
)

# Backend-specific sources
if(INPUT_SYS STREQUAL "curses")
    list(APPEND TEXTGFX_SOURCES curses.c curses_win.c)
elseif(INPUT_SYS STREQUAL "allegro")
    list(APPEND TEXTGFX_SOURCES allegro.c allegro_win.c ibmgfx.c)
else()
    list(APPEND TEXTGFX_SOURCES ansi.c ansi_win.c term.c)
endif()



# Create static library
add_library(textgfx_lib STATIC ${TEXTGFX_SOURCES})

# Add compile definitions
target_compile_definitions(textgfx_lib PRIVATE ${COMPILE_DEFINITIONS})

# Include directories
target_include_directories(textgfx_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Compiler flags
target_compile_options(textgfx_lib PRIVATE -Wall -O2)

# Add curses include directory if curses is enabled
if(CURSES)
    target_include_directories(textgfx_lib PRIVATE ${CURSES_INCLUDE_DIRS})
endif()

