project(TestLlvm)
cmake_minimum_required(VERSION 3.0)

include(${CMAKE_CURRENT_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

include(${CONAN_LLVM_ROOT}/lib/cmake/llvm/LLVMConfig.cmake)

if(NOT LLVM_INSTALL_PREFIX)
    message(FATAL_ERROR "ERROR! LLVM NOT FOUND!")
endif()
