find_program(LLVM_COV_EXECUTABLE
    NAMES llvm-cov
    REQUIRED
)

find_program(LLVM_PROFDATA_EXECUTABLE
    NAMES llvm-profdata
    REQUIRED
)

add_custom_target(coverage
    COMMAND ${CMAKE_COMMAND} -E env
        LLVM_PROFILE_FILE=${CMAKE_BINARY_DIR}/atlas-bootstrap-tests.profraw
        $<TARGET_FILE:atlas-bootstrap-tests>
    COMMAND ${LLVM_PROFDATA_EXECUTABLE}
        merge
        -sparse
        ${CMAKE_BINARY_DIR}/atlas-bootstrap-tests.profraw
        -o ${CMAKE_BINARY_DIR}/atlas-bootstrap-tests.profdata
    COMMAND ${LLVM_COV_EXECUTABLE}
        report
        $<TARGET_FILE:atlas-bootstrap-tests>
        -instr-profile=${CMAKE_BINARY_DIR}/atlas-bootstrap-tests.profdata
    DEPENDS
        atlas-bootstrap-tests
    COMMENT "Running tests and generating coverage report"
)