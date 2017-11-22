fips_begin_module( g2o_solver_slam2d_linear )

  fips_files(
    slam2d_linear.cpp
    solver_slam2d_linear.h solver_slam2d_linear.cpp
    g2o_slam2d_linear_api.h
  )

  INCLUDE_DIRECTORIES(${CSPARSE_INCLUDE_DIR})

# SET_TARGET_PROPERTIES(solver_slam2d_linear PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_slam2d_linear)
# TARGET_LINK_LIBRARIES(solver_slam2d_linear solver_csparse types_slam2d)

  fips_libs( g2o_solver_csparse g2o_types_slam2d )

# INSTALL(TARGETS solver_slam2d_linear
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
#
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/slam2d_linear)

fips_end_module()
