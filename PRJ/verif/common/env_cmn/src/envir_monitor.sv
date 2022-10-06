//--------------------------------------------------
// File Name    : envir_monitor.sv
// Module Name  : envir_monitor
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_MONITOR_SV
`define ENVIR_MONITOR_SV

class envir_monitor#(type BUS) extends uvm_monitor;

    `uvm_component_utils(envir_monitor)

    virtual BUS bus;

    uvm_analysis_port#(uvm_sequence_item) out_port;

    extern         function      new(string name = "envir_monitor", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task          run_phase(uvm_phase phase);

endclass

function envir_monitor::new(string name = "envir_monitor", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.out_port = new("out_port", this);
    if(!uvm_config_db#(virtual envir_interface)::get(this, "", "bus", bus))
        `uvm_error(get_name(), "Failed to fetch bus !!!")
    `debug_phase("build_phase")
endfunction

task envir_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
    `debug_phase("run_phase")
endtask

`endif // ENVIR_MONITOR_SV
