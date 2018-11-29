fips_add_subdirectory(pcg)
fips_add_subdirectory(dense)
fips_add_subdirectory(structure_only)

IF(CSPARSE_FOUND)
  fips_add_subdirectory(csparse)
  fips_add_subdirectory(slam2d_linear)
ENDIF()

IF(CHOLMOD_FOUND)
  fips_add_subdirectory(cholmod)
ENDIF(CHOLMOD_FOUND)

# Sparse Module of Eigen is stable starting from 3.1
IF (DEFINED EIGEN3_VERSION)
  IF(${EIGEN3_VERSION} VERSION_GREATER "3.1.0" OR ${EIGEN3_VERSION} VERSION_EQUAL "3.1.0")
    fips_add_subdirectory(eigen)
  ENDIF()
ENDIF()
