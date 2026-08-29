add_library(atlas_project_warnings INTERFACE)

target_compile_options(atlas_project_warnings
    INTERFACE
        -Wall
        -Wextra
        -Wpedantic
)