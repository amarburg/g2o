# INCLUDE_DIRECTORIES(${G2O_EIGEN3_INCLUDE})

fips_begin_module( g2o_solver_eigen )
# ADD_LIBRARY(solver_eigen ${G2O_LIB_TYPE}

  fips_files (
    solver_eigen.cpp
    linear_solver_eigen.h
  )
# SET_TARGET_PROPERTIES(solver_eigen PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_eigen)
# TARGET_LINK_LIBRARIES(solver_eigen core)

  fips_libs( g2o_core )

# INSTALL(TARGETS solver_eigen
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/eigen)

fips_end_module()
