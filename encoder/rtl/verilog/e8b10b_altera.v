/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Altera Wrapper                                               //
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
// FILE NAME      : e8b10b_altera.sv
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
// PURPOSE  : 8b10b Encoder Altera Wrapper
// ------------------------------------------------------------------
// PARAMETERS
//  NONE
// ------------------------------------------------------------------
// REUSE ISSUES 
//   Reset Strategy      : external asynchronous active low; reset_n
//   Clock Domains       : 1, clk, rising edge
//   Critical Timing     : 
//   Test Features       : na
//   Asynchronous I/F    : no
//   Scan Methodology    : na
//   Instantiations      : e8b10b_top
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


module e8b10b_altera (
  input        clk,
  input        reset_n,
  input        kin,
  input        ena,
  input        idle_ins,
  input  [7:0] datain,
  input        rdin,
  input        rdforce,
  output       kerr,
  output [9:0] dataout,
  output       valid,
  output       rdout,
  output       rdcascade
);

// wires and regs
wire [7:0] d_i;
wire       k_i;
wire       ena_i;


// generate K28.5 when ena=0 and idle_ins=1
assign ena_i = ena | idle_ins;
assign d_i   = ena ? datain : 8'b101_11100; //K28.5 when ena is negated
assign k_i   = ena ? kin    : idle_ins;
 

// hookup encoder module
e8b10b_top enc (
  .clk_i     ( clk       ),
  .rstn_i    ( reset_n   ),
  .ena_i     ( ena_i     ),
  .k_i       ( k_i       ),
  .d_i       ( d_i       ),
  .rd_i      ( rdin      ),
  .rdf_i     ( rdforce   ),
  .d_o       ( dataout   ),
  .kerr_o    ( kerr      ),
  .rdcasc_o  ( rdcascade ),
  .rd_o      ( rdout     )
);

// generate valid
reg [2:0] ivalid;
always @(posedge clk, negedge reset_n)
  if (!reset_n) ivalid <= 3'h0;
  else          ivalid <= {ivalid[1:0], ena | idle_ins};

assign valid = ivalid[2];

endmodule


