# See supported GPUs on Wikipedia
# https://en.wikipedia.org/wiki/CUDA#GPUs_supported

# Initial set based on CUDA 7.0.
set(CMAKE_CUDA_ARCHITECTURES_ALL 20 21 30 35 37 50 52 53)
set(CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 20 30 35 50)

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 8.0)
  list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 60 61 62)
  list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 60)
endif()

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 9.0)
  if(NOT CMAKE_CUDA_COMPILER_ID STREQUAL "Clang" OR CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL 6.0)
    list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 70 72)
    list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 70)
  endif()

  list(REMOVE_ITEM CMAKE_CUDA_ARCHITECTURES_ALL 20 21)
  list(REMOVE_ITEM CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 20 21)
endif()

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 10.0
   AND (NOT CMAKE_CUDA_COMPILER_ID STREQUAL "Clang" OR CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL 8.0))
  list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 75)
endif()

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 11.0)
  if(NOT CMAKE_CUDA_COMPILER_ID STREQUAL "Clang" OR CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL 11.0)
    list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 80)
    list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 80)
  endif()

  list(REMOVE_ITEM CMAKE_CUDA_ARCHITECTURES_ALL 30)
  list(REMOVE_ITEM CMAKE_CUDA_ARCHITECTURES_ALL_MAJOR 30)
endif()

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 11.1
   AND (NOT CMAKE_CUDA_COMPILER_ID STREQUAL "Clang" OR CMAKE_CUDA_COMPILER_VERSION VERSION_GREATER_EQUAL 13.0))
  list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 86)
endif()

if(CMAKE_CUDA_COMPILER_TOOLKIT_VERSION VERSION_GREATER_EQUAL 11.4
   AND (NOT CMAKE_CUDA_COMPILER_ID STREQUAL "Clang"))
  list(APPEND CMAKE_CUDA_ARCHITECTURES_ALL 87)
endif()

# FIXME(#23161): Detect architectures early since we test them during
# compiler detection.  We already have code to detect them later during
# compiler testing, so we should not need to do this here.
if(NOT CMAKE_GENERATOR MATCHES "Visual Studio")
  set(_CUDA_ARCHS_EXE "${CMAKE_PLATFORM_INFO_DIR}/CMakeDetermineCUDACompilerArchs.bin")
  execute_process(
    COMMAND "${_CUDA_NVCC_EXECUTABLE}" -o "${_CUDA_ARCHS_EXE}" --cudart=static "${CMAKE_ROOT}/Modules/CMakeCUDACompilerABI.cu"
    RESULT_VARIABLE _CUDA_ARCHS_RESULT
    OUTPUT_VARIABLE _CUDA_ARCHS_OUTPUT
    ERROR_VARIABLE  _CUDA_ARCHS_OUTPUT
    )
  if(_CUDA_ARCHS_RESULT EQUAL 0)
    execute_process(
      COMMAND "${_CUDA_ARCHS_EXE}"
      RESULT_VARIABLE _CUDA_ARCHS_RESULT
      OUTPUT_VARIABLE _CUDA_ARCHS_OUTPUT
      ERROR_VARIABLE  _CUDA_ARCHS_OUTPUT
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
  endif()
  if(_CUDA_ARCHS_RESULT EQUAL 0)
    if("$ENV{CMAKE_CUDA_ARCHITECTURES_NATIVE_CLAMP}")
      # Undocumented hook used by CMake's CI.
      # Clamp native architecture to version range supported by this CUDA.
      list(GET CMAKE_CUDA_ARCHITECTURES_ALL 0  _CUDA_ARCH_MIN)
      list(GET CMAKE_CUDA_ARCHITECTURES_ALL -1 _CUDA_ARCH_MAX)
      set(_CUDA_ARCHITECTURES_NATIVE "")
      foreach(_CUDA_ARCH IN LISTS _CUDA_ARCHS_OUTPUT)
        if(_CUDA_ARCH LESS _CUDA_ARCH_MIN)
          set(_CUDA_ARCH "${_CUDA_ARCH_MIN}")
        endif()
        if(_CUDA_ARCH GREATER _CUDA_ARCH_MAX)
          set(_CUDA_ARCH "${_CUDA_ARCH_MAX}")
        endif()
        list(APPEND _CUDA_ARCHITECTURES_NATIVE ${_CUDA_ARCH})
      endforeach()
      unset(_CUDA_ARCH)
      unset(_CUDA_ARCH_MIN)
      unset(_CUDA_ARCH_MAX)
    else()
      set(_CUDA_ARCHITECTURES_NATIVE "${_CUDA_ARCHS_OUTPUT}")
    endif()
    list(REMOVE_DUPLICATES _CUDA_ARCHITECTURES_NATIVE)
  else()
    if (NOT _CUDA_ARCHS_RESULT MATCHES "[0-9]+")
      set(_CUDA_ARCHS_STATUS " (${_CUDA_ARCHS_RESULT})")
    else()
      set(_CUDA_ARCHS_STATUS "")
    endif()
    string(REPLACE "\n" "\n  " _CUDA_ARCHS_OUTPUT "  ${_CUDA_ARCHS_OUTPUT}")
    file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
      "Detecting the CUDA native architecture(s) failed with "
      "the following output:\n${_CUDA_ARCHS_OUTPUT}\n\n")
    set(_CUDA_ARCHS_OUTPUT "")
  endif()
  unset(_CUDA_ARCHS_EXE)
  unset(_CUDA_ARCHS_RESULT)
  unset(_CUDA_ARCHS_OUTPUT)
endif()
