#////////////////////////////////////////////////////////////////////////////////
#  project：Keystroke stabilization experiment                                 //
#                                                                              //
#  Author: JunFN                                                               //
#          853808728@qq.com                                                    //
#          ALINX(shanghai) Technology Co.,Ltd                                  //
#          黑金                                                                //
#     WEB: http://www.alinx.cn/                                                //
#                                                                              //
#////////////////////////////////////////////////////////////////////////////////
#                                                                              //
# Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
#                    All rights reserved                                       //
#                                                                              //
# This source file may be used and distributed without restriction provided    //
# that this copyright statement is not removed from the file and that any      //
# derivative work contains the original copyright notice and the associated    //
# disclaimer.                                                                  //
#                                                                              // 
#////////////////////////////////////////////////////////////////////////////////

#================================================================================
#  Revision History:
#  Date          By            Revision    Change Description
# --------------------------------------------------------------------------------
#  2023/8/22                   1.0          Original
#=================================================================================

#设置项目名称和工作目录
set projname "vivado_key_debounce"
set Topname "key_debounce"
set tclpath [pwd]
cd ..
set projpath [pwd]
#创建工程
#**********************************************************************************************************
create_project -force $projname $projpath/$projname -part xc7z020clg400-2
# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
file mkdir $projpath/$projname/$projname.srcs/sources_1/ip
file mkdir $projpath/$projname/$projname.srcs/sources_1/new
file mkdir $projpath/$projname/$projname.srcs/sources_1/bd
# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}
file mkdir $projpath/$projname/$projname.srcs/constrs_1/new
# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}
file mkdir $projpath/$projname/$projname.srcs/sim_1/new
#*********************************************************************************************************
#添加源文件
add_files -fileset sources_1  -copy_to $projpath/$projname/$projname.srcs/sources_1/new -force -quiet [glob -nocomplain $tclpath/src/design/*.v]
add_files -fileset sim_1  -copy_to $projpath/$projname/$projname.srcs/sim_1/new -force -quiet [glob -nocomplain $tclpath/src/testbench/*.v]
#添加约束文件
add_files -fileset constrs_1  -copy_to $projpath/$projname/$projname.srcs/constrs_1/new -force -quiet [glob -nocomplain $tclpath/src/constraints/*.xdc]
#**********************************************************************************************************
set_property top_file "/$projpath/$projname/$projname.srcs/sources_1/new/$Topname.v" [current_fileset]
launch_runs synth_1 impl_1 -jobs 5
wait_on_run synth_1
wait_on_run impl_1
synth_design -top $Topname
opt_design
place_design
route_design
write_bitstream -force $projpath/$projname/$projname.runs/impl_1/$projname.bit
add_files -fileset sources_1  -copy_to $projpath -force -quiet [glob -nocomplain $projpath/$projname/$projname.runs/impl_1/*.bit]
