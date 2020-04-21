`timescale 1ns / 1ps

// Prevent implicit wire declaration
`default_nettype none

module lc4_processor(input wire         clk,             // main clock
                     input wire         rst,             // global reset
                     input wire         gwe,             // global we for single-step clock

                     output wire [15:0] o_cur_pc,        // address to read from instruction memory
                     input wire [15:0]  i_cur_insn_A,    // output of instruction memory (pipe A)
                     input wire [15:0]  i_cur_insn_B,    // output of instruction memory (pipe B)

                     output wire [15:0] o_dmem_addr,     // address to read/write from/to data memory
                     input wire [15:0]  i_cur_dmem_data, // contents of o_dmem_addr
                     output wire        o_dmem_we,       // data memory write enable
                     output wire [15:0] o_dmem_towrite,  // data to write to o_dmem_addr if we is set

                     // testbench signals (always emitted from the WB stage)
                     output wire [ 1:0] test_stall_A,        // is this a stall cycle?  (0: no stall,
                     output wire [ 1:0] test_stall_B,        // 1: pipeline stall, 2: branch stall, 3: load stall)

                     output wire [15:0] test_cur_pc_A,       // program counter
                     output wire [15:0] test_cur_pc_B,
                     output wire [15:0] test_cur_insn_A,     // instruction bits
                     output wire [15:0] test_cur_insn_B,
                     output wire        test_regfile_we_A,   // register file write-enable
                     output wire        test_regfile_we_B,
                     output wire [ 2:0] test_regfile_wsel_A, // which register to write
                     output wire [ 2:0] test_regfile_wsel_B,
                     output wire [15:0] test_regfile_data_A, // data to write to register file
                     output wire [15:0] test_regfile_data_B,
                     output wire        test_nzp_we_A,       // nzp register write enable
                     output wire        test_nzp_we_B,
                     output wire [ 2:0] test_nzp_new_bits_A, // new nzp bits
                     output wire [ 2:0] test_nzp_new_bits_B,
                     output wire        test_dmem_we_A,      // data memory write enable
                     output wire        test_dmem_we_B,
                     output wire [15:0] test_dmem_addr_A,    // address to read/write from/to memory
                     output wire [15:0] test_dmem_addr_B,
                     output wire [15:0] test_dmem_data_A,    // data to read/write from/to memory
                     output wire [15:0] test_dmem_data_B,

                     // zedboard switches/display/leds (ignore if you don't want to control these)
                     input  wire [ 7:0] switch_data,         // read on/off status of zedboard's 8 switches
                     output wire [ 7:0] led_data             // set on/off status of zedboard's 8 leds
                     );

   /***  YOUR CODE HERE ***/
         /* DO NOT MODIFY THIS CODE */

   // pc wires attached to the PC register's ports
   wire [15:0]   pc;      // Current program counter (read out from pc_reg)
   wire [15:0]   next_pc; // Next program counter (you compute this and feed it into next_pc)
   wire pc_enable; // will be disabled if there is a load to use stall in pipeline A

   // Program counter register, starts at 8200h at bootup
   Nbit_reg #(16, 16'h8200) pc_reg (.in(next_pc), .out(pc), .clk(clk), .we(pc_enable), .gwe(gwe), .rst(rst));

   /* END DO NOT MODIFY THIS CODE */


   /*******************************
    * TODO: INSERT YOUR CODE HERE *
    *******************************/

    wire [15:0] cur_insn_for_decoder_A;
    wire [2:0] r1sel_A, r2sel_A, wsel_A;
    wire r1re_A, r2re_A, regfile_we_A, nzp_we_A, select_pc_plus_one_A, is_load_A, is_store_A, is_branch_A, is_control_insn_A;
    wire [15:0] cur_insn_for_decoder_B;
    wire [2:0] r1sel_B, r2sel_B, wsel_B;
    wire r1re_B, r2re_B, regfile_we_B, nzp_we_B, select_pc_plus_one_B, is_load_B, is_store_B, is_branch_B, is_control_insn_B;
    wire [15:0] pc_plus_one_A;
    wire [1:0] stall_A;
    wire [1:0] stall_B;
    wire [15:0] pc_plus_one_B_or_not;
    wire [15:0] pc_plus_one_B;
    wire [15:0] D_ins_reg_in_A, D_ins_reg_out_A;
    wire [2:0] D_r1sel_reg_in_A, D_r1sel_reg_out_A;
    wire D_r1re_reg_in_A, D_r1re_reg_out_A;
    wire [2:0] D_r2sel_reg_in_A, D_r2sel_reg_out_A;
    wire D_r2re_reg_in_A, D_r2re_reg_out_A;
    wire [2:0] D_wsel_reg_in_A, D_wsel_reg_out_A;
    wire D_regfile_we_reg_in_A, D_regfile_we_reg_out_A;
    wire D_nzp_we_reg_in_A, D_nzp_we_reg_out_A;
    wire D_select_pc_plus_one_reg_in_A, D_select_pc_plus_one_reg_out_A;
    wire D_is_load_reg_in_A, D_is_load_reg_out_A;
    wire D_is_store_reg_in_A, D_is_store_reg_out_A;
    wire D_is_branch_reg_in_A, D_is_branch_reg_out_A;
    wire D_is_control_insn_reg_in_A, D_is_control_insn_reg_out_A;
    wire [15:0] D_pc_reg_in_A, D_pc_reg_out_A;
    wire [15:0] D_pc_plus_one_reg_in_A, D_pc_plus_one_reg_out_A;
    wire [1:0] D_is_stall_reg_in_A, D_is_stall_reg_out_A;
    wire [15:0] D_ins_reg_in_B, D_ins_reg_out_B;
    wire [2:0] D_r1sel_reg_in_B, D_r1sel_reg_out_B;
    wire D_r1re_reg_in_B, D_r1re_reg_out_B;
    wire [2:0] D_r2sel_reg_in_B, D_r2sel_reg_out_B;
    wire D_r2re_reg_in_B, D_r2re_reg_out_B;
    wire [2:0] D_wsel_reg_in_B, D_wsel_reg_out_B;
    wire D_regfile_we_reg_in_B, D_regfile_we_reg_out_B;
    wire D_nzp_we_reg_in_B, D_nzp_we_reg_out_B;
    wire D_select_pc_plus_one_reg_in_B, D_select_pc_plus_one_reg_out_B;
    wire D_is_load_reg_in_B, D_is_load_reg_out_B;
    wire D_is_store_reg_in_B, D_is_store_reg_out_B;
    wire D_is_branch_reg_in_B, D_is_branch_reg_out_B;
    wire D_is_control_insn_reg_in_B, D_is_control_insn_reg_out_B;
    wire [15:0] D_pc_reg_in_B, D_pc_reg_out_B;
    wire [15:0] D_pc_plus_one_reg_in_B, D_pc_plus_one_reg_out_B;
    wire [1:0] D_is_stall_reg_in_B, D_is_stall_reg_out_B;
    wire [15:0] o_rs_data_A, o_rt_data_A;
    wire [15:0] o_rs_data_B, o_rt_data_B;
    wire [15:0] x_ins_reg_in_A, x_ins_reg_out_A;
    wire [2:0] x_r1sel_reg_in_A, x_r1sel_reg_out_A;
    wire x_r1re_reg_in_A , x_r1re_reg_out_A;
    wire [2:0] x_r2sel_reg_in_A, x_r2sel_reg_out_A;
    wire x_r2re_reg_in_A, x_r2re_reg_out_A;
    wire [2:0] x_wsel_reg_in_A, x_wsel_reg_out_A;
    wire x_regfile_we_reg_in_A, x_regfile_we_reg_out_A;
    wire x_nzp_we_reg_in_A, x_nzp_we_reg_out_A;
    wire x_select_pc_plus_one_reg_in_A, x_select_pc_plus_one_reg_out_A;
    wire x_is_load_reg_in_A, x_is_load_reg_out_A;
    wire x_is_store_reg_in_A, x_is_store_reg_out_A;
    wire x_is_branch_reg_in_A, x_is_branch_reg_out_A;
    wire x_is_control_insn_reg_in_A, x_is_control_insn_reg_out_A;
    wire [15:0] x_pc_reg_in_A, x_pc_reg_out_A;
    wire [15:0] x_pc_plus_one_reg_in_A, x_pc_plus_one_reg_out_A;
    wire [1:0] x_is_stall_reg_in_A, x_is_stall_reg_out_A;
    wire [15:0] x_r1data_reg_in_A, x_r1data_reg_out_A;
    wire [15:0] x_r2data_reg_in_A, x_r2data_reg_out_A;
    wire [15:0] x_ins_reg_in_B, x_ins_reg_out_B;
    wire [2:0] x_r1sel_reg_in_B, x_r1sel_reg_out_B;
    wire x_r1re_reg_in_B, x_r1re_reg_out_B;
    wire [2:0] x_r2sel_reg_in_B, x_r2sel_reg_out_B;
    wire x_r2re_reg_in_B, x_r2re_reg_out_B;
    wire [2:0] x_wsel_reg_in_B, x_wsel_reg_out_B;
    wire x_regfile_we_reg_in_B, x_regfile_we_reg_out_B;
    wire x_nzp_we_reg_in_B,x_nzp_we_reg_out_B;
    wire x_select_pc_plus_one_reg_in_B, x_select_pc_plus_one_reg_out_B;
    wire x_is_load_reg_in_B, x_is_load_reg_out_B;
    wire x_is_store_reg_in_B, x_is_store_reg_out_B;
    wire x_is_branch_reg_in_B, x_is_branch_reg_out_B;
    wire x_is_control_insn_reg_in_B, x_is_control_insn_reg_out_B;
    wire [15:0] x_pc_reg_in_B, x_pc_reg_out_B;
    wire [15:0] x_pc_plus_one_reg_in_B, x_pc_plus_one_reg_out_B;
    wire [1:0] x_is_stall_reg_in_B, x_is_stall_reg_out_B;
    wire [15:0] x_r1data_reg_in_B, x_r1data_reg_out_B;
    wire [15:0] x_r2data_reg_in_B, x_r2data_reg_out_B;
    wire [15:0] r1data_before_ALU_A, r2data_before_ALU_A;
    wire [15:0] r1data_before_ALU_B, r2data_before_ALU_B;
    wire [15:0] alu_result_A;
    wire [15:0] alu_result_B;
    wire [15:0] alu_or_pc_plus_one_A;
    wire [15:0] alu_or_pc_plus_one_B;
    wire [2:0] x_nzp_reg_in_A, x_nzp_reg_out_A;
    wire [2:0] x_nzp_reg_in_B, x_nzp_reg_out_B;
    wire [2:0] latest_nzp;
    wire [15:0] mem_ins_reg_in_A, mem_ins_reg_out_A;
    wire [2:0] mem_r1sel_reg_in_A, mem_r1sel_reg_out_A;
    wire [2:0] mem_r2sel_reg_in_A, mem_r2sel_reg_out_A;
    wire [2:0] mem_wsel_reg_in_A, mem_wsel_reg_out_A;
    wire mem_regfile_we_reg_in_A, mem_regfile_we_reg_out_A;
    wire mem_nzp_we_reg_in_A, mem_nzp_we_reg_out_A;
    wire mem_select_pc_plus_one_reg_in_A, mem_select_pc_plus_one_reg_out_A;
    wire mem_is_load_reg_in_A, mem_is_load_reg_out_A;
    wire mem_is_store_reg_in_A, mem_is_store_reg_out_A;
    wire mem_is_branch_reg_in_A, mem_is_branch_reg_out_A;
    wire mem_is_control_insn_reg_in_A, mem_is_control_insn_reg_out_A;
    wire [1:0] mem_is_stall_reg_in_A, mem_is_stall_reg_out_A;
    wire [15:0] mem_alu_result_reg_in_A, mem_alu_result_reg_out_A;
    wire [15:0] mem_r2data_reg_in_A, mem_r2data_reg_out_A;
    wire [15:0] mem_pc_reg_in_A, mem_pc_reg_out_A;
    wire [15:0] mem_ins_reg_in_B, mem_ins_reg_out_B;
    wire [2:0] mem_r1sel_reg_in_B, mem_r1sel_reg_out_B;
    wire [2:0] mem_r2sel_reg_in_B, mem_r2sel_reg_out_B;
    wire [2:0] mem_wsel_reg_in_B, mem_wsel_reg_out_B;
    wire mem_regfile_we_reg_in_B, mem_regfile_we_reg_out_B;
    wire mem_nzp_we_reg_in_B, mem_nzp_we_reg_out_B;
    wire mem_select_pc_plus_one_reg_in_B, mem_select_pc_plus_one_reg_out_B;
    wire mem_is_load_reg_in_B, mem_is_load_reg_out_B;
    wire mem_is_store_reg_in_B, mem_is_store_reg_out_B;
    wire mem_is_branch_reg_in_B, mem_is_branch_reg_out_B;
    wire mem_is_control_insn_reg_in_B, mem_is_control_insn_reg_out_B;
    wire [1:0] mem_is_stall_reg_in_B, mem_is_stall_reg_out_B;
    wire [15:0] mem_alu_result_reg_in_B, mem_alu_result_reg_out_B;
    wire [15:0] mem_r2data_reg_in_B, mem_r2data_reg_out_B;
    wire [15:0] mem_pc_reg_in_B, mem_pc_reg_out_B;
    wire [2:0] mem_nzp_reg_in_A, mem_nzp_reg_out_A;
    wire [2:0] mem_nzp_reg_in_B, mem_nzp_reg_out_B;
    wire [15:0] w_ins_reg_in_A, w_ins_reg_out_A;
    wire [2:0] w_r1sel_reg_in_A, w_r1sel_reg_out_A;
    wire [2:0] w_r2sel_reg_in_A, w_r2sel_reg_out_A;
    wire [2:0] w_wsel_reg_in_A, w_wsel_reg_out_A;
    wire w_regfile_we_reg_in_A, w_regfile_we_reg_out_A;
    wire w_nzp_we_reg_in_A, w_nzp_we_reg_out_A;
    wire w_select_pc_plus_one_reg_in_A, w_select_pc_plus_one_reg_out_A;
    wire w_is_load_reg_in_A, w_is_load_reg_out_A;
    wire w_is_store_reg_in_A, w_is_store_reg_out_A;
    wire w_is_branch_reg_in_A, w_is_branch_reg_out_A;
    wire w_is_control_insn_reg_in_A, w_is_control_insn_reg_out_A;
    wire [1:0] w_is_stall_reg_in_A, w_is_stall_reg_out_A;
