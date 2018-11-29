if( NOT FIPS_IMPORT)
  cmake_minimum_required(VERSION 3.5)
  get_filename_component(FIPS_ROOT_DIR "../fips" ABSOLUTE)
  include("${FIPS_ROOT_DIR}/cmake/fips.cmake")

  fips_setup(PROJECT g2o)
endif()

set(g2o_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# The library prefix
set(LIB_PREFIX g2o_)

set(g2o_C_FLAGS)
set(g2o_CXX_FLAGS)

# default built type
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
      "Choose the type of build, options are: None Debug Release RelWithDebInfo MinSizeRel."
      FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# postfix, based on type
# SET(CMAKE_DEBUG_POSTFIX "_d" CACHE STRING "postfix applied to debug build of libraries")
# SET(CMAKE_RELEASE_POSTFIX "" CACHE STRING "postfix applied to release build of libraries")
# SET(CMAKE_RELWITHDEBINFO_POSTFIX "_rd" CACHE STRING "postfix applied to release-with-debug-information libraries")
# SET(CMAKE_MINSIZEREL_POSTFIX "_s" CACHE STRING "postfix applied to minimium-size-build libraries")


# work out the postfix; required where we use OUTPUT_NAME
if(CMAKE_BUILD_TYPE MATCHES Release)
  set(EXE_POSTFIX)
elseif(CMAKE_BUILD_TYPE MATCHES Debug)
  set(EXE_POSTFIX ${CMAKE_DEBUG_POSTFIX})
elseif(CMAKE_BUILD_TYPE MATCHES RelWithDebInfo)
  set(EXE_POSTFIX ${CMAKE_RELWITHDEBINFO_POSTFIX})
elseif(CMAKE_BUILD_TYPE MATCHES MinSizeRel)
  set(EXE_POSTFIX ${CMAKE_MINSIZEREL_POSTFIX})
endif(CMAKE_BUILD_TYPE MATCHES Release)

# Allow the developer to select if Dynamic or Static libraries are built
option (BUILD_SHARED_LIBS "Build Shared Libraries (preferred and required for the g2o plugin system)" ON)
set (G2O_LIB_TYPE STATIC)
if (BUILD_SHARED_LIBS)
  set (G2O_LIB_TYPE SHARED)
endif()

# There seems to be an issue with MSVC8
# see http://eigen.tuxfamily.org/bz/show_bug.cgi?id=83
if(MSVC90)
  add_definitions(-DEIGEN_DONT_ALIGN_STATICALLY=1)
  message(STATUS "Disabling memory alignment for MSVC8")
endif(MSVC90)

# On the Mac platform, configure the RPATH as per the INSTALL, to
# avoid the problem of loading both the built and INSTALLed versions
# of the shared targets
if(APPLE)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
  set(CMAKE_INSTALL_RPATH "")
endif(APPLE)

# Set the output directory for the build executables and libraries
## et FIPS handle this...
# SET(g2o_RUNTIME_OUTPUT_DIRECTORY ${g2o_SOURCE_DIR}/bin CACHE PATH "Target for the binaries")
# IF(WIN32)
#   SET(g2o_LIBRARY_OUTPUT_DIRECTORY ${g2o_SOURCE_DIR}/bin CACHE PATH "Target for the libraries")
# ELSE(WIN32)
#   SET(g2o_LIBRARY_OUTPUT_DIRECTORY ${g2o_SOURCE_DIR}/lib CACHE PATH "Target for the libraries")
# ENDIF(WIN32)
# SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${g2o_LIBRARY_OUTPUT_DIRECTORY})
# SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${g2o_LIBRARY_OUTPUT_DIRECTORY})
# SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${g2o_RUNTIME_OUTPUT_DIRECTORY})

# Set search directory for looking for our custom CMake scripts to
# look for SuiteSparse, QGLViewer, and Eigen3.
list(APPEND CMAKE_MODULE_PATH ${g2o_SOURCE_DIR}/cmake_modules)

# Detect OS and define macros appropriately
if(WIN32)
  add_definitions(-DWINDOWS)
  message(STATUS "Compiling on Windows")
elseif(CYGWIN)
  message(STATUS "Compiling on Cygwin")
  add_definitions(-DCYGWIN)
elseif(APPLE)
  add_definitions(-DUNIX)
  message(STATUS "Compiling on OSX")
elseif(UNIX)
  add_definitions(-DUNIX)
  message(STATUS "Compiling on Unix")
endif(WIN32)

# detect Android Cross Compiler
# based on android-cmake which sets the variable ANDROID for us
if(ANDROID)
  add_definitions(-DANDROID)
  message(STATUS "Cross compiling for Android")
endif()

# For building the CHOLMOD / CSPARSE solvers
FIND_PACKAGE(Cholmod)
FIND_PACKAGE(BLAS)
FIND_PACKAGE(LAPACK)
IF(CHOLMOD_FOUND AND BLAS_FOUND AND LAPACK_FOUND)
  MESSAGE(STATUS "Found CHOLMOD and its dependencies")
  SET(CHOLMOD_FOUND TRUE)
ELSE()
  SET(CHOLMOD_FOUND FALSE)
ENDIF()

FIND_PACKAGE(CSparse)
IF(CSPARSE_FOUND)
  MESSAGE(STATUS "Found CSparse")
  SET(BUILD_CSPARSE OFF CACHE BOOL "Build local CSparse library")
ELSE(CSPARSE_FOUND)
  SET(BUILD_CSPARSE ON CACHE BOOL "Build local CSparse library")
  IF(BUILD_CSPARSE)
    SET(CSPARSE_FOUND TRUE)
  ENDIF()
ENDIF(CSPARSE_FOUND)
OPTION(BUILD_LGPL_SHARED_LIBS "Build LGPL Code as Shared Libraries (LGPL Code)" ON)
SET (G2O_LGPL_LIB_TYPE STATIC)
IF (BUILD_LGPL_SHARED_LIBS)
  SET (G2O_LGPL_LIB_TYPE SHARED)
ELSE()
  MESSAGE(STATUS "Building LGPL code as static library (affects license of the binary)")
ENDIF()


# Eigen library parallelise itself, though, presumably due to performance issues
# OPENMP is experimental. We experienced some slowdown with it
set(G2O_USE_OPENMP OFF CACHE BOOL "Build g2o with OpenMP support (EXPERIMENTAL)")
if(G2O_USE_OPENMP)
  find_package(OpenMP)
  if(OPENMP_FOUND)
    set (G2O_OPENMP 1)
    set(g2o_C_FLAGS "${g2o_C_FLAGS} ${OpenMP_C_FLAGS}")
    set(g2o_CXX_FLAGS "${g2o_CXX_FLAGS} -DEIGEN_DONT_PARALLELIZE ${OpenMP_CXX_FLAGS}")
    message(STATUS "Compiling with OpenMP support")
  endif(OPENMP_FOUND)
endif(G2O_USE_OPENMP)

# OpenGL is used in the draw actions for the different types, as well
# as for creating the GUI itself
FIND_PACKAGE(OpenGL)
SET(G2O_USE_OPENGL OFF CACHE BOOL "Build g2o with OpenGL support for visualization")
IF (OPENGL_FOUND AND G2O_USE_OPENGL)
  SET (G2O_HAVE_OPENGL 1)
  INCLUDE_DIRECTORIES(${OPENGL_INCLUDE_DIR})
  MESSAGE(STATUS "Compiling with OpenGL support")
ENDIF()

# For building the GUI
#FIND_PACKAGE(QGLViewer)

# shall we build the core apps using the library
SET(G2O_BUILD_APPS OFF CACHE BOOL "Build g2o apps")
IF(G2O_BUILD_APPS)
  MESSAGE(STATUS "Compiling g2o apps")
ENDIF(G2O_BUILD_APPS)


include(CMakeDependentOption)
CMAKE_DEPENDENT_OPTION(G2O_BUILD_LINKED_APPS "Build apps linked with the libraries (no plugin system)" OFF
  "G2O_BUILD_APPS" OFF)

# shall we build the examples
SET(G2O_BUILD_EXAMPLES OFF CACHE BOOL "Build g2o examples")
IF(G2O_BUILD_EXAMPLES)
  MESSAGE(STATUS "Compiling g2o examples")
ENDIF(G2O_BUILD_EXAMPLES)

option(G2O_FAST_MATH "Enable fast math operations" OFF)
option(G2O_NO_IMPLICIT_OWNERSHIP_OF_OBJECTS "Disables memory management in the graph types, this requires the callers to manager the memory of edges and nodes" OFF)

# Start of SSE* autodetect code
# (borrowed from MRPT CMake scripts, BSD)
option(DO_SSE_AUTODETECT "Enable autodetection of SSE* CPU sets and enable their use in optimized code" ON)
if(NOT EXISTS "/proc/cpuinfo")
	set(DO_SSE_AUTODETECT OFF)
endif()
if (DO_SSE_AUTODETECT)
  file(READ "/proc/cpuinfo" G2O_CPU_INFO)
endif()

# Macro for each SSE* var: Invoke with name in uppercase:
macro(DEFINE_SSE_VAR  _setname)
	string(TOLOWER ${_setname} _set)
	if (DO_SSE_AUTODETECT)
		# Automatic detection:
		set(CMAKE_G2O_HAS_${_setname} 0)
		if (${G2O_CPU_INFO} MATCHES ".*${_set}.*")
			set(CMAKE_G2O_HAS_${_setname} 1)
		endif()
	else (DO_SSE_AUTODETECT)
		# Manual:
		set("DISABLE_${_setname}" OFF CACHE BOOL "Forces compilation WITHOUT ${_setname} extensions")
		mark_as_advanced("DISABLE_${_setname}")
		set(CMAKE_G2O_HAS_${_setname} 0)
		if (NOT DISABLE_${_setname})
			set(CMAKE_G2O_HAS_${_setname} 1)
		endif (NOT DISABLE_${_setname})
	endif (DO_SSE_AUTODETECT)
endmacro(DEFINE_SSE_VAR)

# SSE optimizations:
DEFINE_SSE_VAR(SSE2)
DEFINE_SSE_VAR(SSE3)
DEFINE_SSE_VAR(SSE4_1)
DEFINE_SSE_VAR(SSE4_2)
DEFINE_SSE_VAR(SSE4_A)

# Add build flags for clang AND GCC
if (${CMAKE_CXX_COMPILER_ID} MATCHES "Clang" OR CMAKE_COMPILER_IS_GNUCXX)
  # SSE2?
  if (CMAKE_G2O_HAS_SSE2)
    add_compile_options(-msse2)
  endif()
  # SSE3?
  if (CMAKE_G2O_HAS_SSE3)
    add_compile_options(-msse3 -mssse3)
  endif()
  # SSE4*?
  if (CMAKE_G2O_HAS_SSE4_1)
    add_compile_options(-msse4.1)
  endif()
  if (CMAKE_G2O_HAS_SSE4_2)
    add_compile_options(-msse4.2)
  endif()
  if (CMAKE_G2O_HAS_SSE4_A)
    add_compile_options(-msse4a)
  endif()
endif()
# End of of SSE* autodetect code -------

# Compiler specific options for gcc
if(CMAKE_COMPILER_IS_GNUCXX)
  option (BUILD_WITH_MARCH_NATIVE "Build with \"-march native\"" OFF)
  message(STATUS "Compiling with GCC")

  # Generic settings for optimisation
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")

  if(G2O_FAST_MATH)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -ffast-math")
  endif()

  # switch off optimization for debug builds
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")

  # OS X
  #if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    #set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
    #set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
  #endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  # Linux
  if(BUILD_WITH_MARCH_NATIVE AND NOT "${CMAKE_SYSTEM_PROCESSOR}" MATCHES "arm" AND "${CMAKE_SYSTEM_NAME}" MATCHES "Linux")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -march=native")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -march=native")
  endif()
  # activate warnings !!!
  set(g2o_C_FLAGS "${g2o_C_FLAGS} -Wall -W")
  set(g2o_CXX_FLAGS "${g2o_CXX_FLAGS} -Wall -W")
