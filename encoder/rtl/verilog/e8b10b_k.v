/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Komma Character Block                                         //
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
// FILE NAME      : e8b10b_k.sv
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
// PURPOSE  : 8b10b Encoder Komma Character - Stage 2
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

module e8b10b_k (
  input            clk_i,
  input      [7:0] d_i,
  input            k_i,

  output reg       kerr_o,
  output reg [5:0] k6_o,
  output reg [3:0] k4_o,
  output reg       kflip_o
);

parameter k28_0 = 8'b000_11100;
parameter k28_1 = 8'b001_11100;
parameter k28_2 = 8'b010_11100;
parameter k28_3 = 8'b011_11100;
parameter k28_4 = 8'b100_11100;
parameter k28_5 = 8'b101_11100;
parameter k28_6 = 8'b110_11100;
parameter k28_7 = 8'b111_11100;
parameter k23_7 = 8'b111_10111;
parameter k27_7 = 8'b111_11011;
parameter k29_7 = 8'b111_11101;
parameter k30_7 = 8'b111_11110;
parameter err   = 8'b111_11111; //10B_ERR

// generate kerr
always @(posedge clk_i)
  if (!k_i) kerr_o <= 1'b0;
  else 
    (* synthesis, parallel_case *)
    case (d_i)
      k28_0:   kerr_o <= 1'b0;
      k28_1:   kerr_o <= 1'b0;
      k28_2:   kerr_o <= 1'b0;
      k28_3:   kerr_o <= 1'b0;
      k28_4:   kerr_o <= 1'b0;
      k28_5:   kerr_o <= 1'b0;
      k28_6:   kerr_o <= 1'b0;
      k28_7:   kerr_o <= 1'b0;
      k23_7:   kerr_o <= 1'b0;
      k27_7:   kerr_o <= 1'b0;
      k29_7:   kerr_o <= 1'b0;
      k30_7:   kerr_o <= 1'b0;
      err  :   kerr_o <= 1'b0; //10B_ERR
      default: kerr_o <= 1'b1;
    endcase 

// generate 6b K value (assume negative disparity)
always @(posedge clk_i)
  (* synthesis, full_case, parallel_case *)
  case (d_i[4:0])
    5'd23: k6_o <= 6'b010111;
    5'd27: k6_o <= 6'b011011;
    5'd28: k6_o <= 6'b111100;
    5'd29: k6_o <= 6'b011101;
    5'd30: k6_o <= 6'b011110;
    5'd31: k6_o <= 6'b111100; //10B_ERR
  endcase

// generate 4b K value (assume negative disparity)
always @(posedge clk_i)
  if (d_i[4:0] == 5'd31) k4_o <= 4'b1000; //10B_ERR
  else
  (* synthesis, parallel_case *)
  case (d_i[7:5])
    3'h0: k4_o <= 4'b0010;
    3'h1: k4_o <= 4'b1001;
    3'h2: k4_o <= 4'b1010;
    3'h3: k4_o <= 4'b1100;
    3'h4: k4_o <= 4'b0100;
    3'h5: k4_o <= 4'b0101;
    3'h6: k4_o <= 4'b0110;
    3'h7: k4_o <= 4'b0001;
  endcase

// generate flip signal for K characters
always @(posedge clk_i)
  (* synthesis, parallel_case *)
  case (d_i)
    k28_1:   kflip_o <= 1'b1;
    k28_2:   kflip_o <= 1'b1;
    k28_3:   kflip_o <= 1'b1;
    k28_5:   kflip_o <= 1'b1;
    k28_6:   kflip_o <= 1'b1;
    default: kflip_o <= 1'b0;
  endcase

endmodule

`pragma protect end