//  wire [2:0] w_nzp_reg_in_A, w_nzp_reg_out_A;
    wire [15:0] w_alu_result_reg_in_A, w_alu_result_reg_out_A;
    wire [15:0] w_pc_reg_in_A, w_pc_reg_out_A;
    wire [15:0] w_o_dmem_addr_reg_in_A, w_o_dmem_addr_reg_out_A;
    wire [15:0] w_o_dmem_towrite_reg_in_A, w_o_dmem_towrite_reg_out_A;
    wire [15:0] w_mem_output_reg_in_A, w_mem_output_reg_out_A;
    wire [15:0] w_ins_reg_in_B, w_ins_reg_out_B;
    wire [2:0] w_r1sel_reg_in_B, w_r1sel_reg_out_B;
    wire [2:0] w_r2sel_reg_in_B, w_r2sel_reg_out_B;
    wire [2:0] w_wsel_reg_in_B, w_wsel_reg_out_B;
    wire w_regfile_we_reg_in_B, w_regfile_we_reg_out_B;
    wire w_nzp_we_reg_in_B, w_nzp_we_reg_out_B;
    wire w_select_pc_plus_one_reg_in_B, w_select_pc_plus_one_reg_out_B;
    wire w_is_load_reg_in_B, w_is_load_reg_out_B;
    wire w_is_store_reg_in_B, w_is_store_reg_out_B;
    wire w_is_branch_reg_in_B, w_is_branch_reg_out_B;
    wire w_is_control_insn_reg_in_B, w_is_control_insn_reg_out_B;
    wire [1:0] w_is_stall_reg_in_B, w_is_stall_reg_out_B;
