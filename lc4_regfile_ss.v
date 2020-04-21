`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

/* 8-register, n-bit register file with
 * four read ports and two write ports
 * to support two pipes.
 * 
 * If both pipes try to write to the
 * same register, pipe B wins.
 * 
 * Inputs should be bypassed to the outputs
 * as needed so the register file returns
 * data that is written immediately
 * rather than only on the next cycle.
 */
module lc4_regfile_ss #(parameter n = 16)
   (input  wire         clk,
    input  wire         gwe,
    input  wire         rst,

    input  wire [  2:0] i_rs_A,      // pipe A: rs selector
    output wire [n-1:0] o_rs_data_A, // pipe A: rs contents
    input  wire [  2:0] i_rt_A,      // pipe A: rt selector
    output wire [n-1:0] o_rt_data_A, // pipe A: rt contents

    input  wire [  2:0] i_rs_B,      // pipe B: rs selector
    output wire [n-1:0] o_rs_data_B, // pipe B: rs contents
    input  wire [  2:0] i_rt_B,      // pipe B: rt selector
    output wire [n-1:0] o_rt_data_B, // pipe B: rt contents

    input  wire [  2:0]  i_rd_A,     // pipe A: rd selector
    input  wire [n-1:0]  i_wdata_A,  // pipe A: data to write
    input  wire          i_rd_we_A,  // pipe A: write enable

    input  wire [  2:0]  i_rd_B,     // pipe B: rd selector
    input  wire [n-1:0]  i_wdata_B,  // pipe B: data to write
    input  wire          i_rd_we_B   // pipe B: write enable
    );

   /*** TODO: Your Code Here ***/
   wire r0_we, r1_we, r2_we, r3_we, r4_we, r5_we, r6_we, r7_we;
   assign r0_we = (i_rd_we_A & i_rd_A == 3'b000) | (i_rd_we_B & i_rd_B == 3'b000);
   assign r1_we = (i_rd_we_A & i_rd_A == 3'b001) | (i_rd_we_B & i_rd_B == 3'b001);
   assign r2_we = (i_rd_we_A & i_rd_A == 3'b010) | (i_rd_we_B & i_rd_B == 3'b010);
   assign r3_we = (i_rd_we_A & i_rd_A == 3'b011) | (i_rd_we_B & i_rd_B == 3'b011);
   assign r4_we = (i_rd_we_A & i_rd_A == 3'b100) | (i_rd_we_B & i_rd_B == 3'b100);
   assign r5_we = (i_rd_we_A & i_rd_A == 3'b101) | (i_rd_we_B & i_rd_B == 3'b101);
   assign r6_we = (i_rd_we_A & i_rd_A == 3'b110) | (i_rd_we_B & i_rd_B == 3'b110);
   assign r7_we = (i_rd_we_A & i_rd_A == 3'b111) | (i_rd_we_B & i_rd_B == 3'b111);
   
   wire [n-1:0] r0_in,r0_out;
   Nbit_reg #(16,0) r0(.in(r0_in), .out(r0_out), .clk(clk), .we(r0_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r1_in,r1_out;
   Nbit_reg #(16,0) r1(.in(r1_in), .out(r1_out), .clk(clk), .we(r1_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r2_in,r2_out;
   Nbit_reg #(16,0) r2(.in(r2_in), .out(r2_out), .clk(clk), .we(r2_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r3_in,r3_out;
   Nbit_reg #(16,0) r3(.in(r3_in), .out(r3_out), .clk(clk), .we(r3_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r4_in,r4_out;
   Nbit_reg #(16,0) r4(.in(r4_in), .out(r4_out), .clk(clk), .we(r4_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r5_in,r5_out;
   Nbit_reg #(16,0) r5(.in(r5_in), .out(r5_out), .clk(clk), .we(r5_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r6_in,r6_out;
   Nbit_reg #(16,0) r6(.in(r6_in), .out(r6_out), .clk(clk), .we(r6_we), .gwe(gwe), .rst(rst));
   
   wire [n-1:0] r7_in,r7_out;
   Nbit_reg #(16,0) r7(.in(r7_in), .out(r7_out), .clk(clk), .we(r7_we), .gwe(gwe), .rst(rst));

   assign o_rs_data_A = ((i_rs_A == i_rd_B) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                        ((i_rs_A == i_rd_A) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                        ((i_rs_A == 3'b000) ) ? r0_out: 
                        ((i_rs_A == 3'b001) ) ? r1_out:
                        ((i_rs_A == 3'b010) ) ? r2_out:
                        ((i_rs_A == 3'b011) ) ? r3_out:
                        ((i_rs_A == 3'b100) ) ? r4_out:
                        ((i_rs_A == 3'b101) ) ? r5_out:
                        ((i_rs_A == 3'b110) ) ? r6_out:
                        ((i_rs_A == 3'b111) ) ? r7_out:16'b0;
   
   assign o_rt_data_A = ((i_rt_A == i_rd_B) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                        ((i_rt_A == i_rd_A) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                        ((i_rt_A == 3'b000) ) ? r0_out: 
                        ((i_rt_A == 3'b001) ) ? r1_out:
                        ((i_rt_A == 3'b010) ) ? r2_out:
                        ((i_rt_A == 3'b011) ) ? r3_out:
                        ((i_rt_A == 3'b100) ) ? r4_out:
                        ((i_rt_A == 3'b101) ) ? r5_out:
                        ((i_rt_A == 3'b110) ) ? r6_out:
                        ((i_rt_A == 3'b111) ) ? r7_out:16'b0;
                        
   assign o_rs_data_B = ((i_rs_B == i_rd_B) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                        ((i_rs_B == i_rd_A) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                        ((i_rs_B == 3'b000) ) ? r0_out: 
                        ((i_rs_B == 3'b001) ) ? r1_out:
                        ((i_rs_B == 3'b010) ) ? r2_out:
                        ((i_rs_B == 3'b011) ) ? r3_out:
                        ((i_rs_B == 3'b100) ) ? r4_out:
                        ((i_rs_B == 3'b101) ) ? r5_out:
                        ((i_rs_B == 3'b110) ) ? r6_out:
                        ((i_rs_B == 3'b111) ) ? r7_out:16'b0;
                           
   assign o_rt_data_B = ((i_rt_B == i_rd_B) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                        ((i_rt_B == i_rd_A) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                        ((i_rt_B == 3'b000) ) ? r0_out: 
                        ((i_rt_B == 3'b001) ) ? r1_out:
                        ((i_rt_B == 3'b010) ) ? r2_out:
                        ((i_rt_B == 3'b011) ) ? r3_out:
                        ((i_rt_B == 3'b100) ) ? r4_out:
                        ((i_rt_B == 3'b101) ) ? r5_out:
                        ((i_rt_B == 3'b110) ) ? r6_out:
                        ((i_rt_B == 3'b111) ) ? r7_out:16'b0;                     
                        
   assign r0_in = ((i_rd_A == 3'b000 & i_rd_B== 3'b000) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b000) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b000) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r0_out;
                  
   assign r1_in = ((i_rd_A == 3'b001 & i_rd_B== 3'b001) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b001) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b001) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r1_out;
                                
   assign r2_in = ((i_rd_A == 3'b010 & i_rd_B== 3'b010) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b010) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b010) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r2_out;
                  
   assign r3_in = ((i_rd_A == 3'b011 & i_rd_B== 3'b011) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b011) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b011) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r3_out;
                  
   assign r4_in = ((i_rd_A == 3'b100 & i_rd_B== 3'b100) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b100) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b100) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r4_out;
                  
   assign r5_in = ((i_rd_A == 3'b101 & i_rd_B== 3'b101) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b101) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b101) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r5_out;
                                                
   assign r6_in = ((i_rd_A == 3'b110 & i_rd_B== 3'b110) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b110) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b110) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r6_out;
                                 
   assign r7_in = ((i_rd_A == 3'b111 & i_rd_B== 3'b111) & (i_rd_we_B == 1'b1)) ? i_wdata_B:
                  ((i_rd_A == 3'b111) & (i_rd_we_A == 1'b1)) ? i_wdata_A:
                  ((i_rd_B == 3'b111) & (i_rd_we_B == 1'b1)) ? i_wdata_B:r7_out;
endmodule
