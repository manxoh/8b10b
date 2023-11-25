/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Invalid Character Check Block                                 //
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
// FILE NAME      : d8b10b_err.sv
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
// PURPOSE  : 8b10b Decoder Invalid Character Check - Stage 1
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

module d8b10b_err (
  input            clk_i,
  input            rstn_i,
  input            ena_i,
  input      [9:0] d_i,

  output reg       cerr_o,
  output reg       kerr_o
);

/*
   invalid command characters check
*/
always @(posedge clk_i)
  (* synthesis, parallel_case *)
  case (d_i)
    // negative disparity
    10'b0010_111100: kerr_o <= 1'b0; //K28.0
    10'b1001_111100: kerr_o <= 1'b0; //K28.1
    10'b1010_111100: kerr_o <= 1'b0; //K28.2
    10'b1100_111100: kerr_o <= 1'b0; //K28.3
    10'b0100_111100: kerr_o <= 1'b0; //K28.4
    10'b0101_111100: kerr_o <= 1'b0; //K28.5
    10'b0110_111100: kerr_o <= 1'b0; //K28.6
    10'b0001_111100: kerr_o <= 1'b0; //K28.7
    10'b0001_010111: kerr_o <= 1'b0; //K23.7
    10'b0001_011011: kerr_o <= 1'b0; //K27.7
    10'b0001_011101: kerr_o <= 1'b0; //K29.7
    10'b0001_011110: kerr_o <= 1'b0; //K30.7

    //positive disparity
    10'b1101_000011: kerr_o <= 1'b0; //K28.0
    10'b0110_000011: kerr_o <= 1'b0; //K28.1
    10'b0101_000011: kerr_o <= 1'b0; //K28.2
    10'b0011_000011: kerr_o <= 1'b0; //K28.3
    10'b1011_000011: kerr_o <= 1'b0; //K28.4
    10'b1010_000011: kerr_o <= 1'b0; //K28.5
    10'b1001_000011: kerr_o <= 1'b0; //K28.6
    10'b1110_000011: kerr_o <= 1'b0; //K28.7
    10'b1110_101000: kerr_o <= 1'b0; //K23.7
    10'b1110_100100: kerr_o <= 1'b0; //K27.7
    10'b1110_100010: kerr_o <= 1'b0; //K29.7
    10'b1110_100001: kerr_o <= 1'b0; //K30.7
    default: kerr_o <= 1'b1;
  endcase

/*
  invalid data characters errors check
*/
reg ce4; //code-error JHGF
always @(d_i[9:6])
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b1101: ce4 <= 1'b0; //Dx.0
    4'b1001: ce4 <= 1'b0; //Dx.1
    4'b1010: ce4 <= 1'b0; //Dx.2
    4'b0011: ce4 <= 1'b0; //Dx.3
    4'b1011: ce4 <= 1'b0; //Dx.4
    4'b0101: ce4 <= 1'b0; //Dx.5
    4'b0110: ce4 <= 1'b0; //Dx.6
    4'b0111: ce4 <= 1'b0; //Dx.7
    default: ce4 <= 1'b1; //Dx.8
  endcase

reg ce4i; //inverted ce4
always @(d_i[9:6])
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b0010: ce4i <= 1'b0; //Dx.0
    4'b1001: ce4i <= 1'b0; //Dx.1
    4'b1010: ce4i <= 1'b0; //Dx.2
    4'b1100: ce4i <= 1'b0; //Dx.3
    4'b0100: ce4i <= 1'b0; //Dx.4
    4'b0101: ce4i <= 1'b0; //Dx.5
    4'b0110: ce4i <= 1'b0; //Dx.6
    4'b1000: ce4i <= 1'b0; //Dx.7
    default: ce4i <= 1'b1; //Dx.8
  endcase 

reg ce4a; //alternative ce4
always @(d_i[9:6])
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b1101: ce4a <= 1'b0; //Dx.0
    4'b1001: ce4a <= 1'b0; //Dx.1
    4'b1010: ce4a <= 1'b0; //Dx.2
    4'b0011: ce4a <= 1'b0; //Dx.3
    4'b1011: ce4a <= 1'b0; //Dx.4
    4'b0101: ce4a <= 1'b0; //Dx.5
    4'b0110: ce4a <= 1'b0; //Dx.6
    4'b1110: ce4a <= 1'b0; //Dx.7
    default: ce4a <= 1'b1; //Dx.8
  endcase

