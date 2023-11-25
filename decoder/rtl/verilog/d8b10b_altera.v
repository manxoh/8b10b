/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
//   Altera Wrapper                                                //
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
// FILE NAME      : d8b10b_altera.sv
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
// PURPOSE  : 8b10b Decoder Altera Wrapper
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
//   Instantiations      : d8b10b_top 
//   Synthesizable (y/n) : Yes
//   Other               :                                         
// -FHDR-------------------------------------------------------------


module d8b10b_altera (
  input        clk,
  input        reset_n,
  input        ena,
  input        idle_del,
  input  [9:0] datain,
  input        rdin,
  input        rdforce,
  output       kout,
  output       kerr,
  output [7:0] dataout,
  output       valid,
  output       rdout,
  output       rdcascade,
  output       rderr
);

wire       k28_5;
reg        didle_del;


// hookup encoder module
d8b10b_top dec (
  .clk_i     ( clk       ),
  .rstn_i    ( reset_n   ),
  .ena_i     ( ena       ),
  .d_i       ( datain    ),
  .rd_i      ( rdin      ),
  .rdf_i     ( rdforce   ),
  .d_o       ( dataout   ),
  .k_o       ( kout      ),
  .k28_5_o   ( k28_5     ),
  .cerr_o    ( kerr      ),
  .rdcasc_o  ( rdcascade ),
  .rd_o      ( rdout     ),
  .rderr_o   ( rderr     )
);

// delay idle_del
always @(posedge clk, negedge reset_n)
  if   (!reset_n) didle_del <= 1'b0;
  else            didle_del <= idle_del;

 
// generate valid
reg [1:0] ivalid;
always @(posedge clk, negedge reset_n)
  if   (!reset_n) ivalid <= 3'h0;
  else            ivalid <= {ivalid[0] & ~(k28_5 & didle_del), ena};

assign valid = ivalid[1];

endmodule


