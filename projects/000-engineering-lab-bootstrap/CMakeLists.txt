cmake_minimum_required(VERSION 3.25)

project(
    atlas-engineering-lab-bootstrap
    VERSION 0.1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(atlas-bootstrap
    src/main.cpp
)

include(CTest)
find_package(GTest CONFIG REQUIRED)

add_executable(atlas-bootstrap-tests
    tests/main_test.cpp
)

include(GoogleTest)
gtest_discover_tests(atlas-bootstrap-tests)

add_library(atlas_project_warnings INTERFACE)

target_compile_options(atlas_project_warnings
    INTERFACE
        -Wall
        -Wextra
        -Wpedantic
)

target_link_libraries(atlas-bootstrap
    PRIVATE
        atlas_project_warnings
)

target_link_libraries(atlas-bootstrap-tests
    PRIVATE
        atlas_project_warnings
        GTest::gtest_main
)

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