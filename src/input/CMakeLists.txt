# Input library sources
set(INPUT_SOURCES
    input.c
    keyboard.c
    playerin.c
    select.c
    escseq.c
)

# Conditional sources based on input system
if(INPUT_SYS STREQUAL "unixterm")
    list(APPEND INPUT_SOURCES inp_unixterm.c)
elseif(INPUT_SYS STREQUAL "curses")
    list(APPEND INPUT_SOURCES inp_curses.c)
elseif(INPUT_SYS STREQUAL "allegro")
    list(APPEND INPUT_SOURCES inp_allegro.c)
else()
    list(APPEND INPUT_SOURCES inp_con.c)
endif()

# Joystick support
if(JOYSTICK)
    list(APPEND INPUT_SOURCES joystick.c joylinux.c)
endif()

# Create static library
add_library(input_lib STATIC ${INPUT_SOURCES})

# Add compile definitions
target_compile_definitions(input_lib PRIVATE ${COMPILE_DEFINITIONS})

# Include directories
target_include_directories(input_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Compiler flags
target_compile_options(input_lib PRIVATE -Wall -O2)
