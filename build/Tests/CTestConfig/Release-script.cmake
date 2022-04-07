set(CTEST_CMAKE_GENERATOR "Visual Studio 17 2022")
set(CTEST_CMAKE_GENERATOR_PLATFORM "")
set(CTEST_CMAKE_GENERATOR_TOOLSET "")
set(CTEST_SOURCE_DIRECTORY "R:/CMake/Tests/CTestConfig")
set(CTEST_BINARY_DIRECTORY "R:/CMake/build/Tests/CTestConfig/Release-script")

ctest_start(Experimental)

set(_isMultiConfig "1")
if(_isMultiConfig)
  set(cfg_opts "-DCMAKE_CONFIGURATION_TYPES=Debug\\;Release\\;MinSizeRel\\;RelWithDebInfo")
else()
  set(cfg_opts)
endif()

ctest_configure(BUILD "${CTEST_BINARY_DIRECTORY}" OPTIONS "${cfg_opts}" RETURN_VALUE rv)
if(NOT rv STREQUAL 0)
  message(FATAL_ERROR "*** error in ctest_configure ***")
endif()

ctest_build(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE rv)
if(NOT rv STREQUAL 0)
  message(FATAL_ERROR "*** error in ctest_build ***")
endif()

ctest_test(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE rv)
if(NOT rv STREQUAL 0)
  message(FATAL_ERROR "*** error in ctest_test ***")
endif()
