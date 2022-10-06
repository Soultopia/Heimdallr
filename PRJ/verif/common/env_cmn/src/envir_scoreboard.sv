//--------------------------------------------------
// File Name    : envir_scoreboard.sv
// Module Name  : envir_scoreboard
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_SCOREBOARD_SV
`define ENVIR_SCOREBOARD_SV

class envir_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(envir_scoreboard)

    uvm_tlm_analysis_fifo#(uvm_sequence_item) fifo_0;
    uvm_tlm_analysis_fifo#(uvm_sequence_item) fifo_1;

    extern         function      new(string name = "envir_scoreboard", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);

endclass

function envir_scoreboard::new(string name = "envir_scoreboard", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    this.fifo_0 = new("fifo_0", this);
    this.fifo_1 = new("fifo_1", this);
    `debug_phase("build_phase")
endfunction

`endif // ENVIR_SCOREBOARD_SV
