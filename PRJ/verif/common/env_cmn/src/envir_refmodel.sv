//--------------------------------------------------
// File Name    : envir_refmodel.sv
// Module Name  : envir_refmodel
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-07-10  Sunday  AM 10:14:42
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_REFMODEL_SV
`define ENVIR_REFMODEL_SV

class envir_refmodel extends uvm_component;

    `uvm_component_utils(envir_refmodel)

    uvm_tlm_analysis_fifo#(uvm_sequence_item) fifo_0;
    uvm_tlm_analysis_fifo#(uvm_sequence_item) fifo_1;

    extern         function      new(string name = "envir_refmodel", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);

endclass

function envir_refmodel::new(string name = "envir_refmodel", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_refmodel::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.fifo_0 = new("fifo_0", this);
    this.fifo_1 = new("fifo_1", this);
    `debug_phase("build_phase")
endfunction

`endif // ENVIR_REFMODEL_SV
