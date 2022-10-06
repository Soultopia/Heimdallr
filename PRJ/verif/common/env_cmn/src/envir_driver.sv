//--------------------------------------------------
// File Name    : envir_driver.sv
// Module Name  : envir_driver
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_DRIVER_SV
`define ENVIR_DRIVER_SV

class envir_driver#(type BUS) extends uvm_driver#(uvm_sequence_item);

    `uvm_component_utils(envir_driver)

    virtual BUS bus;

    uvm_analysis_port#(uvm_sequence_item)     out_port;
    uvm_tlm_analysis_fifo#(uvm_sequence_item) in_fifo;

    extern         function      new(string name = "envir_driver", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task          main_phase(uvm_phase phase);

endclass

function envir_driver::new(string name = "envir_driver", uvm_component parent);
    super.new(name, parent);
    this.out_port = new("out_port", this);
    this.in_fifo  = new("in_fifo", this);
    `debug_phase("new")
endfunction

function void envir_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual BUS)::get(this, "", "bus", bus))
       `uvm_error(get_name(), "Failed to fetch bus !!!")
    `debug_phase("build_phase")
endfunction

task envir_driver::main_phase(uvm_phase phase);
    super.main_phase(phase);
    `debug_phase("main_phase")
endtask


`endif // ENVIR_DRIVER_SV
