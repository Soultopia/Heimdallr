//--------------------------------------------------
// File Name    : envir_env.sv
// Module Name  : envir_env
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-07-10  Sunday  AM 10:14:42
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_ENV_SV
`define ENVIR_ENV_SV

class envir_env extends uvm_env;

    `uvm_component_utils(envir_env)

    extern         function      new(string name = "envir_env", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass

function envir_env::new(string name = "envir_env", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `debug_phase("build_phase")
endfunction

function void envir_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    uvm_top.print_topology();
    `debug_phase("connect_phase")
endfunction

`endif // ENVIR_ENV_SV
