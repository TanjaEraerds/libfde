
#f90_include_dirs    = .
#f90_pp              = full
#f90_pp_flags        = BUILT_TYPE=SHARED_LIB
#f90_options         = pic shared
#f90_options_debug   = debug
#f90_options_release = O3
#f90_files           = string_ref.f90 exception.f90 main.f90
#f90_moduleLib       =
#f90_library_dirs    = ./$(mk_config)
#f90_link_options    =
#f90_link_libs       = fortres
#f90_link_output     = fortresTest
#
#cpp_include_dirs    = .
#cpp_pp              = debug
#cpp_options         = pic shared
#cpp_options_debug   = debug
#cpp_options_release = O3
#cpp_files           = exception.cpp
#cpp_moduleLib       =
#cpp_library_dirs    =
#cpp_link_options    = pic shared
#cpp_link_libs       =
#cpp_link_output     = libfortres.so
#
#user_configurations = special
#
## generic: rules & settings
##
#mk_configurations = debug release $(user_configurations: % =%)
#mk_config         = $(if $(_config),$(_config),debug)
#
## f90: rules & settings ...
##
## compiler specifics ...
#mk_f90_compiler    = ifort
#mk_f90_includePath = -I
#mk_f90_modulePath  = -module
#mk_f90_ppFlag      = -D
#mk_f90_compile     = -c
#mk_f90_out         = -o
#mk_f90_pp_off      =
#mk_f90_pp_on       = -fpp
#mk_f90_pp_full     = -fpp -allow nofpp-comments
#mk_f90_pp_debug    = $(mk_f90_pp_full) -save-temps
#mk_f90_pic         = -fpic
#mk_f90_shared      = -shared
#mk_f90_debug       = -debug full
#mk_f90_O0          = -O0
#mk_f90_O1          = -O1
#mk_f90_O2          = -O2
#mk_f90_O3          = -O3
#mk_f90_libraryPath = -L
#mk_f90_linkLib     = -l
#mk_f90_tmps        = *.s *.i90
#
## mk_f90_compiler    = gfortan
## mk_f90_includePath = -I
## mk_f90_modulePath  = -J
## mk_f90_ppFlag      = -D
## mk_f90_compile     = -c
## mk_f90_out         = -o
## mk_f90_pp_off      =
## mk_f90_pp_on       = -x f95-cpp-input
## mk_f90_pp_full     = $(mk_f90_pp_on) -ffree-line-length-none
#
## derived ...
#mk_f90_I_dirs       = $(f90_include_dirs:%=$(mk_f90_includePath)%) $(mk_f90_includePath)./$(mk_config)
#mk_f90_module_dirs  = $(mk_f90_modulePath) ./$(mk_config)
#mk_f90_fpp_cmd      = $(mk_f90_pp_$(f90_pp))
#mk_f90_fpp_flags    = $(f90_pp_flags:%=$(mk_f90_ppFlag)%)
#mk_f90_fpp          = $(mk_f90_fpp_cmd) $(mk_f90_fpp_flags)
#mk_f90_opts         = $(f90_options) $(f90_options_$(mk_config))
#mk_f90_options      = $(foreach opt,$(mk_f90_opts:%=mk_f90_%),$($(opt)))
#mk_f90_files        = $(wildcard $(f90_files))
#mk_f90_objects      = $(mk_f90_files:%.f90=$(mk_config)/%.fo)
#mk_f90_modules      = $(wildcard $(mk_config)/*.mod)
#mk_f90_moduleLib    = $(mk_config)/$(if $(f90_moduleLib),$(f90_moduleLib),modules.lib)
#mk_f90_L_dirs       = $(f90_library_dirs:%=$(mk_f90_libraryPath)%)
#mk_f90_link_libs    = $(f90_link_libs:%=$(mk_f90_linkLib)%)
#mk_f90_link_options = $(foreach opt,$(f90_link_options:%=mk_f90_%),$($(opt)))
#mk_f90_link_output  = $(mk_config)/$(f90_link_output)
#mk_f90_tmp_files    = $(wildcard $(mk_f90_tmps))
#
#$(mk_config)/%.fo: %.f90
#	$(mk_f90_compiler) $(mk_f90_fpp) $(mk_f90_options) $(mk_f90_I_dirs) $(mk_f90_module_dirs) $(mk_f90_compile) $< $(mk_f90_out) $@
#
#
#
#
#$(mk_config)/%.o: %.cpp
#	$(mk_cpp_compiler) $(mk_cpp_pp) $(mk_cpp_I_dirs) $(mk_cpp_options) $(mk_cpp_compile) $< $(mk_cpp_out) $@
#
#
## debug target, printing variable contents
##
#echo_%:
#	@echo "$* = $($*)"
#
#.PHONY: all objects clean $(mk_configurations)
#
#all: $(mk_config)\/ $(mk_cpp_link_output) $(mk_f90_link_output)
#	@echo "done"
#
#$(mk_config)\/:
#	mkdir -p $@
#
#$(mk_configurations):
#	mkdir -p $@
#	$(MAKE) _config=$@ all
#
#clean:
#	rm -f $(mk_f90_objects) $(mk_f90_modules) $(mk_f90_moduleLib) $(mk_f90_tmp_files)
#	rm -f $(mk_cpp_objects) $(mk_f90_tmp_files)
#
#$(mk_f90_link_output): $(mk_f90_objects)
#	$(mk_f90_compiler) $(mk_f90_objects) $(mk_f90_link_options) $(mk_f90_L_dirs) $(mk_f90_link_libs) $(mk_f90_out) $@
#	
#objects: $(mk_f90_objects)
#	ar rc $(mk_f90_moduleLib) $(mk_config)/*.mod
#
#$(mk_cpp_link_output): $(mk_cpp_objects)
#	$(mk_cpp_compiler) $(mk_cpp_objects) $(mk_cpp_link_options) $(mk_cpp_L_dirs) $(mk_cpp_link_libs) $(mk_cpp_out) $@
#

