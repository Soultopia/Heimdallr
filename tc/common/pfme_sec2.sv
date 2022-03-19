//--------------------------------------------------
// File Name    : pfme_sec2.sv
// Module Name  : pfme_sec2
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-01  Tuesday  PM 08:16:10
// Revision     : rev1.0
//--------------------------------------------------

`ifndef PFME_SEC2_SV
`define PFME_SEC2_SV

class pfme_sec2 extends base_case_name;

    `uvm_component_utils(pfme_sec2)

    function new(string name = "pfme_sec2", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(pfme_cfg_in::get_type(), pfme_cfg_in_pfme_sec2::get_type());


    endfunction

endclass

`endif //PFME_SEC2_SV
