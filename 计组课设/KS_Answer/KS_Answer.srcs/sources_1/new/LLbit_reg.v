`timescale 1ns / 1ps
`include "defines.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/01/08 22:11:44
// Design Name: 
// Module Name: LLbit_reg
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


module LLbit_reg(
    input wire clk,rst,flush,LLbit_i,we,
    //?????1
    output reg LLbit_o
    
);


    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
                    LLbit_o <= 1'b0;
        end else if((flush == 1'b1)) begin
                    LLbit_o <= 1'b0;
        end else if((we == `WriteEnable)) begin
                    LLbit_o <= LLbit_i;
        end
    end
endmodule
