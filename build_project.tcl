# build_project.tcl
# Creates a Vivado project for the 5-stage RV32I pipeline targeting the
# Zybo Z7, adds all sources/constraints, and (optionally) runs the full
# synth -> impl -> bitstream flow.
#
# Usage from the directory containing this script:
#   vivado -mode batch -source build_project.tcl
# or, inside the Vivado Tcl Console:
#   cd <this directory>
#   source build_project.tcl

set proj_name  "rv32i_zybo"
set proj_dir   "./vivado_proj"

# Default part = Zybo Z7-20. If you have the Zybo Z7-10, change this to
# xc7z010clg400-1 before running.
set part_name  "xc7z020clg400-1"

# Set to 1 to run synthesis, implementation, and generate a bitstream
# automatically. Set to 0 to just create the project and stop, e.g. if
# you want to add an ILA or explore the GUI first.
set run_to_bitstream 1

create_project $proj_name $proj_dir -part $part_name -force

add_files -norecurse {
    src/alu.v
    src/decoder.v
    src/regfile.v
    src/imem.v
    src/dmem.v
    src/core_top.v
    src/zybo_top.v
}

# imem_init.hex is read via $readmemh at elaboration time. Adding it as a
# project source (not just leaving it on disk) makes Vivado copy it into
# every synth/impl run directory so the relative path in imem.v resolves
# correctly during out-of-context synthesis too.
add_files -norecurse {src/imem_init.hex}
set_property file_type "Memory Initialization Files" [get_files imem_init.hex]

add_files -fileset constrs_1 -norecurse {constraints/zybo_z7.xdc}

set_property top zybo_top [current_fileset]
update_compile_order -fileset sources_1

if {$run_to_bitstream} {
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1

    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1

    puts "Bitstream: $proj_dir/${proj_name}.runs/impl_1/zybo_top.bit"
}
