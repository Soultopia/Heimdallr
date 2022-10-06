//--------------------------------------------------
// File Name    : envir_case.sv
// Module Name  : envir_case
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_CASE_SV
`define ENVIR_CASE_SV

class envir_case extends uvm_test;
    
    `uvm_component_utils(envir_case)

    extern         function      new(string name = "envir_case", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task          main_phase(uvm_phase phase);

endclass

function envir_case::new(string name = "envir_case", uvm_component parent);
    super.new(name, parent);
    `debug_phase("new")
endfunction

function void envir_case::build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_top.set_timeout(`TIME_OUT);
    `debug_phase("build_phase")
endfunction

task envir_case::main_phase(uvm_phase phase);
    super.main_phase(phase);
endtask

`endif // ENVIR_CASE_SV
