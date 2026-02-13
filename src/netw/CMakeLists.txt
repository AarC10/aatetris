# Network library sources
set(NETW_SOURCES
    comm.c
    socket.c
    gameserver.c
)

# Conditional network sources
if(NETWORK)
    list(APPEND NETW_SOURCES comm_inet.c inet.c)
    if(TTY_SOCKET)
        list(APPEND NETW_SOURCES tty_socket.c)
    endif()
else()
    list(APPEND NETW_SOURCES no_inet.c)
endif()

# Create static library
add_library(netw_lib STATIC ${NETW_SOURCES})

# Create a modified compile definitions list without SOCKET for network files
set(NETW_COMPILE_DEFINITIONS ${COMPILE_DEFINITIONS})
list(REMOVE_ITEM NETW_COMPILE_DEFINITIONS "SOCKET=1")

# Add compile definitions (excluding SOCKET to avoid type conflicts)
target_compile_definitions(netw_lib PRIVATE ${NETW_COMPILE_DEFINITIONS})

# Include directories
target_include_directories(netw_lib PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

# Compiler flags
target_compile_options(netw_lib PRIVATE -Wall -O2)
