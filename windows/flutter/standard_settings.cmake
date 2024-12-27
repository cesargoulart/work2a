# standard_settings.cmake
function(apply_standard_settings TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  set_target_properties(${TARGET} PROPERTIES
    CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++17"
  )
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=1")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()
