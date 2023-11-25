/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Data Block                                                    //
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
// FILE NAME      : d8b10b_b.sv
// DEPARTMENT     :
// AUTHOR         : rherveille
// AUTHOR'S EMAIL :
// ------------------------------------------------------------------
// RELEASE HISTORY
// VERSION DATE        AUTHOR      DESCRIPTION
// 1.0     20-12-2014  rherveille  initial release
// ------------------------------------------------------------------
// KEYWORDS : 8b10b decoder
// ------------------------------------------------------------------
// PURPOSE  : 8b10b Decoder Data Block - Stage 1
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

module d8b10b_b (
  input            clk_i,
  input            rstn_i,
  input            ena_i,
  input      [9:0] d_i,

  output reg       k_o,
  output reg       k28_5_o,
  output reg [4:0] b5_o,
  output reg [2:0] b3_o
);

// generate command byte (k_o)
always @(posedge clk_i, negedge rstn_i)
  if      (!rstn_i) k_o <= 1'b0;
  else if (!ena_i ) k_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  casex (d_i)
    10'b????_1111??: k_o <= 1'b1; //k28.x n
    10'b????_0000??: k_o <= 1'b1; //k28.x p
    10'b0001_?1????: k_o <= 1'b1; //kx.7 n
    10'b1110_?0????: k_o <= 1'b1; //Kx.7 p
    default: k_o <= 1'b0;
  endcase
                                                                                                                                            
// generate K28.5 signal
always @(posedge clk_i)
  (* synthesis, parallel_case *)
  case (d_i)
    10'b0101_111100: k28_5_o <= 1'b1;
    10'b1010_000011: k28_5_o <= 1'b1;
    default: k28_5_o <= 1'b0;
  endcase

// generate FGH
wire kp = ~|d_i[5:2];
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) b3_o <= 3'b000;
  else 
    (* synthesis, parallel_case *)
    case (d_i[9:6])
      4'b0010: b3_o <= 3'd0; //k n, d n
      4'b1101: b3_o <= 3'd0; //k p, d p
      4'b1001: b3_o <= kp ? 3'd6 : 3'd1; //(k p) k n, d np
      4'b1010: b3_o <= kp ? 3'd5 : 3'd2; //(k p) k n, d np
      4'b1100: b3_o <= 3'd3; //k n, d n
      4'b0011: b3_o <= 3'd3; //k p, d p
      4'b0100: b3_o <= 3'd4; //k n, d n
      4'b1011: b3_o <= 3'd4; //k p, d p
      4'b0101: b3_o <= kp ? 3'd2 : 3'd5; //(k p) k n, d np
      4'b0110: b3_o <= kp ? 3'd1 : 3'd6; //(k p) k n, d np
      4'b1000: b3_o <= 3'd7; //d n
      4'b0111: b3_o <= 3'd7; //d p
      4'b0001: b3_o <= 3'd7; //k n
      4'b1110: b3_o <= 3'd7; //k p
      default: b3_o <= 3'd0;
    endcase

// generate ABCDE
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) b5_o <= 5'b00000;
  else
  (* synthesis, parallel_case *)
  case (d_i[5:0])
    6'b111001: b5_o <= 5'd0;  //n
    6'b000110: b5_o <= 5'd0;  //p
    6'b101110: b5_o <= 5'd1;  //n
    6'b010001: b5_o <= 5'd1;  //p
    6'b101101: b5_o <= 5'd2;  //n
    6'b010010: b5_o <= 5'd2;  //p
    6'b100011: b5_o <= 5'd3;  //np
    6'b101011: b5_o <= 5'd4;  //n
    6'b010100: b5_o <= 5'd4;  //p
    6'b100101: b5_o <= 5'd5;  //np
    6'b100110: b5_o <= 5'd6;  //np
    6'b000111: b5_o <= 5'd7;  //n
    6'b111000: b5_o <= 5'd7;  //p
    6'b100111: b5_o <= 5'd8;  //n
    6'b011000: b5_o <= 5'd8;  //p
    6'b101001: b5_o <= 5'd9;  //np
    6'b101010: b5_o <= 5'd10; //np
    6'b001011: b5_o <= 5'd11; //np
    6'b101100: b5_o <= 5'd12; //np
    6'b001101: b5_o <= 5'd13; //np
    6'b001110: b5_o <= 5'd14; //np
    6'b111010: b5_o <= 5'd15; //n
    6'b000101: b5_o <= 5'd15; //p
    6'b110110: b5_o <= 5'd16; //n
    6'b001001: b5_o <= 5'd16; //p
    6'b110001: b5_o <= 5'd17; //np
    6'b110010: b5_o <= 5'd18; //np
    6'b010011: b5_o <= 5'd19; //np
    6'b110100: b5_o <= 5'd20; //np
    6'b010101: b5_o <= 5'd21; //np
    6'b010110: b5_o <= 5'd22; //np
    6'b010111: b5_o <= 5'd23; //n, k n
    6'b101000: b5_o <= 5'd23; //p, k n
    6'b110011: b5_o <= 5'd24; //n
    6'b001100: b5_o <= 5'd24; //p
    6'b011001: b5_o <= 5'd25; //np
    6'b011010: b5_o <= 5'd26; //np
    6'b011011: b5_o <= 5'd27; //n, k n
    6'b100100: b5_o <= 5'd27; //p, k n
    6'b011100: b5_o <= 5'd28; //np
    6'b111100: b5_o <= 5'd28; //k n
    6'b000011: b5_o <= 5'd28; //k p
    6'b011101: b5_o <= 5'd29; //n, k n
    6'b100010: b5_o <= 5'd29; //p, k p
    6'b011110: b5_o <= 5'd30; //n, k n
    6'b100001: b5_o <= 5'd30; //p, k p
    6'b110101: b5_o <= 5'd31; //n
    6'b001010: b5_o <= 5'd31; //p
    default  : b5_o <= 5'd0;
  endcase

endmodule

`pragma protect end

