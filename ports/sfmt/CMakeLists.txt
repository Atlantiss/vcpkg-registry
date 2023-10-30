cmake_minimum_required(VERSION 3.20)

# Cmake configuration:

set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(sfmt VERSION 1.5.0 LANGUAGES C CXX)

add_definitions(-D_WIN32_WINNT=0x0601)
add_definitions(-DWIN32_LEAN_AND_MEAN)
add_definitions(-DNOMINMAX)

# Library configuration:

set(SFMT_HEADERS
  SFMT.h
  SFMT-alti.h
  SFMT-common.h
  SFMT-neon.h
  SFMT-params.h
  SFMT-params607.h
  SFMT-params1279.h
  SFMT-params2281.h
  SFMT-params4253.h
  SFMT-params11213.h
  SFMT-params19937.h
  SFMT-params44497.h
  SFMT-params86243.h
  SFMT-params132049.h
  SFMT-params216091.h
  SFMT-sse2.h
  SFMT-sse2-msc.h)

set(SFMT_SOURCES
  SFMT.c
  ${SFMT_HEADERS})

if (${BUILD_SHARED_LIB})
    add_library(sfmt SHARED ${SFMT_SOURCES})
else()
    add_library(sfmt STATIC ${SFMT_SOURCES})
endif()

add_library(sfmt::sfmt ALIAS sfmt)
set_target_properties(sfmt PROPERTIES LINKER_LANGUAGE CXX)

target_include_directories(sfmt
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_compile_options(sfmt
    INTERFACE 
        $<$<CXX_COMPILER_ID:MSVC>:/wd4996 /wd4985 /wd4244 /wd4267 /wd4619 /wd4512>)
    
# Package configuration

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

configure_file(
    "${PROJECT_SOURCE_DIR}/sfmtConfig.cmake.in"
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    @ONLY
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    DESTINATION
    ${INSTALL_CONFIGDIR}
)

install(
    FILES ${SFMT_HEADERS}
    DESTINATION "include/sfmt"
)

install(
    TARGETS  ${PROJECT_NAME}
    EXPORT   ${PROJECT_NAME}Targets
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

install(
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE sfmt::
    DESTINATION ${INSTALL_CONFIGDIR}
)
