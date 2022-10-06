//--------------------------------------------------
// File Name    : envir_ready_cfg.sv
// Module Name  : envir_ready_cfg
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_READY_CFG_SV
`define ENVIR_READY_CFG_SV

class envir_ready_cfg extends uvm_object;

     rand envir_config::rdy_mode rdy_mode;
     rand envir_config::rst_mode rst_mode;

    `uvm_object_utils_begin(envir_ready_cfg)
        `uvm_field_enum(envir_config::rdy_mode, rdy_mode, UVM_ALL_ON)
        `uvm_field_enum(envir_config::rst_mode, rst_mode, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "envir_ready_cfg");
    extern constraint mode;

endclass

function envir_ready_cfg::new(string name = "envir_ready_cfg");
    super.new(name);
    `debug_phase("new")
endfunction

constraint envir_ready_cfg::mode {
    soft rdy_mode inside {envir_config::RDY0, envir_config::RDY1, envir_config::RDYR};
    soft rst_mode inside {envir_config::IMMEDIATE, envir_config::PROTECTED};
}

`endif // ENVIR_READY_CFG_SV
