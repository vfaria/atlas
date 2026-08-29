cmake_minimum_required(VERSION 3.25)

project(
    atlas-engineering-lab-bootstrap
    VERSION 0.1.0
    LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

include(CompilerWarnings)
include(CLangTools)

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

include(Coverage)

target_link_libraries(atlas-bootstrap
    PRIVATE
        atlas_project_warnings
)

target_link_libraries(atlas-bootstrap-tests
    PRIVATE
        atlas_project_warnings
        GTest::gtest_main
)