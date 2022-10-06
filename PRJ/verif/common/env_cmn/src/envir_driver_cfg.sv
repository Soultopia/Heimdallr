//--------------------------------------------------
// File Name    : envir_driver_cfg.sv
// Module Name  : envir_driver_cfg
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_DRIVER_CFG_SV
`define ENVIR_DRIVER_CFG_SV

class envir_driver_cfg extends uvm_object;

    rand envir_config::drv_mode drv_mode;
    rand envir_config::rst_mode rst_mode;

    `uvm_object_utils_begin(envir_driver_cfg)
        `uvm_field_enum(envir_config::drv_mode, drv_mode, UVM_ALL_ON)
        `uvm_field_enum(envir_config::rst_mode, rst_mode, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "envir_driver_cfg");
    extern constraint mode;

endclass

function envir_driver_cfg::new(string name = "envir_driver_cfg");
    super.new(name);
    `debug_phase("new")
endfunction

constraint envir_driver_cfg::mode {
    soft drv_mode inside {envir_config::DRV0, envir_config::DRV1, envir_config::DRVX, envir_config::DRVR};
    soft rst_mode inside {envir_config::IMMEDIATE, envir_config::PROTECTED, envir_config::IGNORE};
}

`endif // ENVIR_DRIVER_CFG_SV
