cmake_minimum_required(VERSION 3.0)
project(ns3-template)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -W -Wextra -pedantic -std=c++17")

# Set the NS3_VERSION variable to the version of your distribution
# set( NS3_VERSION "3.22" )

# Or if you compile ns3 yourself run cmake with:
# cmake . -DNS_SOURCE_DIR=/full/path/to/ns3-repo

find_package(NS3 COMPONENTS wifi mobility network internet wave point-to-point REQUIRED)

add_executable(first src/first.cc)
target_link_libraries(first ${NS3_TARGETS} )
