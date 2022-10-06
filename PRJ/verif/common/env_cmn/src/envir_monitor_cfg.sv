//--------------------------------------------------
// File Name    : envir_monitor_cfg.sv
// Module Name  : envir_monitor_cfg
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_MONITOR_CFG_SV
`define ENVIR_MONITOR_CFG_SV

class envir_monitor_cfg extends uvm_sequence_item;
    
    rand envir_config::rst_mode rst_mode;

    `uvm_object_utils_begin(envir_monitor_cfg)
        `uvm_field_enum(envir_config::rst_mode, rst_mode, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "envir_monitor_cfg");
    extern constraint mode;

endclass

function envir_monitor_cfg::new(string name = "envir_monitor_cfg");
    super.new(name);
    `debug_phase("new")
endfunction

constraint envir_monitor_cfg::mode {
    soft rst_mode inside {envir_config::IMMEDIATE, envir_config::PROTECTED, envir_config::IGNORE};
}

`endif // ENVIR_MONITOR_CFG_SV
