vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Atlantiss/cpp-package-g3dlite
    REF 1bfceb67ce807fc182e7ddbbe0a15653202532db
	SHA512 2d11c5bddab5044e19f752912d72cb5e75f1458f73bb4925262b4b6dda9c7da359a7e3c7dc5b5aedeca8f709d37b1a5955ef066a97d797db7d0b8c29b900d4a3
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME g3dlite CONFIG_PATH "lib/cmake/g3dlite")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/bin")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
    INSTALL "${SOURCE_PATH}/license.txt"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)