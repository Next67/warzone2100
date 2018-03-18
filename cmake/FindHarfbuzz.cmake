# - Try to locate Harfbuzz
# This module defines:
#
#  HARFBUZZ_INCLUDE_DIRS
#  HARFBUZZ_LIBRARIES
#  HARFBUZZ_FOUND
#  HARFBUZZ_VERSION_STRING, human-readable string containing the version of Harfbuzz
#

find_package(PkgConfig)
# If PkgConfig is available, attempt to find Harfbuzz using PkgConfig
if(PkgConfig_FOUND)
	if(Harfbuzz_FIND_VERSION)
		if(Harfbuzz_FIND_VERSION_EXACT)
			set(_pkgConfig_version_match "==${Harfbuzz_FIND_VERSION}")
		else()
			set(_pkgConfig_version_match ">=${Harfbuzz_FIND_VERSION}")
		endif()
	endif()
	pkg_search_module(PCFG_HARFBUZZ QUIET harfbuzz${_pkgConfig_version_match})
	if(PCFG_HARFBUZZ_FOUND)
		# Found Harfbuzz with PkgConfig
		set(HARFBUZZ_INCLUDE_DIRS "${PCFG_HARFBUZZ_INCLUDE_DIRS}")
		set(HARFBUZZ_LIBRARIES "${PCFG_HARFBUZZ_LIBRARIES}")
		set(HARFBUZZ_VERSION_STRING "${PCFG_HARFBUZZ_VERSION}" CACHE INTERNAL "")
		INCLUDE(FindPackageHandleStandardArgs)
		FIND_PACKAGE_HANDLE_STANDARD_ARGS(Harfbuzz REQUIRED_VARS HARFBUZZ_INCLUDE_DIRS HARFBUZZ_LIBRARIES VERSION_VAR HARFBUZZ_VERSION_STRING)
		MARK_AS_ADVANCED(HARFBUZZ_INCLUDE_DIRS HARFBUZZ_LIBRARIES)
		return()
	endif()
endif()

# Attempt to find Harfbuzz manually

FIND_PATH(NORMAL_HARFBUZZ_INCLUDE_DIRS hb.h PATH_SUFFIXES harfbuzz)
FIND_LIBRARY(NORMAL_HARFBUZZ_LIBRARIES NAMES harfbuzz)

if(NORMAL_HARFBUZZ_INCLUDE_DIRS AND EXISTS "${NORMAL_HARFBUZZ_INCLUDE_DIRS}/hb-version.h")
	file(STRINGS "${NORMAL_HARFBUZZ_INCLUDE_DIRS}/hb-version.h" HARFBUZZ_VERSION_STRING_LINE REGEX "^#define[ \t]+HB_VERSION_STRING[ \t]+\"[.0-9]+\"$")
	string(REGEX REPLACE "^#define[ \t]+HB_VERSION_STRING[ \t]+\"([.0-9]+)\"$" "\\1" NORMAL_HARFBUZZ_VERSION_STRING "${HARFBUZZ_VERSION_STRING_LINE}")
	unset(HARFBUZZ_VERSION_STRING_LINE)
else()
	if (NORMAL_HARFBUZZ_INCLUDE_DIRS)
		message ( WARNING "Can't find ${NORMAL_HARFBUZZ_INCLUDE_DIRS}/hb-version.h" )
	endif()
	set(NORMAL_HARFBUZZ_VERSION_STRING "")
endif()

set(HARFBUZZ_INCLUDE_DIRS "${NORMAL_HARFBUZZ_INCLUDE_DIRS}")
set(HARFBUZZ_LIBRARIES "${NORMAL_HARFBUZZ_LIBRARIES}")
set(HARFBUZZ_VERSION_STRING "${NORMAL_HARFBUZZ_VERSION_STRING}")

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(Harfbuzz REQUIRED_VARS HARFBUZZ_INCLUDE_DIRS HARFBUZZ_LIBRARIES VERSION_VAR HARFBUZZ_VERSION_STRING)

MARK_AS_ADVANCED(HARFBUZZ_INCLUDE_DIRS HARFBUZZ_LIBRARIES)