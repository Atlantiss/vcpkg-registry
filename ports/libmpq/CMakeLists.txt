cmake_minimum_required(VERSION 3.20)

# Cmake configuration:

set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

project(libmpq VERSION 0.4.0 LANGUAGES C CXX)

find_package(ZLIB REQUIRED)
find_package(BZip2 REQUIRED)

add_definitions(-D_WIN32_WINNT=0x0601)
add_definitions(-DWIN32_LEAN_AND_MEAN)
add_definitions(-DNOMINMAX)

# Library configuration:

file(GLOB sources libmpq/*.c libmpq/*.h)

add_library(libmpq STATIC ${sources})
add_library(libmpq::libmpq ALIAS libmpq)

set_target_properties(libmpq PROPERTIES LINKER_LANGUAGE CXX)

if (WIN32)
    set(WIN_EXTRA_INCLUDE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/win>)
endif()

target_include_directories(libmpq
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        ${WIN_EXTRA_INCLUDE}
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(libmpq
    PRIVATE
        ZLIB::ZLIB
        BZip2::BZip2)

target_compile_options(libmpq
    INTERFACE 
        $<$<CXX_COMPILER_ID:MSVC>:/wd4996 /wd4985 /wd4244 /wd4267 /wd4619 /wd4512>)
    
# Package configuration

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

configure_file(
    "${PROJECT_SOURCE_DIR}/libmpqConfig.cmake.in"
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    @ONLY
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
    DESTINATION
    ${INSTALL_CONFIGDIR}
)

file(GLOB HEADERS "${CMAKE_CURRENT_LIST_DIR}/libmpq/*.h")

install(
    FILES ${HEADERS}
    DESTINATION "include/libmpq"
)

install(
    TARGETS  ${PROJECT_NAME}
    EXPORT   ${PROJECT_NAME}Targets DESTINATION lib
    INCLUDES                        DESTINATION include
)

install(
    EXPORT ${PROJECT_NAME}Targets
    FILE ${PROJECT_NAME}Targets.cmake
    NAMESPACE libmpq::
    DESTINATION ${INSTALL_CONFIGDIR}
)
