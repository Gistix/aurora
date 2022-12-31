# cmake/FindOpenVR.cmake
cmake_minimum_required(VERSION 3.22)

function(_OpenVR_find)
  include(FindPackageHandleStandardArgs)
  include(SelectLibraryConfigurations)
  
  set(OpenVR_ROOT "$ENV{VCPKG_ROOT}/installed/x64-windows-static-md")
 
  #set(OpenVR_ROOT "extern/openvr")
   
  ## Find the include path
  find_path(OpenVR_INCLUDE_DIR NAMES openvr.h HINTS "${OpenVR_ROOT}/include")
  #set(OpenVR_INCLUDE_DIR "${OpenVR_ROOT}/include")

  ## Determine version by scanning header
  if (OpenVR_INCLUDE_DIR)
    set(openvr_header "${OpenVR_INCLUDE_DIR}/openvr.h")

    set(re_major "^\tstatic const uint32_t k_nSteamVRVersionMajor = ([0-9]+).*;$")
    set(re_minor "^\tstatic const uint32_t k_nSteamVRVersionMinor = ([0-9]+).*;$")
    set(re_patch "^\tstatic const uint32_t k_nSteamVRVersionBuild = ([0-9]+).*;$")

    file(STRINGS "${openvr_header}" OpenVR_VERSION_MAJOR REGEX "${re_major}")
    file(STRINGS "${openvr_header}" OpenVR_VERSION_MINOR REGEX "${re_minor}")
    file(STRINGS "${openvr_header}" OpenVR_VERSION_PATCH REGEX "${re_patch}")

    string(REGEX REPLACE "${re_major}" "\\1"
           OpenVR_VERSION_MAJOR "${OpenVR_VERSION_MAJOR}")
    string(REGEX REPLACE "${re_minor}" "\\1"
           OpenVR_VERSION_MINOR "${OpenVR_VERSION_MINOR}")
    string(REGEX REPLACE "${re_patch}" "\\1"
           OpenVR_VERSION_PATCH "${OpenVR_VERSION_PATCH}")

    if (OpenVR_VERSION_MAJOR AND OpenVR_VERSION_MINOR AND OpenVR_VERSION_PATCH)
      set(OpenVR_VERSION
          "${OpenVR_VERSION_MAJOR}.${OpenVR_VERSION_MINOR}.${OpenVR_VERSION_PATCH}")
    endif ()
  endif ()

  message("INFO: ${OpenVR_ROOT}")

  ## Find the library
  find_library(OpenVR_LIBRARY_RELEASE NAMES openvr_api HINTS "${OpenVR_ROOT}/lib")
  
  message("INFO: ${OpenVR_LIBRARY_RELEASE}")

  select_library_configurations(OpenVR)
 
  message("INFO: ${OpenVR_LIBRARY}")

  ## Perform all the standard required, version, etc. argument checks.
  find_package_handle_standard_args(
    OpenVR
    REQUIRED_VARS OpenVR_LIBRARY OpenVR_INCLUDE_DIR
    VERSION_VAR OpenVR_VERSION
    HANDLE_VERSION_RANGE
    HANDLE_COMPONENTS
  )

   message("INFO: ${OpenVR_FOUND}, ${OpenVR_LIBRARY}")

  ## Create OpenVR::OpenVR imported target.
  if (OpenVR_FOUND AND NOT OpenVR::OpenVR)
    add_library(OpenVR::OpenVR UNKNOWN IMPORTED)
    target_include_directories(OpenVR::OpenVR INTERFACE "${OpenVR_INCLUDE_DIR}")
    set_target_properties(
      OpenVR::OpenVR PROPERTIES IMPORTED_LOCATION "${OpenVR_LIBRARY}"
    )
  endif ()

  ## Export whitelisted variables
  set(OpenVR_FOUND "${OpenVR_FOUND}" PARENT_SCOPE)
  set(OpenVR_VERSION "${OpenVR_VERSION}" PARENT_SCOPE)
endfunction()

_OpenVR_find()

function(_OpenVR_find)
endfunction()

function(_OpenVR_find)
endfunction()