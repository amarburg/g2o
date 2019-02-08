#
fips_begin_lib( g2o_csparse_extension )
# ADD_LIBRARY(csparse_extension ${G2O_LGPL_LIB_TYPE}
  fips_include_directories(${CSPARSE_INCLUDE_DIR})

  fips_files(
    csparse_helper.cpp csparse_extension.cpp
  )

  fips_libs( ${CSPARSE_LIBRARY} )

fips_end_lib()

fips_begin_module( g2o_solver_csparse )
  fips_include_directories(${CSPARSE_INCLUDE_DIR})

  fips_files (
    solver_csparse.cpp
    linear_solver_csparse.h
    g2o_csparse_api.h
  )

  fips_libs( g2o_core g2o_csparse_extension )

fips_end_module()
