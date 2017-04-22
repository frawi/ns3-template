#.rst:
# FindNS3
# --------
#
# Find the ns-3 libraries and includes
#
# Imported Targets
# ^^^^^^^^^^^^^^^^
#
# If NS3 is found, this module defines the following :prop_tgt:`IMPORTED`
# targets::
#
#  NS3::core        - Core module
#  NS3::${comp}     - Library for the ns-3 module ${comp}
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project::
#
#  NS3_FOUND          - True if NS3 found on the local system
#  NS3_INCLUDE_DIRS   - Location of NS3 header files.
#  NS3_LIBRARIES      - The NS3 libraries.
#  NS3_TARGETS        - List of all largets
#
# Hints
# ^^^^^
#
# Set ``NS3_ROOT_DIR`` to a directory that contains a NS3 installation.
# Set ``NS3_SOURCE_DIR`` to a directory that contains the NS3 source.
# Set ``NS3_BUILD_DIR`` to a directory that contains the compiled NS3 binaries.

include(FindPackageHandleStandardArgs)

if( EXISTS "$ENV{NS3_SOURCE_DIR}" )
    file( TO_CMAKE_PATH "$ENV{NS3_SOURCE_DIR}" NS3_SOURCE_DIR )
    set( NS3_SOURCE_DIR "${NS3_SOURCE_DIR}" CACHE PATH "NS3 source directory.")
endif()

if( EXISTS "$ENV{NS3_BUILD_DIR}" )
    file( TO_CMAKE_PATH "$ENV{NS3_BUILD_DIR}" NS3_BUILD_DIR )
    set( NS3_BUILD_DIR "${NS3_BUILD_DIR}" CACHE PATH "NS3 build directory.")
endif()

if( NOT DEFINED NS3_VERSION )
    set( NS3_VERSION "3-dev" CACHE STRING "NS3 version.")
    if( NOT DEFINED NS3_BUILD_TYPE )
        set( NS3_BUILD_TYPE "debug" CACHE STRING "NS3 build type." )
    endif()
endif()

if( DEFINED NS3_BUILD_TYPE )
    set( NS3_SUFFIX "-${NS3_BUILD_TYPE}" )
endif()

find_path( NS3_INCLUDE_DIR
    NAMES ns3/core-module.h
    HINTS ${NS3_BUILD_DIR} ${NS3_SOURCE_DIR}/build
    PATH_SUFFIXES ns${NS3_VERSION}
    )

find_library( NS3_CORE
    NAMES ns${NS3_VERSION}-core${NS3_SUFFIX}
    HINTS ${NS3_BUILD_DIR} ${NS3_SOURCE_DIR}/build
    )

set( NS3_INCLUDE_DIRS ${NS3_INCLUDE_DIR} )
set( NS3_LIBRARIES ${NS3_CORE} )

if( NS3_FIND_COMPONENTS )
    foreach(comp ${NS3_FIND_COMPONENTS})
        find_library( NS3_LIB_${comp}
            NAMES ns${NS3_VERSION}-${comp}${NS3_SUFFIX}
            HINTS ${NS3_BUILD_DIR} ${NS3_SOURCE_DIR}/build
            )
        if( NS3_LIB_${comp} )
            set(NS3_${comp}_FOUND 1)
        else()
            set(NS3_${comp}_FOUND 0)
        endif()
    endforeach()
endif()

find_package_handle_standard_args( NS3
    FOUND_VAR NS3_FOUND
    REQUIRED_VARS NS3_INCLUDE_DIRS NS3_LIBRARIES
    HANDLE_COMPONENTS
    )

mark_as_advanced( NS3_ROOT_DIR NS3_INCLUDE_DIR NS3_CORE)

if( NS3_FOUND )
    if( NOT TARGET NS3::core )
        add_library( NS3::core SHARED IMPORTED )
        set_target_properties( NS3::core PROPERTIES
            IMPORTED_LOCATION "${NS3_CORE}"
            INTERFACE_INCLUDE_DIRECTORIES "${NS3_INCLUDE_DIRS}"
            IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
            )
    endif()
    set(NS3_TARGETS NS3::core)

    if( NS3_FIND_COMPONENTS )
        foreach(comp ${NS3_FIND_COMPONENTS})
            if( NS3_${comp}_FOUND )
                if( NOT TARGET NS3::${comp} )
                    add_library( NS3::${comp} SHARED IMPORTED )
                    set_target_properties( NS3::${comp} PROPERTIES
                        IMPORTED_LOCATION "${NS3_LIB_${comp}}"
                        INTERFACE_INCLUDE_DIRECTORIES "${NS3_INCLUDE_DIRS}"
                        IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                        )
                endif()
                set(NS3_TARGETS ${NS3_TARGETS} NS3::${comp})
            endif()
        endforeach()
    endif()
endif()
