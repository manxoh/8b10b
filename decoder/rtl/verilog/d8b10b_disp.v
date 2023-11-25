/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Disparity Block                                               //
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
// FILE NAME      : d8b10b_disp.sv
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
// PURPOSE  : 8b10b Decoder Disparity - Stage 1
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

module d8b10b_disp (
  input            clk_i,
  input            rstn_i,
  input      [9:0] d_i,

  output reg       pd6c_o,
  output reg       nd6c_o,
  output reg       pd4c_o,
  output reg       nd4c_o,
  output reg       pd6e_o,
  output reg       nd6e_o,
  output reg       pd4e_o,
  output reg       nd4e_o
);

/*
 positive disparity 6
*/
reg pd6;
always @(d_i)
  (* synthesis, parallel_case *)
  casex (d_i[5:0])
    6'b??1111: pd6 <= 1'b1;
    6'b?1?111: pd6 <= 1'b1;
    6'b?11?11: pd6 <= 1'b1;
    6'b?111?1: pd6 <= 1'b1;
    6'b?1111?: pd6 <= 1'b1;
    6'b1??111: pd6 <= 1'b1;
    6'b1?1?11: pd6 <= 1'b1;
    6'b1?11?1: pd6 <= 1'b1;
    6'b1?111?: pd6 <= 1'b1;
    6'b11??11: pd6 <= 1'b1;
    6'b11?1?1: pd6 <= 1'b1;
    6'b11?11?: pd6 <= 1'b1;
    6'b111??1: pd6 <= 1'b1;
    6'b111?1?: pd6 <= 1'b1;
    6'b1111??: pd6 <= 1'b1;
    default  : pd6 <= 1'b0;
  endcase


// exception for RD generation 
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) pd6c_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[5:0])
    6'b111000: pd6c_o <= 1'b1;
    default  : pd6c_o <= pd6;
  endcase

// exception for RD error checking
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) pd6e_o <= 1'b0;
  else
//  (* synthesis parallel_case *)
  case (d_i[5:0])
    6'b000111: pd6e_o <= 1'b1;
    default  : pd6e_o <= pd6;
  endcase

/*
 negative disparity 6
*/
reg nd6;
always @(d_i)
  (* synthesis, parallel_case *)
  casex (d_i[5:0])
    6'b??0000: nd6 <= 1'b1;
    6'b?0?000: nd6 <= 1'b1;
    6'b?00?00: nd6 <= 1'b1;
    6'b?000?0: nd6 <= 1'b1;
    6'b?0000?: nd6 <= 1'b1;
    6'b0??000: nd6 <= 1'b1;
    6'b0?0?00: nd6 <= 1'b1;
    6'b0?00?0: nd6 <= 1'b1;
    6'b0?000?: nd6 <= 1'b1;
    6'b00??00: nd6 <= 1'b1;
    6'b00?0?0: nd6 <= 1'b1;
    6'b00?00?: nd6 <= 1'b1;
    6'b000??0: nd6 <= 1'b1;
    6'b000?0?: nd6 <= 1'b1;
    6'b0000??: nd6 <= 1'b1;
    default  : nd6 <= 1'b0;
  endcase

// exception for RD generation
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) nd6c_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[5:0])
    6'b000111: nd6c_o <= 1'b1;
    default  : nd6c_o <= nd6;
  endcase
                                                                                                                                    
// exception for RD error checking
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) nd6e_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[5:0])
    6'b111000: nd6e_o <= 1'b1;
    default  : nd6e_o <= nd6;
  endcase

/*
 positive disparity 4
*/
reg pd4;
always @(d_i)
  (* synthesis, parallel_case *)
  casex (d_i[9:6])
    4'b?111: pd4 <= 1'b1;
    4'b1?11: pd4 <= 1'b1;
    4'b11?1: pd4 <= 1'b1;
    4'b111?: pd4 <= 1'b1;
    default: pd4 <= 1'b0;
  endcase

// exception for RD generation
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) pd4c_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b1100: pd4c_o <= 1'b1;
    default: pd4c_o <= pd4;
  endcase
                                                                                                                                    
// exception for RD error checking
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) pd4e_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b0011: pd4e_o <= 1'b1;
    default: pd4e_o <= pd4;
  endcase

/*
 negative disparity 4
*/
reg nd4;
always @(d_i)
  (* synthesis, parallel_case *)
  casex (d_i[9:6])
    4'b?000: nd4 <= 1'b1;
    4'b0?00: nd4 <= 1'b1;
    4'b00?0: nd4 <= 1'b1;
    4'b000?: nd4 <= 1'b1;
    default: nd4 <= 1'b0;
  endcase

// exception for RD generation
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) nd4c_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b0011: nd4c_o <= 1'b1;
    default: nd4c_o <= nd4;
  endcase
                                                                                                                                    
// exception for RD error checking
always @(posedge clk_i, negedge rstn_i)
  if (!rstn_i) nd4e_o <= 1'b0;
  else
  (* synthesis, parallel_case *)
  case (d_i[9:6])
    4'b1100: nd4e_o <= 1'b1;
    default: nd4e_o <= nd4;
  endcase

endmodule

`pragma protect end