mk_cpp_compiler    = g++
mk_cpp_includePath = -I
mk_cpp_ppFlag      = -D
mk_cpp_compile     = -c
mk_cpp_out         = -o
mk_cpp_pp_debug    = -save-temps
mk_cpp_pic         = -fPIC
mk_cpp_shared      = -shared
mk_cpp_debug       = -ggdb
mk_cpp_O0          = -O0
mk_cpp_O1          = -O1
mk_cpp_O2          = -O2
mk_cpp_O3          = -O3
mk_cpp_libraryPath = -L
mk_cpp_linkLib     = -l
mk_f90_tmps        = *.s *.i *.ii

## derived ... C++
mk_cpp_I_dirs       = $(cpp_include_dirs:%=$(mk_cpp_includePath)%)
mk_cpp_module_dirs  = $(mk_f90_modulePath) ./$(mk_config)
mk_cpp_pp_cmd       = $(mk_cpp_pp_$(cpp_pp))
mk_cpp_pp_flags     = $(cpp_pp_flags:%=$(mk_cpp_ppFlag)%)
mk_cpp_pp           = $(mk_cpp_pp_cmd) $(mk_cpp_pp_flags)
mk_cpp_opts         = $(cpp_options) $(cpp_options_$(mk_config))
mk_cpp_files        = $(wildcard $(cpp_files))
mk_cpp_objects      = $(mk_cpp_files:%.cpp=$(mk_config)/%.o)
mk_cpp_modules      = $(wildcard $(mk_config)/*.mod)
mk_cpp_moduleLib    = $(mk_config)/$(if $(cpp_moduleLib),$(cpp_moduleLib),modules.lib)
mk_cpp_L_dirs       = $(cpp_library_dirs:%=$(mk_cpp_libraryPath)%)
mk_cpp_link_libs    = $(cpp_link_libs:%=$(mk_cpp_linkLib)%)
mk_cpp_tmp_files    = $(wildcard $(mk_cpp_tmps))


mk_libtype                ?= $(if $(_libtype),$(_libtype),shared)
mk_arch										?= $(if $(_arch),$(_arch),x32)
mk_build_dir							 = $(mk_libtype).$(mk_arch)

mk_cpp_archopt_x32         = -m32
mk_cpp_archopt_x64         = -m64
mk_cpp_archopt             = $(mk_cpp_archopt_$(mk_arch))

mk_lib_mayor               = 0
mk_lib_minor               = 1
mk_lib_version             = $(mk_lib_mayor).$(mk_lib_minor)
mk_cpp_libname_shared			 = libfortres.$(mk_arch).so
mk_cpp_options_shared      = -fPIC -g $(mk_cpp_archopt)
mk_cpp_link_options_shared = -shared -Wl,-soname,$(mk_cpp_libname_shared).$(mk_lib_mayor) $(mk_cpp_archopt)
mk_cpp_linker_shared       = g++
mk_cpp_link_output_shared  = $(mk_build_dir)/$(mk_cpp_libname_shared).$(mk_lib_version)
mk_cpp_linker_out_shared   = -o

mk_cpp_libname_static      = libfortres.$(mk_arch).a
mk_cpp_options_static      = -O3 $(mk_cpp_archopt)
mk_cpp_link_options_static = rcs
mk_cpp_linker_static       = ar
mk_cpp_link_output_static  = $(mk_build_dir)/$(mk_cpp_libname_static)
mk_cpp_linker_out_static   = 


mk_cpp_options             = $(mk_cpp_options_$(mk_libtype))
mk_cpp_linker              = $(mk_cpp_linker_$(mk_libtype))
mk_cpp_link_output         = $(mk_cpp_link_output_$(mk_libtype))
mk_cpp_link_options        = $(mk_cpp_link_options_$(mk_libtype))
mk_cpp_linker_out          = $(mk_cpp_linker_out_$(mk_libtype))


shared static:
	$(MAKE) library _libtype=$@ _arch=x32
	$(MAKE) library _libtype=$@ _arch=x64
	@echo "done"

release:
	$(MAKE) shared

clean:
	rm -rf shared.x?? static.x?? release

library:
	mkdir -p $(mk_build_dir) release
	$(MAKE) $(mk_cpp_link_output)
	cp $(mk_cpp_link_output) release
	ln -sf `basename $(mk_cpp_link_output)` release/`basename $(mk_cpp_link_output) .$(mk_lib_minor)`
	ln -sf `basename $(mk_cpp_link_output)` release/`basename $(mk_cpp_link_output) .$(mk_lib_mayor).$(mk_lib_minor)`

echo_%:
	@echo "$* = $($*)"

$(mk_build_dir)/exception.o: exception.cpp
	$(mk_cpp_compiler) $(mk_cpp_pp) $(mk_cpp_I_dirs) $(mk_cpp_options) $(mk_cpp_compile) $< $(mk_cpp_out) $@

$(mk_cpp_link_output): $(mk_build_dir)/exception.o
	$(mk_cpp_linker) $(mk_cpp_link_options) $(mk_cpp_linker_out) $@ $<

