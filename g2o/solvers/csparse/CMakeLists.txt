INCLUDE_DIRECTORIES(${CSPARSE_INCLUDE_DIR})
#
fips_begin_lib( g2o_csparse_extension )
# ADD_LIBRARY(csparse_extension ${G2O_LGPL_LIB_TYPE}
  fips_files(
    csparse_helper.cpp csparse_helper.h
    g2o_csparse_extension_api.h
  )

  fips_libs( csparse )
# SET_TARGET_PROPERTIES(csparse_extension PROPERTIES OUTPUT_NAME ${LIB_PREFIX}csparse_extension)
#
# IF(BUILD_CSPARSE)
#   TARGET_LINK_LIBRARIES(csparse_extension csparse)
# ELSE()
#   TARGET_LINK_LIBRARIES(csparse_extension ${CSPARSE_LIBRARY})
# ENDIF()

fips_end_lib()
#

fips_begin_module( g2o_solver_csparse )
# ADD_LIBRARY(solver_csparse ${G2O_LIB_TYPE}
  fips_files (
  solver_csparse.cpp
  linear_solver_csparse.h
  g2o_csparse_api.h
)
# SET_TARGET_PROPERTIES(solver_csparse PROPERTIES OUTPUT_NAME ${LIB_PREFIX}solver_csparse)
#
# TARGET_LINK_LIBRARIES(solver_csparse csparse_extension core)

  fips_libs( g2o_core g2o_csparse_extension )
#
#
# INSTALL(TARGETS solver_csparse csparse_extension
#   RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
#   LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
#   ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
# )
# FILE(GLOB headers "${CMAKE_CURRENT_SOURCE_DIR}/*.h" "${CMAKE_CURRENT_SOURCE_DIR}/*.hpp")
# INSTALL(FILES ${headers} DESTINATION ${CMAKE_INSTALL_PREFIX}/include/g2o/solvers/csparse)

fips_end_module()
