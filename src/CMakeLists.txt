# Main sources
set(SOURCES main.c cmdline.c cfgfile.c options.c hiscore.c lang.c timer.c focus.c)

# Add subdirectories
add_subdirectory(game)
add_subdirectory(menu)
add_subdirectory(netw)
add_subdirectory(input)
add_subdirectory(draw)
add_subdirectory(textgfx)

# Main executable
add_executable(vitetris_exe ${SOURCES})
set_target_properties(vitetris_exe PROPERTIES OUTPUT_NAME ${EXECUTABLE_NAME})

# Compile definitions and includes
target_compile_definitions(vitetris_exe PRIVATE ${COMPILE_DEFINITIONS})
target_include_directories(vitetris_exe PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# Link libraries in the correct order (matching original Makefile)
target_link_libraries(vitetris_exe PRIVATE game_lib)

if(MENU)
    target_link_libraries(vitetris_exe PRIVATE menuext_lib menu_lib)
endif()

if(NETWORK)
    target_link_libraries(vitetris_exe PRIVATE netw_lib)
endif()

target_link_libraries(vitetris_exe PRIVATE input_lib draw_lib textgfx_lib)

if(CURSES)
    target_link_libraries(vitetris_exe PRIVATE ${CURSES_LIBRARIES})
endif()

if(ALLEGRO)
    target_link_libraries(vitetris_exe PRIVATE ${ALLEGRO_LIBRARIES})
endif()

if(XLIB)
    target_link_libraries(vitetris_exe PRIVATE ${X11_LIBRARIES})
endif()

target_compile_options(vitetris_exe PRIVATE -Wall -O2)
