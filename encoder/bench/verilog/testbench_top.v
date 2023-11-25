/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Encoder                                                 //
//   Testbench Top Level                                           //
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
// PURPOSE  : 8b10b Decoder Invalid Character Check
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


module testbench_top; 

  //-------------------------------------------------------
  //
  // Variables
  //
  reg clk, rstn;

  reg  [7:0] di;
  reg        ki, enai, rdi, rdfi;
  reg        kerr_ref;
  reg  [9:0] do_ref;
  reg        rdo_ref;
  reg        rdcasc_ref;

  wire       kerr_dut;
  wire [9:0] do_dut;
  wire       rdo_dut;
  wire       rdcasc_dut;

  integer total_error;
  wire [31:0] error;


  //-------------------------------------------------------
  //
  // Tasks
  //

  task welcome_msg();
    $display("\n\n");
    $display ("------------------------------------------------------------");
    $display (" ,------.                    ,--.                ,--.       ");
    $display (" |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---. ");
    $display (" |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--' ");
    $display (" |  |\\  \\ ' '-' '\\ '-'  |    |  '--.' '-' ' '-' ||  |\\ `--. ");
    $display (" `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---' ");
    $display ("- 8b10b Encoder Testbench ---------------  `---'  ----------");
    $display ("-------------------------------------------------------------");
    $display ("\n");
  endtask

  task goodbye_msg();
    $display("\n\n");
    $display ("------------------------------------------------------------");
    $display (" ,------.                    ,--.                ,--.       ");
    $display (" |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---. ");
    $display (" |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--' ");
    $display (" |  |\\  \\ ' '-' '\\ '-'  |    |  '--.' '-' ' '-' ||  |\\ `--. ");
    $display (" `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---' ");
    $display ("- 8b10b Encoder Testbench ---------------  `---'  ----------");
    $display ("-------------------------------------------------------------");
    $display ("  Regression test complete");
    $display ("  Status = %s", checker_inst.ugly ? "FAILED" : "PASSED");
    $display ("-------------------------------------------------------------");
  endtask

  task test_done();
    $display ("Test done. Checks good=%0d. Checks bad=%0d. Checks ugly=%0d", checker_inst.good, checker_inst.bad, checker_inst.ugly);
  endtask

  task reset_error_counters();
    checker_inst.reset_counters();
  endtask

  //-------------------------------------------------------
  //
  // Testbench body
  //
  
  always #5 clk = ~clk;
  
  //Hookup Device Under Test
  e8b10b_top dut (
    .clk_i     ( clk        ), 
    .rstn_i    ( rstn       ), 
    .k_i       ( ki         ),
    .ena_i     ( enai       ),
    .d_i       ( di         ),
    .rd_i      ( rdi        ),
    .rdf_i     ( rdfi       ),
    .kerr_o    ( kerr_dut   ),
    .d_o       ( do_dut     ),
    .rd_o      ( rdo_dut    ),
    .rdcasc_o  ( rdcasc_dut )); 


  //Hookup checker
  check checker_inst (
    .rstn       ( rstn        ),
    .clk        ( clk         ),
    .enai       ( enai        ),
    .ki         ( ki          ),
    .di         ( di          ),
    .rdi        ( rdi         ),
    .rdfi       ( rdfi        ),
    .kerr_dut   ( kerr_dut    ),
    .kerr_ref   ( kerr_ref    ),
    .do_dut     ( do_dut      ),
    .do_ref     ( do_ref      ),
    .rdo_dut    ( rdo_dut     ),
    .rdo_ref    ( rdo_ref     ),
    .rdcasc_dut ( rdcasc_dut  ),
    .rdcasc_ref ( rdcasc_ref  ));


initial
begin
    clk  = 0;
    enai = 0;
    rdfi = 0;

    kerr_ref   = 0;
    rdo_ref    = 0;
    rdcasc_ref = 0;
    do_ref     = 0;

`ifdef WAVES
    $shm_open("waves");
    $shm_probe("AS",testbench,"AS");
    $display("INFO: Signal dump enabled ...\n\n");
`endif

  welcome_msg();
  tst_enc;
  tst_k;
  tst_full;
  goodbye_msg();

  $finish;
end		

`include "tests.v"
endmodule





module check (
  input            rstn,
  input            clk,
  input      [7:0] di,
  input            enai, ki, rdi, rdfi,
  input            kerr_dut  , kerr_ref,
  input      [9:0] do_dut    , do_ref,
  input            rdo_dut   , rdo_ref,
  input            rdcasc_dut, rdcasc_ref
);

  //-------------------------------------------------------
  //
  // Variables
  //
  integer good, bad, ugly;

  reg [2:0][7:0] ddi;
  reg [2:0]      denai;
  reg [2:0]      dki;
  reg [2:0]      drdi;
  reg [2:0]      drdfi;

  //-------------------------------------------------------
  //
  // Tasks
  //
  task reset_counters();
    good = 0;
    bad  = 0;
  endtask

  //-------------------------------------------------------
  //
  // Checker body
  //
  initial
  begin
      reset_counters();
      ugly = 0;
  end


  always @(posedge clk)
    begin
        ddi   <= {ddi  ,di};
        denai <= {denai,enai};
        dki   <= {dki  ,ki};
        drdi  <= {drdi ,rdi};
        drdfi <= {drdfi,rdfi};
    end

  always @(posedge clk, negedge rstn)
    if (rstn)
    begin
        // check outputs
        if (kerr_dut !== kerr_ref) begin
          $display ("kerr_o mismatch dut=%0b, ref=%0b", kerr_dut, kerr_ref);
          bad++; ugly++;
        end
        else good++;

        if (do_dut !== do_ref) begin
          $display ("d_o mismatch dut=%x, ref=%x", do_dut, do_ref);
          bad++; ugly++;
        end
        else good++;

        if (rdo_dut !== rdo_ref) begin
          $display ("rd_o mismatch dut=%0b, ref=%0b", rdo_dut, rdo_ref);
          bad++; ugly++;
        end
        else good++;

        if (rdcasc_dut !== rdcasc_ref) begin
          $display ("rdcasc_o mismatch dut=%0b, ref=%0b", rdcasc_dut, rdcasc_ref);
          bad++; ugly++;
        end
        else good++;

/*
        if (dki[2])
          $display ("d_i:%0x (K%0d.%0d) ena_i:%0b k_i:%0b rd_i:%0b rdf_i:%0b @%0t\n", 
              ddi[2], ddi[2][4:0], ddi[2][7:5], denai[2], dki[2], drdi[2], drdfi[2], $time);
        else
          $display ("d_i:%0x (D%0d.%0d) ena_i:%0b k_i:%0b rd_i:%0b rdf_i:%0b @%0t\n",
              ddi[2], ddi[2][4:0], ddi[2][7:5], denai[2], dki[2], drdi[2], drdfi[2], $time);
*/

        if (bad > 20)
        begin
            $display("\n\n");
            $display("*****************************************************");
            $display("* 8b10b encoder test bench ");
            $display("* More than 20 errors detected, testbench stopped");
            $display("*****************************************************");
            $display("\n");
            $finish;
       end
    end       
endmodule
