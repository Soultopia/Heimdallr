//--------------------------------------------------
// File Name    : envir_drvtxn.sv
// Module Name  : envir_drvtxn
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_DRVTXN_SV
`define ENVIR_DRVTXN_SV

class envir_drvtxn extends uvm_sequence_item;

    rand envir_config::txn_mode mode;
    rand int cyc_num;

    // randef
    rand bit [ envir_config::BOOTH_DATA_IN_WD     - 1 : 0 ] booth_data_in;
    rand bit [ envir_config::BOOTH_DATA_IN_VLD_WD - 1 : 0 ] booth_data_in_vld;

    `uvm_object_utils_begin(envir_drvtxn)
        // fiedef
        `uvm_field_int(booth_data_in       , UVM_ALL_ON)
        `uvm_field_int(booth_data_in_vld   , UVM_ALL_ON)
    `uvm_object_utils_end

    extern         function      new(string name = "envir_drvtxn");
    extern         function void pre_randomize();;
    extern         function void post_randomize();;
    extern virtual function void compr(envir_drvtxn cyc_q[$]);
    extern virtual function void uncompr(ref envir_drvtxn cyc_q[$]);
    // econdef
    extern constraint booth_data_in_con;
    extern constraint booth_data_in_vld_con;

endclass

function envir_drvtxn::new(string name = "envir_drvtxn");
    super.new(name);
    `debug_phase("new")
endfunction

function void envir_drvtxn::pre_randomize();
    this.mode = envir_config::MCYC;
endfunction

function void envir_drvtxn::post_randomize();
    if(mode == envir_config::MCYC) begin
        this.cyc_num = envir_config::TXN_LEN;
    end
    else begin
        this.cyc_num = 1;
    end
endfunction

function void envir_drvtxn::compr(envir_drvtxn cyc_q[$]);
    if(cyc_q.size() != 0) begin
        foreach(cyc_q[i]) begin
            // comprdef
            this.booth_data_in        = cyc_q[i].booth_data_in;
            this.booth_data_in_vld    = cyc_q[i].booth_data_in_vld;
        end
    end
endfunction

function void envir_drvtxn::uncompr(ref envir_drvtxn cyc_q[$]);
    envir_drvtxn tr;
    for(int idx = 0; idx < this.cyc_num; idx ++) begin
        tr = envir_drvtxn::type_id::create("tr");
        tr.randomize() with {
            // withdef
            tr.booth_data_in == idx;
        };
        cyc_q.push_back(tr);
    end
endfunction

// condef
constraint envir_drvtxn::booth_data_in_con{ soft booth_data_in inside {[0:1000]}; }
constraint envir_drvtxn::booth_data_in_vld_con{ soft booth_data_in_vld == 1; }

`endif // ENVIR_DRVTXN_SV
