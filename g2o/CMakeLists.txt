cmake_minimum_required(VERSION 2.6)

fips_add_subdirectory(stuff)
fips_add_subdirectory(core)

IF(G2O_BUILD_APPS)
  fips_add_subdirectory(apps)
ENDIF(G2O_BUILD_APPS)

# Pre-canned types
fips_add_subdirectory(types)

# Solvers
fips_add_subdirectory(solvers)

# Examples
IF(G2O_BUILD_EXAMPLES)
  fips_add_subdirectory(examples)
ENDIF(G2O_BUILD_EXAMPLES)

if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/playground")
  # Playground
  OPTION (G2O_BUILD_PLAYGROUND "Build g2o playground" ON)
  IF (G2O_BUILD_PLAYGROUND)
    MESSAGE(STATUS "building playground")
    fips_add_subdirectory(playground)
  ENDIF()
ENDIF()
