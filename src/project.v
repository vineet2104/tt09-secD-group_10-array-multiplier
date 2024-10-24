/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_array_mult (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	wire [3:0] m = ui_in[7:4];
	wire [3:0] q = ui_in[3:0];
	wire [7:0] p;

	wire m0q0, m1q0, m2q0, m3q0;
	wire m0q1, m1q1, m2q1, m3q1;
	wire m0q2, m1q2, m2q2, m3q2;
	wire m0q3, m1q3, m2q3, m3q3;

	wire [3:0] carry_adders_1;
	wire [3:0] carry_adders_2;
	wire [3:0] carry_adders_3;

	wire [2:0] sum_adders_1;
	wire [2:0] sum_adders_2;

	assign p[0] = m[0] & q[0];

	assign m1q0 = m[1] & q[0];
	assign m2q0 = m[2] & q[0];
	assign m3q0 = m[3] & q[0];

	assign m0q1 = m[0] & q[1];
	assign m1q1 = m[1] & q[1];
	assign m2q1 = m[2] & q[1];
	assign m3q1 = m[3] & q[1];

	assign m0q2 = m[0] & q[2];
	assign m1q2 = m[1] & q[2];
	assign m2q2 = m[2] & q[2];
	assign m3q2 = m[3] & q[2];

	assign m0q3 = m[0] & q[3];
	assign m1q3 = m[1] & q[3];
	assign m2q3 = m[2] & q[3];
	assign m3q3 = m[3] & q[3];

	full_adder fa0 (.a(m0q1), .b(m1q0), .cin(1'b0), .sum(p[1]), .cout(carry_adders_1[0]));
	full_adder fa1 (.a(m1q1), .b(m2q0), .cin(carry_adders_1[0]), .sum(sum_adders_1[0]), .cout(carry_adders_1[1]));
	full_adder fa2 (.a(m2q1), .b(m3q0), .cin(carry_adders_1[1]), .sum(sum_adders_1[1]), .cout(carry_adders_1[2]));
	full_adder fa3 (.a(m3q1), .b(1'b0), .cin(carry_adders_1[2]), .sum(sum_adders_1[2]), .cout(carry_adders_1[3]));

	full_adder fa4 (.a(m0q2), .b(sum_adders_1[0]), .cin(1'b0), .sum(p[2]), .cout(carry_adders_2[0]));
	full_adder fa5 (.a(m1q2), .b(sum_adders_1[1]), .cin(carry_adders_2[0]), .sum(sum_adders_2[0]), .cout(carry_adders_2[1]));
	full_adder fa6 (.a(m2q2), .b(sum_adders_1[2]), .cin(carry_adders_2[1]), .sum(sum_adders_2[1]), .cout(carry_adders_2[2]));
	full_adder fa7 (.a(m3q2), .b(carry_adders_1[3]), .cin(carry_adders_2[2]), .sum(sum_adders_2[2]), .cout(carry_adders_2[3]));

	full_adder fa8 (.a(m0q3), .b(sum_adders_2[0]), .cin(1'b0), .sum(p[3]), .cout(carry_adders_3[0]));
	full_adder fa9 (.a(m1q3), .b(sum_adders_2[1]), .cin(carry_adders_3[0]), .sum(p[4]), .cout(carry_adders_3[1]));
	full_adder fa10 (.a(m2q3), .b(sum_adders_2[2]), .cin(carry_adders_3[1]), .sum(p[5]), .cout(carry_adders_3[2]));
	full_adder fa11 (.a(m3q3), .b(carry_adders_2[3]), .cin(carry_adders_3[2]), .sum(p[6]), .cout(p[7]));


  assign uo_out = p;

  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

module full_adder (
	input wire a,
	input wire b,
	input wire cin,
	output wire sum,
	output wire cout
);

	assign sum = a ^ b ^ cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
endmodule