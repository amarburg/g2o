## Allows g2o/config.h to be found
fips_include_directories( ${FIPS_PROJECT_BUILD_DIR}/include/ )

set( G2O_LIBRARIES g2o_core
              g2o_types_data
              g2o_types_slam2d
              g2o_solver_csparse
              g2o_csparse_extension )
