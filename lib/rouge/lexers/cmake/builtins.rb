module Rouge
  module Lexers
    class CMake
      BUILTIN_COMMANDS = Set.new %w[
        add_compile_definitions add_compile_options add_custom_command
        add_custom_target add_definitions add_dependencies
        add_executable add_library add_link_options add_subdirectory
        add_test aux_source_directory break build_command build_name
        cmake_host_system_information cmake_language cmake_minimum_required
        cmake_parse_arguments cmake_policy configure_file
        create_test_sourcelist define_property else elseif
        enable_language enable_testing endforeach endfunction endif
        endmacro endwhile exec_program execute_process export
        export_library_dependencies file find_file find_library
        find_package find_path find_program fltk_wrap_ui foreach
        function get_cmake_property get_directory_property
        get_filename_component get_property get_source_file_property
        get_target_property get_test_property if include
        include_directories include_external_msproject include_guard
        include_regular_expression install install_files install_programs
        install_targets link_directories link_libraries list
        load_cache load_command macro make_directory mark_as_advanced
        math message option output_required_files project qt_wrap_cpp
        qt_wrap_ui remove remove_definitions return separate_arguments
        set set_directory_properties set_property
        set_source_files_properties set_target_properties
        set_tests_properties site_name source_group string
        subdir_depends subdirs target_compile_definitions
        target_compile_features target_compile_options
        target_include_directories target_link_directories
        target_link_libraries target_link_options target_precompile_headers
        target_sources try_compile try_run unset use_mangled_mesa
        utility_source variable_requires variable_watch while
        write_file
      ]
    end
  end
end
