//--------------------------------------------------
// File Name    : envir_sequence.sv
// Module Name  : envir_sequence
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_SEQUENCE_SV
`define ENVIR_SEQUENCE_SV


class envir_sequence extends uvm_sequence#(uvm_sequence_item);

    `uvm_object_utils(envir_sequence)

    extern function new(string name = "envir_sequence");
    extern virtual task pre_body();
    extern virtual task body();
    extern virtual task post_body();

endclass

function envir_sequence::new(string name = "envir_sequence");
    super.new(name);
    `debug_phase("new")
endfunction

task envir_sequence::pre_body();
    super.pre_body();
    `debug_phase("pre_body")
endtask

task envir_sequence::body();
    super.body();
    `debug_phase("body")
endtask

task envir_sequence::post_body();
    super.post_body();
    `debug_phase("post_body")
endtask


`endif // ENVIR_SEQUENCE_SV
