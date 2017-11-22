fips_begin_module( g2o_solver_structure_only )

  fips_files(
    structure_only.cpp
    structure_only_solver.h
  )

# SET_TARGET_PROPERTIES(solver_structure_only PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_structure_only)
  fips_libs( g2o_core )

# INSTALL(TARGETS solver_structure_only
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
#
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/structure_only)

fips_end_module()
