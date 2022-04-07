if(NOT "R:/CMake/Tests/CMakeTests" MATCHES "^/")
  set(slash /)
endif()
set(url "file://${slash}R:/CMake/Tests/CMakeTests/FileDownloadInput.png")
set(dir "R:/CMake/build/Tests/CMakeTests/downloads")

file(DOWNLOAD
  ${url}
  ${dir}/file3.png
  TIMEOUT 2
  STATUS status
  EXPECTED_HASH SHA1=5555555555555555555555555555555555555555
  )
