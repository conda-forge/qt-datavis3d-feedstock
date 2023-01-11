cmake_minimum_required (VERSION 3.13)

project(hello)

set(HELLO_QT_VERSION 5 CACHE STRING "Qt version")

find_package (Qt${HELLO_QT_VERSION}Widgets CONFIG REQUIRED)

add_executable(hello main.cxx)
target_link_libraries (hello Qt${HELLO_QT_VERSION}::Widgets)