endif(CMAKE_COMPILER_IS_GNUCXX)

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  message(STATUS "Compiling with Clang")

  # activate all warnings
  #set(g2o_C_FLAGS "${g2o_C_FLAGS} -Weverything")
  #set(g2o_CXX_FLAGS "${g2o_CXX_FLAGS} -Weverything")
  set(g2o_C_FLAGS "${g2o_C_FLAGS} -Wall")
  set(g2o_CXX_FLAGS "${g2o_CXX_FLAGS} -Wall")
  #set(g2o_CXX_FLAGS "${g2o_CXX_FLAGS} -Wall -stdlib=libc++")
endif()

if(MSVC)
  message(STATUS "Compiling with MSVC")

  if (CMAKE_GENERATOR MATCHES "ARM(64)?$")
    set(MSVC_ARM ON)
  endif()

  add_definitions(-DNOMINMAX)
  add_definitions(-D_USE_MATH_DEFINES)

  # exception handling
  add_definitions("/EHsc")

  if (G2O_FAST_MATH)
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /fp:fast")
  endif()

  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Ox /Oi")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Ox /Oi")

  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")

  # SSE2 optimizations
  # No need to specify if building for x64 (actually, it generates an annoying warning)
  if (NOT MSVC_ARM)
    if(NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
        add_definitions("/arch:SSE2")
    endif()
  endif()

  if (BUILD_SHARED_LIBS)
    # disable warning on missing DLL interfaces
    add_definitions("/wd4251")
  endif()

  # Fix issue: https://github.com/RainerKuemmerle/g2o/issues/66
  #            Link error LNK2005 due to duplicated symbols
  add_definitions("/Ob2")
  # Fix other stupid warnings:
  add_definitions(-D_CRT_SECURE_NO_WARNINGS=1)  # Avoid deprecated fprintf(), etc.
  add_definitions("/nologo")
  # TODO not sure this should be a thing
  add_definitions("/wd4244") # Conversion from number_t -> int
  add_definitions("/wd4267") # Conversion during return
  add_definitions("/wd4522") # Duplicated operator=() in Eigen headers

endif(MSVC)

# C++11 support
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# specifying compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${g2o_CXX_FLAGS}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${g2o_C_FLAGS}")

# Find Eigen3. First try to find it using the configuration file form
# because this is our target of choice. If this fails, fall back to the
# using the module form.
# See https://eigen.tuxfamily.org/dox/TopicCMakeGuide.html for details
# find_package(Eigen3 NO_MODULE)
# if (TARGET Eigen3::Eigen)
#   set(G2O_EIGEN3_EIGEN_TARGET Eigen3::Eigen)
# else()
  find_package(Eigen3 REQUIRED)
  fips_include_directories(${EIGEN3_INCLUDE_DIR})
# endif ()

# Set up the top-level include directories
fips_include_directories(${g2o_SOURCE_DIR} ${PROJECT_BINARY_DIR})

# Generate config.h
SET(G2O_OPENGL_FOUND ${OPENGL_FOUND})
SET(G2O_HAVE_CHOLMOD ${CHOLMOD_FOUND})
SET(G2O_HAVE_CSPARSE ${CSPARSE_FOUND})
SET(G2O_SHARED_LIBS ${BUILD_SHARED_LIBS})
SET(G2O_LGPL_SHARED_LIBS ${BUILD_LGPL_SHARED_LIBS})
SET(G2O_CXX_COMPILER "${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER}")
configure_file(config.h.in ${FIPS_PROJECT_BUILD_DIR}/include/g2o/config.h)
fips_include_directories(${FIPS_PROJECT_BUILD_DIR}/include)
fips_include_directories(${PROJECT_SOURCE_DIR})
#INSTALL(FILES ${PROJECT_BINARY_DIR}/g2o/config.h DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o)

# Include the subdirectories
# TODO:  Skip this in initial fips port
#fips_add_subdirectory(EXTERNAL)
fips_add_subdirectory(g2o)

if( NOT FIPS_RTTI )
  message( SEND_ERROR "G2O requires FIPS_RTTI, please add it to the current build configuration")
endif()

if( NOT FIPS_IMPORT )

  # if( FIPS_UNITTESTS )
  #   fips_add_subdirectory(unit_test)
  # endif()

  fips_finish()
endif()
