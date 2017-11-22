
fips_begin_module( g2o_solver_dense )
# ADD_LIBRARY(solver_dense ${G2O_LIB_TYPE}
    fips_files(
      solver_dense.cpp linear_solver_dense.h
    )

#
# SET_TARGET_PROPERTIES(solver_dense PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_dense)
#
    fips_libs( g2o_core )
#
# INSTALL(TARGETS solver_dense
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
#
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
#
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/dense)

fips_end_module()
