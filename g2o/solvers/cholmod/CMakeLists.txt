
fips_begin_module( g2o_solver_cholmod )

# ADD_LIBRARY(solver_cholmod ${G2O_LIB_TYPE}
  fips_files(
    solver_cholmod.cpp
    linear_solver_cholmod.h
  )

  INCLUDE_DIRECTORIES(${CHOLMOD_INCLUDE_DIR})

  fips_libs( ${CHOLMOD_LIBRARIES} ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} g2o_core)


# SET_TARGET_PROPERTIES(solver_cholmod PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_cholmod)
#
# ADD_DEFINITIONS(${BLAS_DEFINITIONS} ${LAPACK_DEFINITIONS})
# TARGET_LINK_LIBRARIES(solver_cholmod ${CHOLMOD_LIBRARIES} ${BLAS_LIBRARIES} ${LAPACK_LIBRARIES} core)
#
# INSTALL(TARGETS solver_cholmod
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
#
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
#
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/cholmod)

fips_end_module()