reg ce4ai; //inverted alternative ce4
always @(d_i[9:6])
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b0010: ce4ai <= 1'b0; //Dx.0
    4'b1001: ce4ai <= 1'b0; //Dx.1
    4'b1010: ce4ai <= 1'b0; //Dx.2
    4'b1100: ce4ai <= 1'b0; //Dx.3
    4'b0100: ce4ai <= 1'b0; //Dx.4
    4'b0101: ce4ai <= 1'b0; //Dx.5
    4'b0110: ce4ai <= 1'b0; //Dx.6
    4'b0001: ce4ai <= 1'b0; //Dx.7
    default: ce4ai <= 1'b1; //Dx.8
  endcase

always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) cerr_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[5:0])
    6'b111001: cerr_o <= ce4i        ; //D0.y n
    6'b000110: cerr_o <= ce4         ; //D0.y p
    6'b101110: cerr_o <= ce4i        ; //D1.y n
    6'b010001: cerr_o <= ce4         ; //D1.y p
    6'b101101: cerr_o <= ce4i        ; //D2.y n
    6'b010010: cerr_o <= ce4         ; //D2.y p
    6'b100011: cerr_o <= ce4  & ce4i ; //D3.y n,p
    6'b101011: cerr_o <= ce4i        ; //D4.y n
    6'b010100: cerr_o <= ce4         ; //D4.y p
    6'b100101: cerr_o <= ce4  & ce4i ; //D5.y n,p
    6'b100110: cerr_o <= ce4  & ce4i ; //D6.y n,p
    6'b000111: cerr_o <= ce4         ; //D7.y n
    6'b111000: cerr_o <= ce4i        ; //D7.y p
    6'b100111: cerr_o <= ce4i        ; //D8.y n
    6'b011000: cerr_o <= ce4         ; //D8.y p
    6'b101001: cerr_o <= ce4  & ce4i ; //D9.y n,p
    6'b101010: cerr_o <= ce4  & ce4i ; //D10.y n
    6'b001011: cerr_o <= ce4  & ce4ai; //D11.y n,p
    6'b101100: cerr_o <= ce4  & ce4i ; //D12.y n,p
    6'b001101: cerr_o <= ce4  & ce4ai; //D13.y n,p
    6'b001110: cerr_o <= ce4  & ce4ai; //D14.y n,p
    6'b111010: cerr_o <= ce4i        ; //D15.y n
    6'b000101: cerr_o <= ce4         ; //D15.y
    6'b110110: cerr_o <= ce4i        ; //D16.y n
    6'b001001: cerr_o <= ce4         ; //D16.y
    6'b110001: cerr_o <= ce4a & ce4i ; //D17.y n,p
    6'b110010: cerr_o <= ce4a & ce4i ; //D18.y n,p
    6'b010011: cerr_o <= ce4  & ce4i ; //D19.y n,p
    6'b110100: cerr_o <= ce4a & ce4i ; //D20.y n,p
    6'b010101: cerr_o <= ce4  & ce4i ; //D21.y n,p
    6'b010110: cerr_o <= ce4  & ce4i ; //D22.y n,p
    6'b010111: cerr_o <= ce4i        ; //D23.y n
    6'b101000: cerr_o <= ce4         ; //D23.y
    6'b110011: cerr_o <= ce4i        ; //D24.y n
    6'b001100: cerr_o <= ce4         ; //D24.y
    6'b011001: cerr_o <= ce4  & ce4i ; //D25.y n,p
    6'b011010: cerr_o <= ce4  & ce4i ; //D26.y n,p
    6'b011011: cerr_o <= ce4i        ; //D27.y n
    6'b100100: cerr_o <= ce4         ; //D27.y
    6'b011100: cerr_o <= ce4  & ce4i ; //D28.y n,p
    6'b011101: cerr_o <= ce4i        ; //D29.y n
    6'b100010: cerr_o <= ce4         ; //D29.y
    6'b011110: cerr_o <= ce4i        ; //D30.y n
    6'b100001: cerr_o <= ce4         ; //D30.y
    6'b110101: cerr_o <= ce4i        ; //D31.y n
    6'b001010: cerr_o <= ce4         ; //D31.y
    default  : cerr_o <= 1'b1;
endcase

endmodule

`pragma protect end

