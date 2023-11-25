/////////////////////////////////////////////////////////////////////
//   ,------.                    ,--.                ,--.          //
//   |  .--. ' ,---.  ,--,--.    |  |    ,---. ,---. `--' ,---.    //
//   |  '--'.'| .-. |' ,-.  |    |  |   | .-. | .-. |,--.| .--'    //
//   |  |\  \ ' '-' '\ '-'  |    |  '--.' '-' ' '-' ||  |\ `--.    //
//   `--' '--' `---'  `--`--'    `-----' `---' `-   /`--' `---'    //
//                                             `---'               //
//   8b10b Decoder                                                 //
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


module testbench_top; 

  //-------------------------------------------------------
  //
  // Variables
  //
  reg clk, rstn;

  reg  [9:0] di;
  reg        enai, rdi, rdfi;

  wire       ko_dut;
  wire       cerr_dut;
  wire [7:0] do_dut;
  wire       rdo_dut;
  wire       rdcasc_dut;
  wire       rderr_dut;

  reg        ko_ref;
  reg        k28_5_ref;
  reg        cerr_ref;
  reg  [7:0] do_ref;
  reg        rdo_ref;
  reg        rdcasc_ref;
  reg        rderr_ref;


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
    $display ("- 8b10b Decoder Testbench ---------------  `---'  ----------");
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
    $display ("- 8b10b Decoder Testbench ---------------  `---'  ----------");
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
  d8b10b_top dut (
    .clk_i     ( clk        ), 
    .rstn_i    ( rstn       ), 
    .ena_i     ( enai       ),
    .d_i       ( di         ),
    .rd_i      ( rdi        ),
    .rdf_i     ( rdfi       ),
    .k_o       ( ko_dut     ),
    .k28_5_o   ( k28_5_dut  ),
    .cerr_o    ( cerr_dut   ),
    .d_o       ( do_dut     ),
    .rd_o      ( rdo_dut    ),
    .rdcasc_o  ( rdcasc_dut ),
    .rderr_o   ( rderr_dut  )); 


  //Hookup checker
  decoder_check checker_inst (
    .clk        ( clk         ),
    .rstn       ( rstn        ),
    .di         ( di          ),
    .rdi        ( rdi         ),
    .rdfi       ( rdfi        ),
    .ko_dut     ( ko_dut      ),
    .ko_ref     ( ko_ref      ),
    .k28_5_dut  ( k28_5_dut   ),
    .k28_5_ref  ( k28_5_ref   ),
    .cerr_dut   ( cerr_dut    ),
    .cerr_ref   ( cerr_ref    ),
    .do_dut     ( do_dut      ),
    .do_ref     ( do_ref      ),
    .rdo_dut    ( rdo_dut     ),
    .rdo_ref    ( rdo_ref     ),
    .rderr_dut  ( rderr_dut   ),
    .rderr_ref  ( rderr_ref   ),
    .rdcasc_dut ( rdcasc_dut  ),
    .rdcasc_ref ( rdcasc_ref  ));


  initial
  begin
      clk   = 0;
      enai  = 0;
      di    = 10'h3ff;
      rdfi  = 0;

`ifdef WAVES
      $shm_open("waves");
      $shm_probe("AS",testbench,"AS");
      $display("INFO: Signal dump enabled ...\n\n");
`endif

    welcome_msg();
    tst_simple;
    tst_rnd;
    goodbye_msg();

    $finish;
  end		

`include "tests.v"
endmodule



  //-------------------------------------------------------
  //
  // Checker body
  //
module decoder_check (
  input       clk,
  input       rstn,
  input [9:0] di,
  input       rdi, rdfi,
  input       ko_dut    , ko_ref,
  input       k28_5_dut , k28_5_ref,
  input       cerr_dut  , cerr_ref,
  input [7:0] do_dut    , do_ref,
  input       rdo_dut   , rdo_ref,
  input       rderr_dut , rderr_ref,
  input       rdcasc_dut, rdcasc_ref
);

  //-------------------------------------------------------
  //
  // Variables
  //
  integer good, bad, ugly;

  reg [2:0][9:0] ddi;
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
      drdi  <= {drdi ,rdi};
      drdfi <= {drdfi,rdfi};
  end


  always @(posedge clk or negedge rstn)
    if (rstn)
    begin
        // check outputs
        if (ko_dut !== ko_ref) begin
          $display ("k_o mismatch dut=%0b, ref=%0b", ko_dut, ko_ref);
          bad++; ugly++;
        end
        else good++;

        if (k28_5_dut !== k28_5_ref) begin
          $display ("k28_5_o mismatch dut=%0b, ref=%0b", k28_5_dut, k28_5_ref);
          bad++; ugly++;
        end
        else good++;

        if (cerr_dut !== cerr_ref) begin
          $display ("cerr_o mismatch dut=%0b, ref=%0b", cerr_dut, cerr_ref);
          bad++; ugly++;
        end
        else good++;

        if (do_dut !== do_ref) begin
          $display ("d_o mismatch dut=%b, ref=%b", do_dut, do_ref);
          bad++; ugly++;
        end
        else good++;

        if (rdo_dut !== rdo_ref) begin
          $display ("rd_o mismatch dut=%0b, ref=%0b", rdo_dut, rdo_ref);
          bad++; ugly++;
        end
        else good++;

        if (rderr_dut !== rderr_ref) begin
          $display ("rderr_o mismatch dut=%0b, ref=%0b", rderr_dut, rderr_ref);
          bad++; ugly++;
        end
        else good++;

        if (rdcasc_dut !== rdcasc_ref) begin
          $display ("rdcasc_o mismatch dut=%0b, ref=%0b", rdcasc_dut, rdcasc_ref);
          bad++; ugly++;
        end
        else good++;

/*
        $display ("di:%0x rdi:%0b rdfi:%0b @%0t\n",
           ddi[2], drdi[2], drdfi[2], $time);
*/

        if (bad > 20)
        begin
            $display("\n\n");
            $display("*****************************************************");
            $display("* 8b10b decoder test bench ");
            $display("* More than 20 errors detected, testbench stopped");
            $display("*****************************************************");
            $display("\n");
            $finish;
        end
    end
endmodule
