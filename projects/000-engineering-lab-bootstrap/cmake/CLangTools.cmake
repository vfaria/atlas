find_program(CLANG_FORMAT_EXECUTABLE
    NAMES clang-format
    REQUIRED
)

add_custom_target(format-check
    COMMAND
        ${CLANG_FORMAT_EXECUTABLE}
        --dry-run
        --Werror
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/tests/main_test.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Checking C++ formatting"
)

find_program(CLANG_TIDY_EXECUTABLE
    NAMES clang-tidy
    REQUIRED
)

add_custom_target(tidy-check
    COMMAND
        ${CLANG_TIDY_EXECUTABLE}
        -p ${CMAKE_BINARY_DIR}
        ${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/tests/main_test.cpp
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMENT "Running clang-tidy"
)