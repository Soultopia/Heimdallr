//--------------------------------------------------
// File Name    : pfme_cfg_in_pfme_sec2.sv
// Module Name  : pfme_cfg_in_pfme_sec2
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-01  Tuesday  PM 08:16:10
// Revision     : rev1.0
//--------------------------------------------------

`ifndef PFME_CFG_IN_PFME_SEC2_SV
`define PFME_CFG_IN_PFME_SEC2_SV

class pfme_cfg_in_pfme_sec2 extends pfme_cfg_in;

    `uvm_object_utils_begin(pfme_cfg_in_pfme_sec2)
    `uvm_object_utils_end

    function new(string name = "pfme_cfg_in_pfme_sec2");
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    constraint limit_pfme_cfg_in_pfme_sec2{

        a==3;


    }

endclass

`endif //PFME_CFG_IN_PFME_SEC2_SV