//    wire [2:0] w_nzp_reg_in_B, w_nzp_reg_out_B;
    wire [15:0]w_alu_result_reg_in_B, w_alu_result_reg_out_B;
    wire [15:0] w_pc_reg_in_B, w_pc_reg_out_B;
    wire [15:0] w_o_dmem_addr_reg_in_B, w_o_dmem_addr_reg_out_B;
    wire [15:0] w_o_dmem_towrite_reg_in_B, w_o_dmem_towrite_reg_out_B;
    wire [15:0] w_mem_output_reg_in_B, w_mem_output_reg_out_B;
    wire [15:0] alu_or_pc_plus_one_or_load_A;
    wire [15:0] alu_or_pc_plus_one_or_load_B;
    wire [2:0] w_nzp_reg_A;
    wire [2:0] w_nzp_reg_B;
    wire branch_result_A, branch_taken_A;
    wire branch_result_B, branch_taken_B;
    integer     num_cycles = 2;

    //check if there is a data dependency between two instructions and swap insn for pipeline A
    assign cur_insn_for_decoder_A = i_cur_insn_A;
    //check if there is a data dependency between two instructions and swap insn for pipeline B
    assign cur_insn_for_decoder_B = i_cur_insn_B;

    //decoder for the pipeline A datapath
    lc4_decoder decoder_A(.insn(cur_insn_for_decoder_A),                         // instruction
                          .r1sel(r1sel_A),                             // rs
                          .r1re(r1re_A),                               // does this instruction read from rs?
                          .r2sel(r2sel_A),                             // rt
                          .r2re(r2re_A),                               // does this instruction read from rt?
                          .wsel(wsel_A),                               // rd
                          .regfile_we(regfile_we_A),                   // does this instruction write to rd?
                          .nzp_we(nzp_we_A),                           // does this instruction write the NZP bits?
                          .select_pc_plus_one(select_pc_plus_one_A),   // write PC+1 to the regfile?
                          .is_load(is_load_A),                         // is this a load instruction?
                          .is_store(is_store_A),                       // is this a store instruction?
                          .is_branch(is_branch_A),                     // is this a branch instruction?
                          .is_control_insn(is_control_insn_A)          // is this a control instruction (JSR, JSRR, RTI, JMPR, JMP, TRAP)?
                          );


    //decoder for the pipeline B datapath
    lc4_decoder decoder_B(.insn(cur_insn_for_decoder_B),                         // instruction
                          .r1sel(r1sel_B),                             // rs
                          .r1re(r1re_B),                               // does this instruction read from rs?
                          .r2sel(r2sel_B),                             // rt
                          .r2re(r2re_B),                               // does this instruction read from rt?
                          .wsel(wsel_B),                               // rd
                          .regfile_we(regfile_we_B),                   // does this instruction write to rd?
                          .nzp_we(nzp_we_B),                           // does this instruction write the NZP bits?
                          .select_pc_plus_one(select_pc_plus_one_B),   // write PC+1 to the regfile?
                          .is_load(is_load_B),                         // is this a load instruction?
                          .is_store(is_store_B),                       // is this a store instruction?
                          .is_branch(is_branch_B),                     // is this a branch instruction?
                          .is_control_insn(is_control_insn_B)          // is this a control instruction (JSR, JSRR, RTI, JMPR, JMP, TRAP)?
                          );

    //pc+1 for pipeline A datapath
    cla16 cla16_pc_A (.a(pc),
                      .b(16'b1),
                      .cin(1'b0),
                      .sum(pc_plus_one_A));

    //determine if there is a superscalar stall in pipeline A
    assign stall_A =  (x_is_load_reg_in_A & is_branch_A & x_nzp_we_reg_in_B) ? 2'b00:
                      (x_is_load_reg_in_A & is_branch_A) ? 2'b11:
                      (x_is_load_reg_in_B & is_branch_A) ? 2'b11:
                      (x_is_load_reg_in_A & is_store_A & (x_wsel_reg_in_A == r1sel_A)) ? 2'b11 :
                      (x_is_load_reg_in_B & is_store_A & (x_wsel_reg_in_B == r1sel_A)) ? 2'b11 :
                      (x_is_load_reg_in_A & is_store_A & (x_wsel_reg_in_A == r2sel_A)) ? 2'b00 :
                      (x_is_load_reg_in_B & is_store_A & (x_wsel_reg_in_B == r2sel_A)) ? 2'b00 :
                      (x_is_load_reg_in_A & ((x_wsel_reg_in_A == r1sel_A & r1re_A) | (x_wsel_reg_in_A == r2sel_A & r2re_A))) ? 2'b11 :
                      (x_is_load_reg_in_B & ((x_wsel_reg_in_B == r1sel_A & r1re_A) | (x_wsel_reg_in_B == r2sel_A & r2re_A))) ? 2'b11 :2'b00;


    wire test15=(x_is_load_reg_in_A & is_store_A & x_wsel_reg_in_A == r2sel_A & x_wsel_reg_in_A != r1sel_A);
    wire test16=(((r1sel_A == x_wsel_reg_in_A & r1re_A) | (r2sel_A == x_wsel_reg_in_A & r2re_A)) & x_is_load_reg_in_A |
                ((r1sel_A == x_wsel_reg_in_B & r1re_A) | (r2sel_A == x_wsel_reg_in_B & r2re_A)) & x_is_load_reg_in_B);
    wire test17=((!is_load_A) & is_store_B & wsel_A != r1sel_B);
    //disable pc register if there is a load to use stall in pipeline A
    assign pc_enable = (stall_A == 2'b11) ? 1'b0 : 1'b1;

    //determine if there is a superscalar stall in pipeline B
    assign stall_B =  
                      ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B & x_is_load_reg_in_A & (x_wsel_reg_in_A==r1sel_B)) ? 2'b11:
                      ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B & x_is_load_reg_in_B & (x_wsel_reg_in_B==r1sel_B)) ? 2'b11:
                      ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B ) ? 2'b00 :
                      (wsel_A == r1sel_B & r1re_B == 1'b1 & D_regfile_we_reg_in_A)? 2'b01:
                      (wsel_A == r2sel_B & r2re_B== 1'b1 & D_regfile_we_reg_in_A)? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b0010)&(is_branch_B))? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b0001)&(is_branch_B))? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b1001)&(is_branch_B))? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b0101)&(is_branch_B))? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b1010)&(is_branch_B))? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b1101)&(is_branch_B)) ? 2'b01:
                      ((D_ins_reg_in_A[15:12] == 4'b0110)&(is_branch_B)) ? 2'b01:
                      (x_is_load_reg_in_A & is_branch_B & x_nzp_we_reg_in_B) ? 2'b00:
                      (x_is_load_reg_in_A & is_branch_B) ? 2'b11:
                      (x_is_load_reg_in_B & is_branch_B) ? 2'b11:
                      ((is_load_A & is_load_B)|(is_store_A & is_store_B)|(is_load_A & is_store_B)|(is_store_A & is_load_B)) ? 2'b01 :
                      (((r1sel_B == x_wsel_reg_in_A & r1re_B) | (r2sel_B == x_wsel_reg_in_A & r2re_B)) & x_is_load_reg_in_A) ? 2'b11:
                      (((r1sel_B == x_wsel_reg_in_B & r1re_B) | (r2sel_B == x_wsel_reg_in_B & r2re_B)) & x_is_load_reg_in_B) ? 2'b11:2'b00;

wire test1 = ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B & x_is_load_reg_in_A & (x_wsel_reg_in_A==r1sel_B));
wire test2 = ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B & x_is_load_reg_in_B & (x_wsel_reg_in_B==r1sel_B));
wire test3 = ((!is_load_A & !is_store_A) & is_store_B & wsel_A != r1sel_B );
wire test14 = (wsel_A == r1sel_B & r1re_B == 1'b1 & D_regfile_we_reg_in_A);
wire test4 = (wsel_A == r2sel_B & r2re_B== 1'b1 & D_regfile_we_reg_in_A);
wire test5 = ((D_ins_reg_in_A[15:12] == 4'b0010)&(is_branch_B));
wire test6 = ((D_ins_reg_in_A[15:12] == 4'b0001)&(is_branch_B));
wire test7 = ((D_ins_reg_in_A[15:12] == 4'b1001)&(is_branch_B));
wire test8 = ((D_ins_reg_in_A[15:12] == 4'b0101)&(is_branch_B));
wire test9 = ((D_ins_reg_in_A[15:12] == 4'b1010)&(is_branch_B));
wire test10 = ((D_ins_reg_in_A[15:12] == 4'b1101)&(is_branch_B));
wire test11 = ((is_load_A & is_load_B)|(is_store_A & is_store_B)|(is_load_A & is_store_B)|(is_store_A & is_load_B)) ;
wire test12 = (((r1sel_B == x_wsel_reg_in_A & r1re_B) | (r2sel_B == x_wsel_reg_in_A & r2re_B)) & x_is_load_reg_in_A);
wire test13 = (((r1sel_B == x_wsel_reg_in_B & r1re_B) | (r2sel_B == x_wsel_reg_in_B & r2re_B)) & x_is_load_reg_in_B);

    //deal with superscalar stall in pipeline B
    assign pc_plus_one_B_or_not = ( stall_B == 2'b01) ? 16'b0 :
                                  ( stall_B == 2'b11) ? 16'b0 : 16'b1;

    //pc+1 for pipeline B datapath
    cla16 cla16_pc_B (.a(pc_plus_one_A),
                      .b(pc_plus_one_B_or_not),
                      .cin(1'b0),
                      .sum(pc_plus_one_B));

    //connection between decoder outputs and d stage inputs for pipeline A
    assign D_ins_reg_in_A =  (branch_taken_A | branch_taken_B) ? 16'b0: cur_insn_for_decoder_A;
    assign D_r1sel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: r1sel_A;
    assign D_r1re_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: r1re_A;
    assign D_r2sel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: r2sel_A;
    assign D_r2re_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: r2re_A;
    assign D_wsel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: wsel_A;
    assign D_regfile_we_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (branch_taken_A | branch_taken_B) ? 1'b0 :
                                   (stall_A == 2'b11)? 1'b0 : regfile_we_A;
    assign D_nzp_we_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (branch_taken_A | branch_taken_B) ? 1'b0 :
                               (stall_A == 2'b11)? 1'b0 : nzp_we_A;
    assign D_select_pc_plus_one_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: select_pc_plus_one_A;
    assign D_is_load_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (stall_A == 2'b11)? 1'b0 : is_load_A;
    assign D_is_store_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (branch_taken_A | branch_taken_B) ? 1'b0 :
                                 (stall_A == 2'b11)? 1'b0 : is_store_A;
    assign D_is_branch_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: is_branch_A;
    assign D_is_control_insn_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: is_control_insn_A;
    assign D_pc_reg_in_A = pc;
    assign D_pc_plus_one_reg_in_A = pc_plus_one_A;
    assign D_is_stall_reg_in_A =  (branch_taken_A | branch_taken_B) ? 2'b10: (branch_taken_A | branch_taken_B) ? 2'b10 : stall_A;

    //connection between decoder outputs and d stage inputs for pipeline B
    assign D_ins_reg_in_B =  (stall_B) ? 16'b0:(branch_taken_A | branch_taken_B) ? 16'b0: (stall_B == 2'b01)? 16'b0 : cur_insn_for_decoder_B;

    assign D_r1sel_reg_in_B =  (stall_B) ? 3'b0:(branch_taken_A | branch_taken_B) ? 3'b0: (stall_B == 2'b01)? 3'b0 : r1sel_B;

    assign D_r1re_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 : r1re_B;

    assign D_r2sel_reg_in_B =  (stall_B) ? 3'b0:(branch_taken_A | branch_taken_B) ? 3'b0: (stall_B == 2'b01)? 3'b0 : r2sel_B;

    assign D_r2re_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 : r2re_B;

    assign D_wsel_reg_in_B =  (stall_B) ? 3'b0:(branch_taken_A | branch_taken_B) ? 3'b0: (stall_B == 2'b01)? 3'b0 : wsel_B;

    assign D_regfile_we_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 :
                                   (branch_taken_A | branch_taken_B) ? 1'b0 :
                                   (stall_A == 2'b11)? 1'b0 :
                                   (stall_B == 2'b11)? 1'b0 :regfile_we_B;

    assign D_nzp_we_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 :
                               (branch_taken_A | branch_taken_B) ? 1'b0 :
                               (stall_A == 2'b11)? 1'b0 :
                               (stall_B == 2'b11)? 1'b0 :nzp_we_B;

    assign D_select_pc_plus_one_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 : select_pc_plus_one_B;

    assign D_is_load_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 :
                                (stall_A == 2'b11)? 1'b0 :
                                (stall_B == 2'b11)? 1'b0 :is_load_B;

    assign D_is_store_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 :
                                  (branch_taken_A | branch_taken_B) ? 1'b0 :
                                  (stall_A == 2'b11)? 1'b0 :
                                  (stall_B == 2'b11)? 1'b0 :is_store_B;

    assign D_is_branch_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 : is_branch_B;

    assign D_is_control_insn_reg_in_B =  (stall_B) ? 1'b0:(branch_taken_A | branch_taken_B) ? 1'b0: (stall_B == 2'b01)? 1'b0 : is_control_insn_B;

    assign D_pc_reg_in_B = pc_plus_one_A;

    assign D_pc_plus_one_reg_in_B = pc_plus_one_B;

    assign D_is_stall_reg_in_B =  (branch_taken_A | branch_taken_B) ? 2'b10: (branch_taken_A | branch_taken_B) ? 2'b10 : stall_B;

    //connection between d stage inputs and d stage outputs after decoder_A
    Nbit_reg #(16, 0) D_ins_reg_A (.in(D_ins_reg_in_A), .out(D_ins_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_r1sel_reg_A (.in(D_r1sel_reg_in_A), .out(D_r1sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_r1re_reg_A (.in(D_r1re_reg_in_A), .out(D_r1re_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_r2sel_reg_A (.in(D_r2sel_reg_in_A), .out(D_r2sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_r2re_reg_A (.in(D_r2re_reg_in_A), .out(D_r2re_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_wsel_reg_A (.in(D_wsel_reg_in_A), .out(D_wsel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_regfile_we_reg_A (.in(D_regfile_we_reg_in_A), .out(D_regfile_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_nzp_we_reg_A (.in(D_nzp_we_reg_in_A), .out(D_nzp_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_select_pc_plus_one_reg_A (.in(D_select_pc_plus_one_reg_in_A), .out(D_select_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_load_reg_A (.in(D_is_load_reg_in_A), .out(D_is_load_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_store_reg_A (.in(D_is_store_reg_in_A), .out(D_is_store_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_branch_reg_A (.in(D_is_branch_reg_in_A), .out(D_is_branch_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_control_insn_reg_A (.in(D_is_control_insn_reg_in_A), .out(D_is_control_insn_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) D_pc_reg_A (.in(D_pc_reg_in_A), .out(D_pc_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) D_pc_plus_one_reg_A (.in(D_pc_plus_one_reg_in_A), .out(D_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) D_is_stall_reg_A (.in(D_is_stall_reg_in_A), .out(D_is_stall_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //connection between d stage inputs and d stage outputs after decoder_B
    Nbit_reg #(16, 0) D_ins_reg_B (.in(D_ins_reg_in_B), .out(D_ins_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_r1sel_reg_B (.in(D_r1sel_reg_in_B), .out(D_r1sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_r1re_reg_B (.in(D_r1re_reg_in_B), .out(D_r1re_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_r2sel_reg_B (.in(D_r2sel_reg_in_B), .out(D_r2sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_r2re_reg_B (.in(D_r2re_reg_in_B), .out(D_r2re_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) D_wsel_reg_B (.in(D_wsel_reg_in_B), .out(D_wsel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_regfile_we_reg_B (.in(D_regfile_we_reg_in_B), .out(D_regfile_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_nzp_we_reg_B (.in(D_nzp_we_reg_in_B), .out(D_nzp_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_select_pc_plus_one_reg_B (.in(D_select_pc_plus_one_reg_out_B), .out(D_select_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_load_reg_B (.in(D_is_load_reg_in_B), .out(D_is_load_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_store_reg_B (.in(D_is_store_reg_in_B), .out(D_is_store_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_branch_reg_B (.in(D_is_branch_reg_in_B), .out(D_is_branch_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) D_is_control_insn_reg_B (.in(D_is_control_insn_reg_in_B), .out(D_is_control_insn_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) D_pc_reg_B (.in(D_pc_reg_in_B), .out(D_pc_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) D_pc_plus_one_reg_B (.in(D_pc_plus_one_reg_in_B), .out(D_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) D_is_stall_reg_B (.in(D_is_stall_reg_in_B), .out(D_is_stall_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //register file for the pipeline datapath for both cores (A & B)

    lc4_regfile_ss #(16) regfile_0 (.clk(clk),
                                    .gwe(gwe),
                                    .rst(rst),
                                    .i_rs_A(D_r1sel_reg_out_A),                 // pipe A: rs selector
                                    .o_rs_data_A(o_rs_data_A),             // pipe A: rs contents
                                    .i_rt_A(D_r2sel_reg_out_A),                 // pipe A: rt selector
                                    .o_rt_data_A(o_rt_data_A),             // pipe A: rt contents
                                    .i_rs_B(D_r1sel_reg_out_B),                 // pipe B: rs selector
                                    .o_rs_data_B(o_rs_data_B),             // pipe B: rs contents
                                    .i_rt_B(D_r2sel_reg_out_B),                 // pipe B: rt selector
                                    .o_rt_data_B(o_rt_data_B),             // pipe B: rt contents
                                    .i_rd_A(w_wsel_reg_out_A),                  // pipe A: rd selector
                                    .i_wdata_A(alu_or_pc_plus_one_or_load_A),   // pipe A: data to write
                                    .i_rd_we_A(w_regfile_we_reg_out_A),         // pipe A: write enable
                                    .i_rd_B(w_wsel_reg_out_B),                  // pipe B: rd selector
                                    .i_wdata_B(alu_or_pc_plus_one_or_load_B),   // pipe B: data to write
                                    .i_rd_we_B(w_regfile_we_reg_out_B)          // pipe B: write enable
                                    );

    //wire connection between register file outputs and x stage inputs (pipeline A)
    assign x_ins_reg_in_A =  (branch_taken_A | branch_taken_B) ? 16'b0: (D_is_stall_reg_out_A == 2'b11) ? 16'b0 :D_ins_reg_out_A;
    assign x_r1sel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_r1sel_reg_out_A;
    assign x_r1re_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_r1re_reg_out_A;
    assign x_r2sel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_r2sel_reg_out_A;
    assign x_r2re_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_r2re_reg_out_A;
    assign x_wsel_reg_in_A =  (branch_taken_A | branch_taken_B) ? 3'b0: (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_wsel_reg_out_A;
    assign x_regfile_we_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :
                                   (branch_taken_A | branch_taken_B | branch_taken_B) ? 1'b0 : D_regfile_we_reg_out_A;
    assign x_nzp_we_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :
                               (branch_taken_A | branch_taken_B) ? 1'b0 : D_nzp_we_reg_out_A;
    assign x_select_pc_plus_one_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_select_pc_plus_one_reg_out_A;
    assign x_is_load_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :(branch_taken_A | branch_taken_B) ? 1'b0 : D_is_load_reg_out_A;
    assign x_is_store_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :(branch_taken_A | branch_taken_B) ? 1'b0 : D_is_store_reg_out_A;
    assign x_is_branch_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_is_branch_reg_out_A;
    assign x_is_control_insn_reg_in_A =  (branch_taken_A | branch_taken_B) ? 1'b0: (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_is_control_insn_reg_out_A;
    assign x_pc_reg_in_A = D_pc_reg_out_A;
    assign x_pc_plus_one_reg_in_A = D_pc_plus_one_reg_out_A;
    assign x_is_stall_reg_in_A =  (branch_taken_A | branch_taken_B) ? 2'b10: (D_is_stall_reg_out_A == 2'b11) ? 2'b11 :(branch_taken_A | branch_taken_B) ? 2'b10 :D_is_stall_reg_out_A;
    assign x_r1data_reg_in_A = o_rs_data_A; // new elements
    assign x_r2data_reg_in_A = o_rt_data_A; // new elements

    //wire connection between register file outputs and execution stage inputs (pipeline B)
    assign x_ins_reg_in_B =  (branch_taken_A | branch_taken_B) ? 16'b0: 
                             (D_is_stall_reg_out_A == 2'b11) ? 16'b0 :D_ins_reg_out_B;
    assign x_r1sel_reg_in_B = (branch_taken_A | branch_taken_B) ? 3'b0:  
                             (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_r1sel_reg_out_B;
    assign x_r1re_reg_in_B = (branch_taken_A | branch_taken_B) ? 1'b0:  
                            (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_r1re_reg_out_B;
    assign x_r2sel_reg_in_B =  (branch_taken_A | branch_taken_B) ? 3'b0: 
                             (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_r2sel_reg_out_B;
    assign x_r2re_reg_in_B = (branch_taken_A | branch_taken_B) ? 1'b0:  
                            (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_r2re_reg_out_B;
    assign x_wsel_reg_in_B = (branch_taken_A | branch_taken_B) ? 3'b0:  
                            (D_is_stall_reg_out_A == 2'b11) ? 3'b0 :D_wsel_reg_out_B;
    assign x_regfile_we_reg_in_B =  (branch_taken_A | branch_taken_B) ? 1'b0: 
                                   (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :
                                   (branch_taken_A | branch_taken_B) ? 1'b0 : D_regfile_we_reg_out_B;
    assign x_nzp_we_reg_in_B =  (branch_taken_A | branch_taken_B) ? 1'b0: 
                               (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :
                              (branch_taken_A | branch_taken_B) ? 1'b0 : D_nzp_we_reg_out_B;
    assign x_select_pc_plus_one_reg_in_B =   (branch_taken_A | branch_taken_B) ? 1'b0: 
                                            (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_select_pc_plus_one_reg_out_B;
    assign x_is_load_reg_in_B =  (branch_taken_A | branch_taken_B) ? 1'b0: 
                                (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :(branch_taken_A | branch_taken_B) ? 1'b0 : D_is_load_reg_out_B;
    assign x_is_store_reg_in_B = (branch_taken_A | branch_taken_B) ? 1'b0:  
                                (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :(branch_taken_A | branch_taken_B) ? 1'b0 : D_is_store_reg_out_B;
    assign x_is_branch_reg_in_B = (branch_taken_A | branch_taken_B) ? 1'b0:  
                                 (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_is_branch_reg_out_B;
    assign x_is_control_insn_reg_in_B =  (branch_taken_A | branch_taken_B) ? 1'b0: 
                                        (D_is_stall_reg_out_A == 2'b11) ? 1'b0 :D_is_control_insn_reg_out_B;
    assign x_pc_reg_in_B = D_pc_reg_out_B;
    assign x_pc_plus_one_reg_in_B = D_pc_plus_one_reg_out_B;
    assign x_is_stall_reg_in_B =  (branch_taken_A | branch_taken_B) ?2'b10: (D_is_stall_reg_out_A == 2'b11) ? 2'b01 :(branch_taken_A | branch_taken_B) ? 2'b10 :D_is_stall_reg_out_B;
    assign x_r1data_reg_in_B = o_rs_data_B; // new elements
    assign x_r2data_reg_in_B = o_rt_data_B; // new elements

    //connection between x stage inputs and x stage outputs for pipeline A
    Nbit_reg #(16, 0) x_ins_reg_A (.in(x_ins_reg_in_A), .out(x_ins_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_r1sel_reg_A (.in(x_r1sel_reg_in_A), .out(x_r1sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_r1re_reg_A (.in(x_r1re_reg_in_A), .out(x_r1re_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_r2sel_reg_A (.in(x_r2sel_reg_in_A), .out(x_r2sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_r2re_reg_A (.in(x_r2re_reg_in_A), .out(x_r2re_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_wsel_reg_A (.in(x_wsel_reg_in_A), .out(x_wsel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_regfile_we_reg_A (.in(x_regfile_we_reg_in_A), .out(x_regfile_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_nzp_we_reg_A (.in(x_nzp_we_reg_in_A), .out(x_nzp_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_select_pc_plus_one_reg_A (.in(x_select_pc_plus_one_reg_in_A), .out(x_select_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_load_reg_A (.in(x_is_load_reg_in_A), .out(x_is_load_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_store_reg_A (.in(x_is_store_reg_in_A), .out(x_is_store_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_branch_reg_A (.in(x_is_branch_reg_in_A), .out(x_is_branch_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_control_insn_reg_A (.in(x_is_control_insn_reg_in_A), .out(x_is_control_insn_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_pc_reg_A (.in(x_pc_reg_in_A), .out(x_pc_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_pc_plus_one_reg_A (.in(x_pc_plus_one_reg_in_A), .out(x_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) x_is_stall_reg_A (.in(x_is_stall_reg_in_A), .out(x_is_stall_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_r1data_reg_A (.in(x_r1data_reg_in_A), .out(x_r1data_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_r2data_reg_A (.in(x_r2data_reg_in_A), .out(x_r2data_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));


    //x stage registers after register file for pipeline B
    Nbit_reg #(16, 0) x_ins_reg_B (.in(x_ins_reg_in_B), .out(x_ins_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_r1sel_reg_B (.in(x_r1sel_reg_in_B), .out(x_r1sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_r1re_reg_B (.in(x_r1re_reg_in_B), .out(x_r1re_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_r2sel_reg_B (.in(x_r2sel_reg_in_B), .out(x_r2sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_r2re_reg_B (.in(x_r2re_reg_in_B), .out(x_r2re_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) x_wsel_reg_B (.in(x_wsel_reg_in_B), .out(x_wsel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_regfile_we_reg_B (.in(x_regfile_we_reg_in_B), .out(x_regfile_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_nzp_we_reg_B (.in(x_nzp_we_reg_in_B), .out(x_nzp_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_select_pc_plus_one_reg_B (.in(x_select_pc_plus_one_reg_in_B), .out(x_select_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_load_reg_B (.in(x_is_load_reg_in_B), .out(x_is_load_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_store_reg_B (.in(x_is_store_reg_in_B), .out(x_is_store_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_branch_reg_B (.in(x_is_branch_reg_in_B), .out(x_is_branch_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) x_is_control_insn_reg_B (.in(x_is_control_insn_reg_in_B), .out(x_is_control_insn_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_pc_reg_B (.in(x_pc_reg_in_B), .out(x_pc_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_pc_plus_one_reg_B (.in(x_pc_plus_one_reg_in_B), .out(x_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) x_is_stall_reg_B (.in(x_is_stall_reg_in_B), .out(x_is_stall_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_r1data_reg_B (.in(x_r1data_reg_in_B), .out(x_r1data_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) x_r2data_reg_B (.in(x_r2data_reg_in_B), .out(x_r2data_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //WX and MX bypass data before ALU two mux MX and WX (pipeline A)
    assign r1data_before_ALU_A = ((mem_wsel_reg_out_B == x_r1sel_reg_out_A) & mem_regfile_we_reg_out_B) ? mem_alu_result_reg_out_B:
                                 ((mem_wsel_reg_out_A == x_r1sel_reg_out_A) & mem_regfile_we_reg_out_A) ? mem_alu_result_reg_out_A:
                                 ((w_wsel_reg_out_B == x_r1sel_reg_out_A) & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                                 ((w_wsel_reg_out_A == x_r1sel_reg_out_A) & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A: x_r1data_reg_out_A;

    assign r2data_before_ALU_A = ((mem_wsel_reg_out_B == x_r2sel_reg_out_A) & mem_regfile_we_reg_out_B) ? mem_alu_result_reg_out_B:
                                 ((mem_wsel_reg_out_A == x_r2sel_reg_out_A) & mem_regfile_we_reg_out_A) ? mem_alu_result_reg_out_A:
                                 ((w_wsel_reg_out_B == x_r2sel_reg_out_A) & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                                 ((w_wsel_reg_out_A == x_r2sel_reg_out_A) & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A: x_r2data_reg_out_A;

    //WX and MX bypass data before ALU two mux MX and WX (pipeline B)
    assign r1data_before_ALU_B = ((mem_wsel_reg_out_B == x_r1sel_reg_out_B) & mem_regfile_we_reg_out_B) ? mem_alu_result_reg_out_B:
                                 ((mem_wsel_reg_out_A == x_r1sel_reg_out_B) & mem_regfile_we_reg_out_A) ? mem_alu_result_reg_out_A:
                                 ((w_wsel_reg_out_B == x_r1sel_reg_out_B) & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                                 ((w_wsel_reg_out_A == x_r1sel_reg_out_B) & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A: x_r1data_reg_out_B;

    assign r2data_before_ALU_B = ((mem_wsel_reg_out_B == x_r2sel_reg_out_B) & mem_regfile_we_reg_out_B) ? mem_alu_result_reg_out_B:
                                 ((mem_wsel_reg_out_A == x_r2sel_reg_out_B) & mem_regfile_we_reg_out_A) ? mem_alu_result_reg_out_A:
                                 ((w_wsel_reg_out_B == x_r2sel_reg_out_B) & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                                 ((w_wsel_reg_out_A == x_r2sel_reg_out_B) & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A: x_r2data_reg_out_B;

    //ALU unit for the pipeline A datapath
    lc4_alu alu_A (.i_insn(x_ins_reg_out_A),
                   .i_pc(x_pc_reg_out_A),
                   .i_r1data(r1data_before_ALU_A),
                   .i_r2data(r2data_before_ALU_A),
                   .o_result(alu_result_A));

    //ALU unit for the pipeline B datapath
    lc4_alu alu_B (.i_insn(x_ins_reg_out_B),
                   .i_pc(x_pc_reg_out_B),
                   .i_r1data(r1data_before_ALU_B),
                   .i_r2data(r2data_before_ALU_B),
                   .o_result(alu_result_B));

    //select whether it should be pc+1 or alu result (the mux right after ALU) for pipeline A
    assign alu_or_pc_plus_one_A = (x_select_pc_plus_one_reg_out_A == 1'b1 | x_is_stall_reg_out_A == 2'b10 | x_ins_reg_out_A[15:12]==4'b1111) ? x_pc_plus_one_reg_out_A :
                                  (x_ins_reg_out_A[15:12]==4'b1100) ? alu_result_A : alu_result_A;

    //select whether it should be pc+1 or alu result (the mux right after ALU) for pipeline B
    assign alu_or_pc_plus_one_B = (x_select_pc_plus_one_reg_out_B == 1'b1 | x_is_stall_reg_out_B == 2'b10 | x_ins_reg_out_B[15:12]==4'b1111) ? x_pc_plus_one_reg_out_B :
                                  (x_ins_reg_out_B[15:12]==4'b1100) ? alu_result_B :
                                  (x_ins_reg_out_B[15:12]==4'b0100) ? x_pc_plus_one_reg_out_B : alu_result_B;

    //NZP registers write in for pipeline A
    assign x_nzp_reg_in_A = ($signed(alu_or_pc_plus_one_A) > $signed(16'b0) ) ? 3'b001:
                            ($signed(alu_or_pc_plus_one_A) == $signed(16'b0) ) ? 3'b010:
                            ($signed(alu_or_pc_plus_one_A) < $signed(16'b0) ) ? 3'b100:3'b000;
    Nbit_reg #(3) x_nzp_reg_A (.in(x_nzp_reg_in_A), .out(x_nzp_reg_out_A), .clk(clk), .we(x_nzp_we_reg_out_A), .gwe(gwe), .rst(rst));

    //NZP registers write in for pipeline B
    assign x_nzp_reg_in_B = ($signed(alu_or_pc_plus_one_B) > $signed(16'b0) ) ? 3'b001:
                            ($signed(alu_or_pc_plus_one_B) == $signed(16'b0) ) ? 3'b010:
                            ($signed(alu_or_pc_plus_one_B) < $signed(16'b0) ) ? 3'b100:3'b000;
    Nbit_reg #(3) x_nzp_reg_B (.in(x_nzp_reg_in_B), .out(x_nzp_reg_out_B), .clk(clk), .we(x_nzp_we_reg_out_B), .gwe(gwe), .rst(rst));

    wire[2:0] x_nzp_reg_final_in, x_nzp_reg_final_out;
    assign x_nzp_reg_final_in = (x_nzp_we_reg_out_B & branch_taken_A!=1'b1) ? x_nzp_reg_in_B:
                                (x_nzp_we_reg_out_A) ? x_nzp_reg_in_A: 3'b0;
    Nbit_reg #(3) x_nzp_reg_final (.in(x_nzp_reg_final_in), .out(x_nzp_reg_final_out), .clk(clk), .we(x_nzp_we_reg_out_A | (x_nzp_we_reg_out_B & branch_taken_A!=1'b1)), .gwe(gwe), .rst(rst));

   wire nzp_equal_or_not_A, nzp_equal_or_not_B;
   assign nzp_equal_or_not_A = (x_ins_reg_out_A[11:9] == 3'b001 & (x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b010 & (x_nzp_reg_final_out == 3'b010)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b011 & (x_nzp_reg_final_out == 3'b010 | x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b100 & (x_nzp_reg_final_out == 3'b100)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b101 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b110 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b010)) ? 1'b1:
                               (x_ins_reg_out_A[11:9] == 3'b111 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b010 | x_nzp_reg_final_out == 3'b001)) ? 1'b1: 1'b0;

    assign nzp_equal_or_not_B =  (x_ins_reg_out_B[11:9] == 3'b001 & (x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b010 & (x_nzp_reg_final_out == 3'b010)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b011 & (x_nzp_reg_final_out == 3'b010 | x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b100 & (x_nzp_reg_final_out == 3'b100)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b101 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b001)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b110 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b010)) ? 1'b1:
                                 (x_ins_reg_out_B[11:9] == 3'b111 & (x_nzp_reg_final_out == 3'b100 | x_nzp_reg_final_out == 3'b010 | x_nzp_reg_final_out == 3'b001)) ? 1'b1: 1'b0;
    //branch predication logic for pipeline A
    assign branch_taken_A = (nzp_equal_or_not_A & x_is_branch_reg_out_A& x_is_stall_reg_out_A != 2'b10) ? 1'b1:
                            (x_is_control_insn_reg_out_A & x_is_stall_reg_out_A != 2'b10) ? 1'b1 : 1'b0;
    //branch predication logic for pipeline B
    assign branch_taken_B = (nzp_equal_or_not_B & x_is_branch_reg_out_B& x_is_stall_reg_out_B != 2'b10) ? 1'b1 :
                            (!x_is_control_insn_reg_out_A & x_is_control_insn_reg_out_B & x_is_stall_reg_out_A != 2'b10) ? 1'b1  : 1'b0;

    //connection between x stage outputs and m stage inputs for pipeline A
    assign mem_ins_reg_in_A = x_ins_reg_out_A;
    assign mem_r1sel_reg_in_A = x_r1sel_reg_out_A;
    assign mem_r2sel_reg_in_A = x_r2sel_reg_out_A;
    assign mem_wsel_reg_in_A = x_wsel_reg_out_A;
    assign mem_regfile_we_reg_in_A = x_regfile_we_reg_out_A;
    assign mem_nzp_we_reg_in_A = x_nzp_we_reg_out_A;
    assign mem_select_pc_plus_one_reg_in_A = x_select_pc_plus_one_reg_in_A;
    assign mem_is_load_reg_in_A = x_is_load_reg_out_A;
    assign mem_is_store_reg_in_A = x_is_store_reg_out_A;
    assign mem_is_branch_reg_in_A = x_is_branch_reg_out_A;
    assign mem_is_control_insn_reg_in_A = x_is_control_insn_reg_out_A;
    assign mem_pc_reg_in_A = x_pc_reg_out_A;
    assign mem_is_stall_reg_in_A = x_is_stall_reg_out_A;
    assign mem_r2data_reg_in_A = r2data_before_ALU_A;
    assign mem_alu_result_reg_in_A = alu_or_pc_plus_one_A; // new elements

    //connection between x stage outputs and m stage inputs for pipeline B
    assign mem_ins_reg_in_B =  (branch_taken_A) ? 16'b0: x_ins_reg_out_B;
    assign mem_r1sel_reg_in_B =  (branch_taken_A) ? 3'b0: x_r1sel_reg_out_B;
    assign mem_r2sel_reg_in_B =  (branch_taken_A) ? 3'b0: x_r2sel_reg_out_B;
    assign mem_wsel_reg_in_B =  (branch_taken_A) ? 3'b0: x_wsel_reg_out_B;
    assign mem_regfile_we_reg_in_B = (branch_taken_A) ? 1'b0 :
                                     (x_is_stall_reg_out_A == 2'b11)? 1'b0 :x_regfile_we_reg_out_B;
    assign mem_nzp_we_reg_in_B = (branch_taken_A) ? 1'b0 :
                                 (x_is_stall_reg_out_A == 2'b11)? 1'b0 :x_nzp_we_reg_out_B;
    assign mem_select_pc_plus_one_reg_in_B =  (branch_taken_A) ? 1'b0: x_select_pc_plus_one_reg_in_B;
    assign mem_is_load_reg_in_B = (branch_taken_A) ? 1'b0 :
                                     (x_is_stall_reg_out_A == 2'b11)? 1'b0 :x_is_load_reg_out_B;
    assign mem_is_store_reg_in_B = (branch_taken_A) ? 1'b0 :
                                     (x_is_stall_reg_out_A == 2'b11)? 1'b0 :x_is_store_reg_out_B;
    assign mem_is_branch_reg_in_B =  (branch_taken_A) ? 1'b0: x_is_branch_reg_out_B;
    assign mem_is_control_insn_reg_in_B =  (branch_taken_A) ? 1'b0: x_is_control_insn_reg_out_B;
    assign mem_pc_reg_in_B = x_pc_reg_out_B;
    assign mem_is_stall_reg_in_B = (branch_taken_A) ? 2'b10 :x_is_stall_reg_out_B;
    assign mem_r2data_reg_in_B = (branch_taken_A) ? 16'b0 :
                                 (x_is_stall_reg_out_A == 2'b11)? 1'b0 :r2data_before_ALU_B;
    assign mem_alu_result_reg_in_B = alu_or_pc_plus_one_B;// new elements

    //connection between m stage inputs and m stage outputs for pipeline A [after mux(ALU result or PC+1)]
    Nbit_reg #(16, 0) mem_ins_reg_A (.in(mem_ins_reg_in_A), .out(mem_ins_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_r1sel_reg_A (.in(mem_r1sel_reg_in_A), .out(mem_r1sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_r2sel_reg_A (.in(mem_r2sel_reg_in_A), .out(mem_r2sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_wsel_reg_A (.in(mem_wsel_reg_in_A), .out(mem_wsel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_regfile_we_reg_A (.in(mem_regfile_we_reg_in_A), .out(mem_regfile_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_nzp_we_reg_A (.in(mem_nzp_we_reg_in_A), .out(mem_nzp_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_select_pc_plus_one_reg_A (.in(mem_select_pc_plus_one_reg_in_A), .out(mem_select_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_load_reg_A (.in(mem_is_load_reg_in_A), .out(mem_is_load_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_store_reg_A (.in(mem_is_store_reg_in_A), .out(mem_is_store_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_branch_reg_A (.in(mem_is_branch_reg_in_A), .out(mem_is_branch_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_control_insn_reg_A (.in(mem_is_control_insn_reg_in_A), .out(mem_is_control_insn_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) mem_is_stall_reg_A (.in(mem_is_stall_reg_in_A), .out(mem_is_stall_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_alu_result_reg_A (.in(mem_alu_result_reg_in_A), .out(mem_alu_result_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_r2data_reg_A (.in(mem_r2data_reg_in_A), .out(mem_r2data_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_pc_reg_A (.in(mem_pc_reg_in_A), .out(mem_pc_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));


    //connection between m stage inputs and m stage outputs for pipeline B [after mux(ALU result or PC+1)]
    Nbit_reg #(16, 0) mem_ins_reg_B (.in(mem_ins_reg_in_B), .out(mem_ins_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_r1sel_reg_B (.in(mem_r1sel_reg_in_B), .out(mem_r1sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_r2sel_reg_B (.in(mem_r2sel_reg_in_B), .out(mem_r2sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) mem_wsel_reg_B (.in(mem_wsel_reg_in_B), .out(mem_wsel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_regfile_we_reg_B (.in(mem_regfile_we_reg_in_B), .out(mem_regfile_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_nzp_we_reg_B (.in(mem_nzp_we_reg_in_B), .out(mem_nzp_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_select_pc_plus_one_reg_B (.in(mem_select_pc_plus_one_reg_in_B), .out(mem_select_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_load_reg_B (.in(mem_is_load_reg_in_B), .out(mem_is_load_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_store_reg_B (.in(mem_is_store_reg_in_B), .out(mem_is_store_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_branch_reg_B (.in(mem_is_branch_reg_in_B), .out(mem_is_branch_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) mem_is_control_insn_reg_B (.in(mem_is_control_insn_reg_in_B), .out(mem_is_control_insn_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) mem_is_stall_reg_B (.in(mem_is_stall_reg_in_B), .out(mem_is_stall_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_alu_result_reg_B (.in(mem_alu_result_reg_in_B), .out(mem_alu_result_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_r2data_reg_B (.in(mem_r2data_reg_in_B), .out(mem_r2data_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) mem_pc_reg_B (.in(mem_pc_reg_in_B), .out(mem_pc_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //data memory logic part There will be two input: one is data from r2data after register file stage register, the other is the address
    //                       There will be on output: data memory output
    assign o_dmem_addr = (mem_is_store_reg_out_A | mem_is_load_reg_out_A) ? mem_alu_result_reg_out_A :
                         (mem_is_store_reg_out_B | mem_is_load_reg_out_B) ? mem_alu_result_reg_out_B :16'b0; // Address to read/write from/to data memory; SET TO 0x0000 FOR NON LOAD/STORE INSNS


    // This is the logic part for store instruction. It enable the write function in memory and get the data from rt in register.
    // The write address has already determined above
    assign o_dmem_we = mem_is_store_reg_out_A | mem_is_store_reg_out_B;

    //WM bypass (assign the value that will be written into the memory if it is a store instruction)
   assign o_dmem_towrite =  (mem_is_store_reg_out_B & mem_wsel_reg_out_A == mem_r2sel_reg_out_B & mem_regfile_we_reg_out_A) ? mem_alu_result_reg_out_A:
                            (mem_is_store_reg_out_B & w_wsel_reg_out_B == mem_r2sel_reg_out_B & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                            (mem_is_store_reg_out_B & w_wsel_reg_out_A == mem_r2sel_reg_out_B & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A:
                            (mem_is_store_reg_out_A & w_wsel_reg_out_B == mem_r2sel_reg_out_A & w_regfile_we_reg_out_B) ? alu_or_pc_plus_one_or_load_B:
                            (mem_is_store_reg_out_A & w_wsel_reg_out_A == mem_r2sel_reg_out_A & w_regfile_we_reg_out_A) ? alu_or_pc_plus_one_or_load_A:
                            mem_is_store_reg_out_B ? mem_r2data_reg_out_B:
                            mem_is_store_reg_out_A ? mem_r2data_reg_out_A: 16'b0;
    //connection between m stage outputs and w stage inputs for pipeline A
    assign w_ins_reg_in_A = mem_ins_reg_out_A;
    assign w_r1sel_reg_in_A = mem_r1sel_reg_out_A;
    assign w_r2sel_reg_in_A = mem_r2sel_reg_out_A;
    assign w_wsel_reg_in_A = mem_wsel_reg_out_A;
    assign w_regfile_we_reg_in_A = mem_regfile_we_reg_out_A;
    assign w_nzp_we_reg_in_A = mem_nzp_we_reg_out_A;
    assign w_select_pc_plus_one_reg_in_A = mem_select_pc_plus_one_reg_out_A;
    assign w_is_load_reg_in_A = mem_is_load_reg_out_A;
    assign w_is_store_reg_in_A = mem_is_store_reg_out_A;
    assign w_is_branch_reg_in_A = mem_is_branch_reg_out_A;
    assign w_is_control_insn_reg_in_A = mem_is_control_insn_reg_out_A;
    assign w_is_stall_reg_in_A = mem_is_stall_reg_out_A;
//  assign w_nzp_reg_in_A =
    assign w_alu_result_reg_in_A = mem_alu_result_reg_out_A;
    assign w_pc_reg_in_A = mem_pc_reg_out_A;
    assign w_o_dmem_addr_reg_in_A = (mem_is_store_reg_out_A | mem_is_load_reg_out_A) ? o_dmem_addr:16'b0;
    assign w_o_dmem_towrite_reg_in_A = (mem_is_store_reg_out_A) ? o_dmem_towrite:16'b0;
    assign w_mem_output_reg_in_A = (mem_is_load_reg_out_A) ? i_cur_dmem_data:16'b0;

    //connection between m stage outputs and w stage inputs for pipeline B
    assign w_ins_reg_in_B = mem_ins_reg_out_B;
    assign w_r1sel_reg_in_B = mem_r1sel_reg_out_B;
    assign w_r2sel_reg_in_B = mem_r2sel_reg_out_B;
    assign w_wsel_reg_in_B = mem_wsel_reg_out_B;
    assign w_regfile_we_reg_in_B = mem_regfile_we_reg_out_B;
    assign w_nzp_we_reg_in_B = mem_nzp_we_reg_out_B;
    assign w_select_pc_plus_one_reg_in_B = mem_select_pc_plus_one_reg_out_B;
    assign w_is_load_reg_in_B = mem_is_load_reg_out_B;
    assign w_is_store_reg_in_B = mem_is_store_reg_out_B;
    assign w_is_branch_reg_in_B = mem_is_branch_reg_out_B;
    assign w_is_control_insn_reg_in_B = mem_is_control_insn_reg_out_B;
    assign w_is_stall_reg_in_B = mem_is_stall_reg_out_B;
//  assign w_nzp_reg_in_A =
    assign w_alu_result_reg_in_B = mem_alu_result_reg_out_B;
    assign w_pc_reg_in_B = mem_pc_reg_out_B;
    assign w_o_dmem_addr_reg_in_B = (mem_is_store_reg_out_B | mem_is_load_reg_out_B) ? o_dmem_addr:16'b0;
    assign w_o_dmem_towrite_reg_in_B = (mem_is_store_reg_out_B)? o_dmem_towrite:16'b0;
    assign w_mem_output_reg_in_B = (mem_is_load_reg_out_B) ? i_cur_dmem_data:16'b0;

    //w stage registers after mux(ALU result or PC+1) for pipeline A
    Nbit_reg #(16, 0) w_ins_reg_A (.in(w_ins_reg_in_A), .out(w_ins_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_r1sel_reg_A (.in(w_r1sel_reg_in_A), .out(w_r1sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_r2sel_reg_A (.in(w_r2sel_reg_in_A), .out(w_r2sel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_wsel_reg_A (.in(w_wsel_reg_in_A), .out(w_wsel_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_regfile_we_reg_A (.in(w_regfile_we_reg_in_A), .out(w_regfile_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_nzp_we_reg_A (.in(w_nzp_we_reg_in_A), .out(w_nzp_we_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_select_pc_plus_one_reg_A (.in(w_select_pc_plus_one_reg_in_A), .out(w_select_pc_plus_one_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_load_reg_A (.in(w_is_load_reg_in_A), .out(w_is_load_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));


    Nbit_reg #(1, 0) w_is_store_reg_A (.in(w_is_store_reg_in_A), .out(w_is_store_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_branch_reg_A (.in(w_is_branch_reg_in_A), .out(w_is_branch_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_control_insn_reg_A (.in(w_is_control_insn_reg_in_A), .out(w_is_control_insn_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) w_is_stall_reg_A (.in(w_is_stall_reg_in_A), .out(w_is_stall_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

//  Nbit_reg #(3) w_n_reg_A (.in(w_nzp_reg_in_A), .out(w_nzp_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_alu_result_reg_A (.in(w_alu_result_reg_in_A), .out(w_alu_result_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_pc_reg_A (.in(w_pc_reg_in_A), .out(w_pc_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_o_dmem_addr_reg_A (.in(w_o_dmem_addr_reg_in_A), .out(w_o_dmem_addr_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_o_dmem_towrite_reg_A (.in(w_o_dmem_towrite_reg_in_A), .out(w_o_dmem_towrite_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_d_mem_output_reg_A (.in(w_mem_output_reg_in_A), .out(w_mem_output_reg_out_A), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //w stage registers after mux(ALU result or PC+1) for pipeline B
    Nbit_reg #(16, 0) w_ins_reg_B (.in(w_ins_reg_in_B), .out(w_ins_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_r1sel_reg_B (.in(w_r1sel_reg_in_B), .out(w_r1sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_r2sel_reg_B (.in(w_r2sel_reg_in_B), .out(w_r2sel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(3, 0) w_wsel_reg_B (.in(w_wsel_reg_in_B), .out(w_wsel_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_regfile_we_reg_B (.in(w_regfile_we_reg_in_B), .out(w_regfile_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_nzp_we_reg_B (.in(w_nzp_we_reg_in_B), .out(w_nzp_we_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_select_pc_plus_one_reg_B (.in(w_select_pc_plus_one_reg_in_B), .out(w_select_pc_plus_one_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_load_reg_B (.in(w_is_load_reg_in_B), .out(w_is_load_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_store_reg_B (.in(w_is_store_reg_in_B), .out(w_is_store_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_branch_reg_B (.in(w_is_branch_reg_in_B), .out(w_is_branch_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(1, 0) w_is_control_insn_reg_B (.in(w_is_control_insn_reg_in_B), .out(w_is_control_insn_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(2, 0) w_is_stall_reg_B (.in(w_is_stall_reg_in_B), .out(w_is_stall_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

//    Nbit_reg #(3) w_n_reg_B (.in(w_nzp_reg_in_B), .out(w_nzp_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_alu_result_reg_B (.in(w_alu_result_reg_in_B), .out(w_alu_result_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_pc_reg_B (.in(w_pc_reg_in_B), .out(w_pc_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_o_dmem_addr_reg_B (.in(w_o_dmem_addr_reg_in_B), .out(w_o_dmem_addr_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_o_dmem_towrite_reg_B (.in(w_o_dmem_towrite_reg_in_B), .out(w_o_dmem_towrite_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    Nbit_reg #(16, 0) w_d_mem_output_reg_B (.in(w_mem_output_reg_in_B), .out(w_mem_output_reg_out_B), .clk(clk), .we(1'b1), .gwe(gwe), .rst(rst));

    //the mux after d stage outputs (input: alu_or_pc_plus_one and data memory output) for pipeline A
    assign alu_or_pc_plus_one_or_load_A = ((w_is_load_reg_out_A == 1'b1)) ? w_mem_output_reg_out_A : w_alu_result_reg_out_A;

    //the mux after d stage outputs (input: alu_or_pc_plus_one and data memory output) for pipeline B
    assign alu_or_pc_plus_one_or_load_B = ((w_is_load_reg_out_B == 1'b1)) ? w_mem_output_reg_out_B : w_alu_result_reg_out_B;


    //update PC address
    assign next_pc = (branch_taken_A == 1'b1) ? alu_result_A :
                     (branch_taken_B == 1'b1) ? alu_result_B : pc_plus_one_B;
    assign o_cur_pc = pc;

    //stall signal for Pipeline A has to be placed into the end of the code for some variables in memory stage registers
    assign test_stall_A = ((D_pc_reg_out_A == 16'h8200)&(x_pc_reg_out_A == 16'h0)&(mem_pc_reg_out_A == 16'h0)&(w_pc_reg_out_A == 16'h0)) ? 2'b10:
                          ((x_pc_reg_out_A == 16'h8200)&(mem_pc_reg_out_A == 16'h0)&(w_pc_reg_out_A == 16'h0)) ? 2'b10:
                          ((mem_pc_reg_out_A == 16'h8200)&(w_pc_reg_out_A == 16'h0)) ? 2'b10:w_is_stall_reg_out_A;


    //stall signal for Pipeline B has to be placed into the end of the code for some variables in memory stage registers
    assign test_stall_B = ((D_pc_reg_out_B == 16'h8201)&(x_pc_reg_out_B == 16'h0)&(mem_pc_reg_out_B == 16'h0)&(w_pc_reg_out_B == 16'h0)) ? 2'b10:
                          ((x_pc_reg_out_B == 16'h8201)&(mem_pc_reg_out_B == 16'h0)&(w_pc_reg_out_B == 16'h0)) ? 2'b10:
                          ((x_pc_reg_out_B == 16'h0)&(mem_pc_reg_out_B == 16'h0)&(w_pc_reg_out_B == 16'h0)) ? 2'b10:
                          ((mem_pc_reg_out_B == 16'h8201)&(w_pc_reg_out_B == 16'h0)) ? 2'b10:
                          (w_is_stall_reg_out_A == 2'b11) ? 2'b01: w_is_stall_reg_out_B;

    assign test_cur_pc_A = w_pc_reg_out_A;                       // program counter
    assign test_cur_pc_B = w_pc_reg_out_B;
    assign test_cur_insn_A = w_ins_reg_out_A;                    // instruction bits
    assign test_cur_insn_B = w_ins_reg_out_B;
    assign test_regfile_we_A = w_regfile_we_reg_out_A;           // register file write-enable
    assign test_regfile_we_B = w_regfile_we_reg_out_B;
    assign test_regfile_wsel_A = w_wsel_reg_out_A;               // which register to write
    assign test_regfile_wsel_B = w_wsel_reg_out_B;
    assign test_regfile_data_A = alu_or_pc_plus_one_or_load_A;   // data to write to register file
    assign test_regfile_data_B = alu_or_pc_plus_one_or_load_B;
    assign test_nzp_we_A = w_nzp_we_reg_out_A;                   // nzp register write enable
    assign test_nzp_we_B = w_nzp_we_reg_out_B;

    //NZP registers in W stage for pipeline A
    assign w_nzp_reg_A = ($signed(alu_or_pc_plus_one_or_load_A) > $signed(16'b0) ) ? 3'b001:
                         ($signed(alu_or_pc_plus_one_or_load_A) == $signed(16'b0) ) ? 3'b010:
                         ($signed(alu_or_pc_plus_one_or_load_A) < $signed(16'b0) ) ? 3'b100:3'b000;

    //NZP registers in W stage for pipeline B
    assign w_nzp_reg_B = ($signed(alu_or_pc_plus_one_or_load_B) > $signed(16'b0) ) ? 3'b001:
                         ($signed(alu_or_pc_plus_one_or_load_B) == $signed(16'b0) ) ? 3'b010:
                         ($signed(alu_or_pc_plus_one_or_load_B) < $signed(16'b0) ) ? 3'b100:3'b000;

    assign test_nzp_new_bits_A = w_nzp_reg_A; // new nzp bits
    assign test_nzp_new_bits_B = w_nzp_reg_B;
    assign test_dmem_we_A = w_is_store_reg_out_A;      // data memory write enable
    assign test_dmem_we_B = w_is_store_reg_out_B;
    assign test_dmem_addr_A = w_o_dmem_addr_reg_out_A;    // address to read/write from/to memory
    assign test_dmem_addr_B = w_o_dmem_addr_reg_out_B;
    assign test_dmem_data_A = (w_is_load_reg_out_A) ? w_mem_output_reg_out_A :
                              (w_is_store_reg_out_A) ? w_o_dmem_towrite_reg_out_A: 16'b0;    // data to read/write from/to memory
    assign test_dmem_data_B = (w_is_load_reg_out_B) ? w_mem_output_reg_out_B :
                              (w_is_store_reg_out_B) ? w_o_dmem_towrite_reg_out_B: 16'b0;

   always @(posedge gwe) begin
   //$display("Cycle number: %d", num_cycles);
   $display("Cycle %d", num_cycles);
   $display("F stage");
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %d %d %h",
   D_is_stall_reg_in_A, D_pc_reg_in_A, D_ins_reg_in_A, D_r1sel_reg_in_A,
   D_r1re_reg_in_A, D_r2sel_reg_in_A, D_r2re_reg_in_A, D_wsel_reg_in_A,
   D_regfile_we_reg_in_A, D_nzp_we_reg_in_A, D_select_pc_plus_one_reg_in_A,
   D_is_load_reg_in_A, D_is_store_reg_in_A, D_is_branch_reg_in_A,
   D_is_control_insn_reg_in_A, D_pc_plus_one_reg_in_A);
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %d %d %h",
   D_is_stall_reg_in_B, D_pc_reg_in_B, D_ins_reg_in_B, D_r1sel_reg_in_B,
   D_r1re_reg_in_B, D_r2sel_reg_in_B, D_r2re_reg_in_B, D_wsel_reg_in_B,
   D_regfile_we_reg_in_B, D_nzp_we_reg_in_B, D_select_pc_plus_one_reg_in_B,
   D_is_load_reg_in_B, D_is_store_reg_in_B, D_is_branch_reg_in_B,
   D_is_control_insn_reg_in_B, D_pc_plus_one_reg_in_B);

   $display("D stage");
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %d %d %h %h %h",
   x_is_stall_reg_in_A, x_pc_reg_in_A, x_ins_reg_in_A, x_r1sel_reg_in_A, x_r1re_reg_in_A,
   x_r2sel_reg_in_A, x_r2re_reg_in_A, x_wsel_reg_in_A, x_regfile_we_reg_in_A,
   x_nzp_we_reg_in_A, x_select_pc_plus_one_reg_in_A, x_is_load_reg_in_A,
   x_is_store_reg_in_A, x_is_branch_reg_in_A, x_is_control_insn_reg_in_A,
   x_pc_plus_one_reg_in_A, x_r1data_reg_in_A,
   x_r2data_reg_in_A);
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %d %d %h %h %h",
   x_is_stall_reg_in_B, x_pc_reg_in_B, x_ins_reg_in_B, x_r1sel_reg_in_B, x_r1re_reg_in_B,
   x_r2sel_reg_in_B, x_r2re_reg_in_B, x_wsel_reg_in_B, x_regfile_we_reg_in_B,
   x_nzp_we_reg_in_B, x_select_pc_plus_one_reg_in_B, x_is_load_reg_in_B,
   x_is_store_reg_in_B, x_is_branch_reg_in_B, x_is_control_insn_reg_in_B,
   x_pc_plus_one_reg_in_B, x_r1data_reg_in_B,
   x_r2data_reg_in_B);

   $display("X stage");
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %h %h %d %d",
   mem_is_stall_reg_in_A, mem_pc_reg_in_A, mem_ins_reg_in_A, mem_r1sel_reg_in_A, mem_r2sel_reg_in_A,
   mem_wsel_reg_in_A, mem_regfile_we_reg_in_A, mem_nzp_we_reg_in_A,
   mem_select_pc_plus_one_reg_in_A, mem_is_load_reg_in_A, mem_is_store_reg_in_A,
   mem_is_branch_reg_in_A, mem_is_control_insn_reg_in_A,
   mem_r2data_reg_in_A, mem_alu_result_reg_in_A, x_nzp_reg_in_A, branch_taken_A);
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %h %h %d %d",
   mem_is_stall_reg_in_B, mem_pc_reg_in_B, mem_ins_reg_in_B, mem_r1sel_reg_in_B, mem_r2sel_reg_in_B,
   mem_wsel_reg_in_B, mem_regfile_we_reg_in_B, mem_nzp_we_reg_in_B,
   mem_select_pc_plus_one_reg_in_B, mem_is_load_reg_in_B, mem_is_store_reg_in_B,
   mem_is_branch_reg_in_B, mem_is_control_insn_reg_in_B,
   mem_r2data_reg_in_B, mem_alu_result_reg_in_B, x_nzp_reg_in_B, branch_taken_B);
   $display("latest nzp in:%d", x_nzp_reg_final_in);
   $display("latest nzp out:%d", x_nzp_reg_final_out);

   $display("M stage");
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %h %d %h %h %h",
   w_is_stall_reg_in_A, w_pc_reg_in_A, w_ins_reg_in_A, w_r1sel_reg_in_A, w_r2sel_reg_in_A, w_wsel_reg_in_A,
   w_regfile_we_reg_in_A, w_nzp_we_reg_in_A, w_select_pc_plus_one_reg_in_A,
   w_is_load_reg_in_A, w_is_store_reg_in_A, w_is_branch_reg_in_A,
   w_is_control_insn_reg_in_A,w_alu_result_reg_in_A, x_nzp_reg_out_A,
   w_o_dmem_addr_reg_in_A, w_o_dmem_towrite_reg_in_A,
   w_mem_output_reg_in_A);
   $display("%d %h %h %d %d %d %d %d %d %d %d %d %d %h %d %h %h %h",
   w_is_stall_reg_in_B, w_pc_reg_in_B, w_ins_reg_in_B, w_r1sel_reg_in_B, w_r2sel_reg_in_B, w_wsel_reg_in_B,
   w_regfile_we_reg_in_B, w_nzp_we_reg_in_B, w_select_pc_plus_one_reg_in_B,
   w_is_load_reg_in_B, w_is_store_reg_in_B, w_is_branch_reg_in_B,
   w_is_control_insn_reg_in_B, w_alu_result_reg_in_B, x_nzp_reg_out_B,
   w_o_dmem_addr_reg_in_B, w_o_dmem_towrite_reg_in_B,
   w_mem_output_reg_in_B);

   $display("W stage");
   $display("%d %h %h %d %d %h %d %d %d %h %h",
   test_stall_A, test_cur_pc_A, test_cur_insn_A, test_regfile_we_A,
   test_regfile_wsel_A, test_regfile_data_A, test_nzp_we_A, test_nzp_new_bits_A,
   test_dmem_we_A, test_dmem_addr_A, test_dmem_data_A);
   $display("%d %h %h %d %d %h %d %d %d %h %h",
   test_stall_B, test_cur_pc_B, test_cur_insn_B, test_regfile_we_B,
   test_regfile_wsel_B, test_regfile_data_B, test_nzp_we_B, test_nzp_new_bits_B,
   test_dmem_we_B, test_dmem_addr_B, test_dmem_data_B);
   num_cycles = num_cycles + 1;
   end

endmodule
