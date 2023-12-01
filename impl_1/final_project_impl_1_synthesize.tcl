if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2023.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "Z:/es4/Space_Invaders"
# synthesize IPs
# synthesize VMs
# synthesize top design
file delete -force -- final_project_impl_1.vm final_project_impl_1.ldc
run_engine_newmsg synthesis -f "final_project_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o final_project_impl_1_syn.udb final_project_impl_1.vm] "Z:/es4/Space_Invaders/impl_1/final_project_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
