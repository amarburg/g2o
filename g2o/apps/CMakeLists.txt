fips_add_subdirectory(g2o_cli)
fips_add_subdirectory(g2o_hierarchical)

IF (G2O_HAVE_OPENGL)
  fips_add_subdirectory(g2o_simulator)
ENDIF()

IF(QGLVIEWER_FOUND AND Qt5_FOUND)
  fips_add_subdirectory(g2o_viewer)
ENDIF()

IF(G2O_BUILD_LINKED_APPS)
  fips_add_subdirectory(linked_binaries)
ENDIF()
