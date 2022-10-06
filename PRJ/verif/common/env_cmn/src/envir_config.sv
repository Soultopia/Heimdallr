//--------------------------------------------------
// File Name    : envir_config.sv
// Module Name  : envir_config
// Author Info  : soultopia
// Contact Info : yhngzhu@gmail.com
// Create Date  : 2022-03-28  Monday  PM 10:15:04
// Revision     : rev1.0
//--------------------------------------------------


`ifndef ENVIR_CONFIG_SV
`define ENVIR_CONFIG_SV

package envir_config;
    
    typedef enum bit {ON = 1'b1, OFF = 1'b0}         trigger ;
    typedef enum     {DRV0, DRV1, DRVX, DRVR}        drv_mode;
    typedef enum     {IMMEDIATE, PROTECTED, IGNORE}  rst_mode;
    typedef enum     {SCYC, MCYC}                    txn_mode;
    typedef enum     {RDY0, RDY1, RDYX, RDYR}        rdy_mode;
    typedef enum     {ALL, MASTER, SLAVE, ONLY_DRV}  agt_mode;

    parameter  BOOTH_DATA_IN_WD     = 100    ;
    parameter  BOOTH_DATA_IN_VLD_WD = 1      ;
    parameter  BOOTH_DATA_IN_RDY_WD = 1      ;
    parameter  TXN_LEN = 100;

endpackage


`endif // ENVIR_CONFIG_SV
