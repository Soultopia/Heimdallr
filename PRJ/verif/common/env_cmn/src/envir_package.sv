//--------------------------------------------------
// File Name    : envir_package.sv
// Module Name  : envir_package
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_PACKAGE_SV
`define ENVIR_PACKAGE_SV

`include "uvm_macros.svh"
//`include "envir_macros.svh"

package envir_package;

    import uvm_pkg::*;
    import envir_config::*;
    
    `include "envir_case.sv"
    `include "envir_sequence.sv"
    `include "envir_config.sv"
    `include "envir_env_cfg.sv"
    `include "envir_env.sv"
    `include "envir_refmodel.sv"
    `include "envir_scoreboard.sv"
    `include "envir_agent_cfg.sv"
    `include "envir_agent.sv"
    `include "envir_monitor_cfg.sv"
    `include "envir_monitor.sv"
    `include "envir_driver_cfg.sv"
    `include "envir_driver.sv"
    `include "envir_drvtxn.sv"
    `include "envir_ready_cfg.sv"
    `include "envir_ready.sv"
    `include "envir_rdysrc.sv"
    `include "envir_rdytxn.sv"

endpackage


`endif // ENVIR_PACKAGE_SV
