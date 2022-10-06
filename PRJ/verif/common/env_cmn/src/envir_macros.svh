//--------------------------------------------------
// File Name    : envir_macros.sv
// Module Name  : envir_macros
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_MACROS_SV
`define ENVIR_MACROS_SV


`define TIME_OUT 1000ns


`define debug_phase(N) \
    `ifdef DEBUG_ON \
        `uvm_info(get_name(), $sformatf("%s %s finished ~", get_full_name(), N), UVM_LOW) \
    `endif


`endif // ENVIR_MACROS_SV
