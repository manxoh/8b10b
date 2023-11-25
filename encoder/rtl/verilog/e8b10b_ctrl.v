/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Control Block                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////
//                                                                 //
//             Copyright (C) 2014-2023 ROA Logic BV                //
//             www.roalogic.com                                    //
//                                                                 //
//   This source file may be used and distributed without          //
//   restriction provided that this copyright statement is not     //
//   removed from the file and that any derivative work contains   //
//   the original copyright notice and the associated disclaimer.  //
//                                                                 //
//      THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY        //
//   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED     //
//   TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS     //
//   FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR OR     //
//   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,  //
//   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT  //
//   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;  //
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)      //
//   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN     //
//   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR  //
//   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS          //
//   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  //
//                                                                 //
/////////////////////////////////////////////////////////////////////

// +FHDR -  Semiconductor Reuse Standard File Header Section  -------
// FILE NAME      : e8b10b_ctrl.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     20-12-2014  rherveille  initial release
// ------------------------------------------------------------------
// KEYWORDS : 8b10b encoder
// ------------------------------------------------------------------
// PURPOSE  : 8b10b Encoder Control - Stage 2
// ------------------------------------------------------------------
// PARAMETERS
//  NONE
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : external asynchronous active low; rstn_i
//   Clock Domains       : 1, clk_i, rising edge
//   Critical Timing     : 
//   Test Features       : na
//   Asynchronous I/F    : no
//   Scan Methodology    : na
//   Instantiations      : na 
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


