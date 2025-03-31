`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/08 21:49:08
// Design Name: 
// Module Name: pc_reg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pc_reg(
    input wire clk,rst,
    //??????????????
    input wire[5:0]  stall,
    //?????????¦Å????
    input wire branch_flag_i,
    input wire[`RegBus] branch_target_address_i,
    
    output reg[`InstAddrBus] pc,
    output reg ce
);

    always @ (posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h00000000;
        end else if(stall[0] == `NoStop) begin
              if(branch_flag_i == `Branch) begin
                    pc <= branch_target_address_i;
                end else begin
                  pc <= pc + 4'h4;
              end
        end
    end

    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
        end else begin
            ce <= `ChipEnable;
        end
    end
endmodule
