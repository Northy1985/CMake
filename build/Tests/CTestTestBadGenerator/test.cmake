cmake_minimum_required(VERSION 3.0)

# Settings:
set(CTEST_DASHBOARD_ROOT                "R:/CMake/build/Tests/CTestTest")
set(CTEST_SITE                          "DESKTOP-X570-UD")
set(CTEST_BUILD_NAME                    "CTestTest-Win32-MSBuild-Depends")

set(CTEST_SOURCE_DIRECTORY              "R:/CMake/Tests/CTestTestBadGenerator")
set(CTEST_BINARY_DIRECTORY              "R:/CMake/build/Tests/CTestTestBadGenerator")
set(CTEST_CVS_COMMAND                   "")
set(CTEST_CMAKE_GENERATOR               "Bad Generator")
set(CTEST_CMAKE_GENERATOR_PLATFORM      "")
set(CTEST_CMAKE_GENERATOR_TOOLSET       "")
set(CTEST_BUILD_CONFIGURATION           "$ENV{CMAKE_CONFIG_TYPE}")
set(CTEST_COVERAGE_COMMAND              "C:/MinGW/bin/gcov.exe")
set(CTEST_NOTES_FILES                   "${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}")

CTEST_START(Experimental)
CTEST_CONFIGURE(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_BUILD(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
CTEST_TEST(BUILD "${CTEST_BINARY_DIRECTORY}" RETURN_VALUE res)