`pragma protect begin

module e8b10b_ctrl (
  input            clk_i,
  input            rstn_i,
  input      [7:0] d_i,

  output reg       d6_alt_o,
  output reg       d4_alt_o,
  output reg       d4_invrd_o,
  output reg       dflip_o,
  output reg       sc_nrd_o,
  output reg       sc_prd_o
);



parameter d03_0 = 8'b000_00011;
parameter d05_0 = 8'b000_00101;
parameter d06_0 = 8'b000_00110;
parameter d07_0 = 8'b000_00111;
parameter d09_0 = 8'b000_01001;
parameter d10_0 = 8'b000_01010;
parameter d11_0 = 8'b000_01011;
parameter d12_0 = 8'b000_01100;
parameter d13_0 = 8'b000_01101;
parameter d14_0 = 8'b000_01110;
parameter d17_0 = 8'b000_10001;
parameter d18_0 = 8'b000_10010;
parameter d19_0 = 8'b000_10011;
parameter d20_0 = 8'b000_10100;
parameter d21_0 = 8'b000_10101;
parameter d22_0 = 8'b000_10110;
parameter d25_0 = 8'b000_11001;
parameter d26_0 = 8'b000_11010;
parameter d28_0 = 8'b000_11100;
parameter d00_1 = 8'b001_00000;
parameter d01_1 = 8'b001_00001;
parameter d02_1 = 8'b001_00010;
parameter d04_1 = 8'b001_00100;
parameter d08_1 = 8'b001_01000;
parameter d15_1 = 8'b001_01111;
parameter d16_1 = 8'b001_10000;
parameter d23_1 = 8'b001_10111;
parameter d24_1 = 8'b001_11000;
parameter d27_1 = 8'b001_11011;
parameter d29_1 = 8'b001_11101;
parameter d30_1 = 8'b001_11110;
parameter d31_1 = 8'b001_11111;
parameter d00_2 = 8'b010_00000;
parameter d01_2 = 8'b010_00001;
parameter d02_2 = 8'b010_00010;
parameter d04_2 = 8'b010_00100;
parameter d08_2 = 8'b010_01000;
parameter d15_2 = 8'b010_01111;
parameter d16_2 = 8'b010_10000;
parameter d23_2 = 8'b010_10111;
parameter d24_2 = 8'b010_11000;
parameter d27_2 = 8'b010_11011;
parameter d29_2 = 8'b010_11101;
parameter d30_2 = 8'b010_11110;
parameter d31_2 = 8'b010_11111;
parameter d00_3 = 8'b011_00000;
parameter d01_3 = 8'b011_00001;
parameter d02_3 = 8'b011_00010;
parameter d04_3 = 8'b011_00100;
parameter d08_3 = 8'b011_01000;
parameter d15_3 = 8'b011_01111;
parameter d16_3 = 8'b011_10000;
parameter d23_3 = 8'b011_10111;
parameter d24_3 = 8'b011_11000;
parameter d27_3 = 8'b011_11011;
parameter d29_3 = 8'b011_11101;
parameter d30_3 = 8'b011_11110;
parameter d31_3 = 8'b011_11111;
parameter d03_4 = 8'b100_00011;
parameter d05_4 = 8'b100_00101;
parameter d06_4 = 8'b100_00110;
parameter d07_4 = 8'b100_00111;
parameter d09_4 = 8'b100_01001;
parameter d10_4 = 8'b100_01010;
parameter d11_4 = 8'b100_01011;
parameter d12_4 = 8'b100_01100;
parameter d13_4 = 8'b100_01101;
parameter d14_4 = 8'b100_01110;
parameter d17_4 = 8'b100_10001;
parameter d18_4 = 8'b100_10010;
parameter d19_4 = 8'b100_10011;
parameter d20_4 = 8'b100_10100;
parameter d21_4 = 8'b100_10101;
parameter d22_4 = 8'b100_10110;
parameter d25_4 = 8'b100_11001;
parameter d26_4 = 8'b100_11010;
parameter d28_4 = 8'b100_11100;
parameter d00_5 = 8'b101_00000;
parameter d01_5 = 8'b101_00001;
parameter d02_5 = 8'b101_00010;
parameter d04_5 = 8'b101_00100;
parameter d08_5 = 8'b101_01000;
parameter d15_5 = 8'b101_01111;
parameter d16_5 = 8'b101_10000;
parameter d23_5 = 8'b101_10111;
parameter d24_5 = 8'b101_11000;
parameter d27_5 = 8'b101_11011;
parameter d29_5 = 8'b101_11101;
parameter d30_5 = 8'b101_11110;
parameter d31_5 = 8'b101_11111;
parameter d00_6 = 8'b110_00000;
parameter d01_6 = 8'b110_00001;
parameter d02_6 = 8'b110_00010;
parameter d04_6 = 8'b110_00100;
parameter d08_6 = 8'b110_01000;
parameter d15_6 = 8'b110_01111;
parameter d16_6 = 8'b110_10000;
parameter d23_6 = 8'b110_10111;
parameter d24_6 = 8'b110_11000;
parameter d27_6 = 8'b110_11011;
parameter d29_6 = 8'b110_11101;
parameter d30_6 = 8'b110_11110;
parameter d31_6 = 8'b110_11111;
parameter d03_7 = 8'b111_00011;
parameter d05_7 = 8'b111_00101;
parameter d06_7 = 8'b111_00110;
parameter d07_7 = 8'b111_00111;
parameter d09_7 = 8'b111_01001;
parameter d10_7 = 8'b111_01010;
parameter d11_7 = 8'b111_01011;
parameter d12_7 = 8'b111_01100;
parameter d13_7 = 8'b111_01101;
parameter d14_7 = 8'b111_01110;
parameter d17_7 = 8'b111_10001;
parameter d18_7 = 8'b111_10010;
parameter d19_7 = 8'b111_10011;
parameter d20_7 = 8'b111_10100;
parameter d21_7 = 8'b111_10101;
parameter d22_7 = 8'b111_10110;
parameter d25_7 = 8'b111_11001;
parameter d26_7 = 8'b111_11010;
parameter d28_7 = 8'b111_11100;

// generate a signal that indicates d4_o might need to be inverted
always @(posedge clk_i)
  case (d_i[7:5]) //synopsys parallel_case
    3'd0:    d4_alt_o <= 1'b1;
    3'd3:    d4_alt_o <= 1'b1;
    3'd4:    d4_alt_o <= 1'b1;
    3'd7:    d4_alt_o <= 1'b1;
    default: d4_alt_o <= 1'b0;
  endcase

// generate a signal that indicates d6_o might need to be inverted
always @(posedge clk_i)
  case (d_i[4:0]) //synopsys parallel_case
    5'd0:    d6_alt_o <= 1'b1;
    5'd1:    d6_alt_o <= 1'b1;
    5'd2:    d6_alt_o <= 1'b1;
    5'd4:    d6_alt_o <= 1'b1;
    5'd7:    d6_alt_o <= 1'b1;
    5'd8:    d6_alt_o <= 1'b1;
    5'd15:   d6_alt_o <= 1'b1;
    5'd16:   d6_alt_o <= 1'b1;
    5'd23:   d6_alt_o <= 1'b1;
    5'd24:   d6_alt_o <= 1'b1;
    5'd27:   d6_alt_o <= 1'b1;
    5'd29:   d6_alt_o <= 1'b1;
    5'd30:   d6_alt_o <= 1'b1;
    5'd31:   d6_alt_o <= 1'b1;
    default: d6_alt_o <= 1'b0;
  endcase

// generate a signal that indicates when d4 may be inverted
always @(posedge clk_i)
  case (d_i[4:0]) //synopsys parallel_case
    5'd0:    d4_invrd_o <= 1'b1;
    5'd1:    d4_invrd_o <= 1'b1;
    5'd2:    d4_invrd_o <= 1'b1;
    5'd4:    d4_invrd_o <= 1'b1;
    5'd8:    d4_invrd_o <= 1'b1;
    5'd15:   d4_invrd_o <= 1'b1;
    5'd16:   d4_invrd_o <= 1'b1;
    5'd23:   d4_invrd_o <= 1'b1;
    5'd24:   d4_invrd_o <= 1'b1;
    5'd27:   d4_invrd_o <= 1'b1;
    5'd29:   d4_invrd_o <= 1'b1;
    5'd30:   d4_invrd_o <= 1'b1;
    5'd31:   d4_invrd_o <= 1'b1;
    default: d4_invrd_o <= 1'b0;
  endcase

// Special characters when running disparity is positive
always @(posedge clk_i)
  case (d_i) //synopsys parallel_case
    d11_7:   sc_prd_o <= 1'b1;
    d13_7:   sc_prd_o <= 1'b1;
    d14_7:   sc_prd_o <= 1'b1;
    default: sc_prd_o <= 1'b0;
  endcase

// Special characters when running disparity is negative
always @(posedge clk_i)
  case (d_i) //synopsys parallel_case
    d17_7:   sc_nrd_o <= 1'b1;
    d18_7:   sc_nrd_o <= 1'b1;
    d20_7:   sc_nrd_o <= 1'b1;
    default: sc_nrd_o <= 1'b0;
  endcase

// generate Dflip
always @(posedge clk_i)
  case (d_i) //synopsys parallel_case
    d03_0:   dflip_o <= 1'b1;
    d05_0:   dflip_o <= 1'b1;
    d06_0:   dflip_o <= 1'b1;
    d07_0:   dflip_o <= 1'b1;
    d09_0:   dflip_o <= 1'b1;
    d10_0:   dflip_o <= 1'b1;
    d11_0:   dflip_o <= 1'b1;
    d12_0:   dflip_o <= 1'b1;
    d13_0:   dflip_o <= 1'b1;
    d14_0:   dflip_o <= 1'b1;
    d17_0:   dflip_o <= 1'b1;
    d18_0:   dflip_o <= 1'b1;
    d19_0:   dflip_o <= 1'b1;
    d20_0:   dflip_o <= 1'b1;
    d21_0:   dflip_o <= 1'b1;
    d22_0:   dflip_o <= 1'b1;
    d25_0:   dflip_o <= 1'b1;
    d26_0:   dflip_o <= 1'b1;
    d28_0:   dflip_o <= 1'b1;
    d00_1:   dflip_o <= 1'b1;
    d01_1:   dflip_o <= 1'b1;
    d02_1:   dflip_o <= 1'b1;
    d04_1:   dflip_o <= 1'b1;
    d08_1:   dflip_o <= 1'b1;
    d15_1:   dflip_o <= 1'b1;
    d16_1:   dflip_o <= 1'b1;
    d23_1:   dflip_o <= 1'b1;
    d24_1:   dflip_o <= 1'b1;
    d27_1:   dflip_o <= 1'b1;
    d29_1:   dflip_o <= 1'b1;
    d30_1:   dflip_o <= 1'b1;
    d31_1:   dflip_o <= 1'b1;
    d00_2:   dflip_o <= 1'b1;
    d01_2:   dflip_o <= 1'b1;
    d02_2:   dflip_o <= 1'b1;
    d04_2:   dflip_o <= 1'b1;
    d08_2:   dflip_o <= 1'b1;
    d15_2:   dflip_o <= 1'b1;
    d16_2:   dflip_o <= 1'b1;
    d23_2:   dflip_o <= 1'b1;
    d24_2:   dflip_o <= 1'b1;
    d27_2:   dflip_o <= 1'b1;
    d29_2:   dflip_o <= 1'b1;
    d30_2:   dflip_o <= 1'b1;
    d31_2:   dflip_o <= 1'b1;
    d00_3:   dflip_o <= 1'b1;
    d01_3:   dflip_o <= 1'b1;
    d02_3:   dflip_o <= 1'b1;
    d04_3:   dflip_o <= 1'b1;
    d08_3:   dflip_o <= 1'b1;
    d15_3:   dflip_o <= 1'b1;
    d16_3:   dflip_o <= 1'b1;
    d23_3:   dflip_o <= 1'b1;
    d24_3:   dflip_o <= 1'b1;
    d27_3:   dflip_o <= 1'b1;
    d29_3:   dflip_o <= 1'b1;
    d30_3:   dflip_o <= 1'b1;
    d31_3:   dflip_o <= 1'b1;
    d03_4:   dflip_o <= 1'b1;
    d05_4:   dflip_o <= 1'b1;
    d06_4:   dflip_o <= 1'b1;
    d07_4:   dflip_o <= 1'b1;
    d09_4:   dflip_o <= 1'b1;
    d10_4:   dflip_o <= 1'b1;
    d11_4:   dflip_o <= 1'b1;
    d12_4:   dflip_o <= 1'b1;
    d13_4:   dflip_o <= 1'b1;
    d14_4:   dflip_o <= 1'b1;
    d17_4:   dflip_o <= 1'b1;
    d18_4:   dflip_o <= 1'b1;
    d19_4:   dflip_o <= 1'b1;
    d20_4:   dflip_o <= 1'b1;
    d21_4:   dflip_o <= 1'b1;
    d22_4:   dflip_o <= 1'b1;
    d25_4:   dflip_o <= 1'b1;
    d26_4:   dflip_o <= 1'b1;
    d28_4:   dflip_o <= 1'b1;
    d00_5:   dflip_o <= 1'b1;
    d01_5:   dflip_o <= 1'b1;
    d02_5:   dflip_o <= 1'b1;
    d04_5:   dflip_o <= 1'b1;
    d08_5:   dflip_o <= 1'b1;
    d15_5:   dflip_o <= 1'b1;
    d16_5:   dflip_o <= 1'b1;
    d23_5:   dflip_o <= 1'b1;
    d24_5:   dflip_o <= 1'b1;
    d27_5:   dflip_o <= 1'b1;
    d29_5:   dflip_o <= 1'b1;
    d30_5:   dflip_o <= 1'b1;
    d31_5:   dflip_o <= 1'b1;
    d00_6:   dflip_o <= 1'b1;
    d01_6:   dflip_o <= 1'b1;
    d02_6:   dflip_o <= 1'b1;
    d04_6:   dflip_o <= 1'b1;
    d08_6:   dflip_o <= 1'b1;
    d15_6:   dflip_o <= 1'b1;
    d16_6:   dflip_o <= 1'b1;
    d23_6:   dflip_o <= 1'b1;
    d24_6:   dflip_o <= 1'b1;
    d27_6:   dflip_o <= 1'b1;
    d29_6:   dflip_o <= 1'b1;
    d30_6:   dflip_o <= 1'b1;
    d31_6:   dflip_o <= 1'b1;
    d03_7:   dflip_o <= 1'b1;
    d05_7:   dflip_o <= 1'b1;
    d06_7:   dflip_o <= 1'b1;
    d07_7:   dflip_o <= 1'b1;
    d09_7:   dflip_o <= 1'b1;
    d10_7:   dflip_o <= 1'b1;
    d11_7:   dflip_o <= 1'b1;
    d12_7:   dflip_o <= 1'b1;
    d13_7:   dflip_o <= 1'b1;
    d14_7:   dflip_o <= 1'b1;
    d17_7:   dflip_o <= 1'b1;
    d18_7:   dflip_o <= 1'b1;
    d19_7:   dflip_o <= 1'b1;
    d20_7:   dflip_o <= 1'b1;
    d21_7:   dflip_o <= 1'b1;
    d22_7:   dflip_o <= 1'b1;
    d25_7:   dflip_o <= 1'b1;
    d26_7:   dflip_o <= 1'b1;
    d28_7:   dflip_o <= 1'b1;
    default: dflip_o <= 1'b0;
  endcase

endmodule

`pragma protect end

