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

target_link_libraries(atlas-bootstrap-tests
    PRIVATE
        GTest::gtest_main
)

include(GoogleTest)
gtest_discover_tests(atlas-bootstrap-tests)