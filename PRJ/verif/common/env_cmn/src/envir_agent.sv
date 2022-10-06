//--------------------------------------------------
// File Name    : envir_agent.sv
// Module Name  : envir_agent
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_AGENT
`define ENVIR_AGENT

class envir_agent#(type BUS) extends uvm_agent;

    virtual BUS bus;

    `uvm_component_utils(envir_agent)

    extern         function      new(string name = "envir_agent", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

endclass

function envir_agent::new(string name = "envir_agent", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_agent::build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual BUS)::get(this, "", "bus", bus))
        `uvm_error(get_name(), "Failed to fetch bus !!!")
    `debug_phase("build_phase")
endfunction

function void envir_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `debug_phase("connect_phase")
endfunction


`endif // ENVIR_AGENT_SV
