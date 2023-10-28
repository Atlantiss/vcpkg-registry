vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Atlantiss/cpp-package-g3dlite
    REF 1bfceb67ce807fc182e7ddbbe0a15653202532db
	SHA512 DDB7805A1A5BFC0C96B8F7B71087CC0667105DE7C33CC95B9F158FB57C9A8BFEA93CF887F8806BC9E8CB6044B843CF37DD9B9F2F1DB7783D8089442F2643448C
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