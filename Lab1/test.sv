//`timescale 1ns/1ns

program automatic test (arb_if arbif);

task reset_test();
  begin
   $display("Task reset_test: asserting and checking reset");

  // LAB: Add reset logic  here
   @(negedge arbif.cb)
   arbif.reset = 1;
   arbif.request = 2'b00;
   repeat(2) @(negedge arbif.cb);
   arbif.reset = 0;

  end
endtask


task request_grant_test();

  // Test out bit 0
  $display("Task request_grant_test: asserting and checking reset");
  #100 arbif.cb.request <= 2'b01;
  @arbif.cb;
  @arbif.cb;
  @(arbif.cb) a2: assert (arbif.cb.grant == 2'b01);

  // LAB: Add your grant test here for the rest of the bits
  
  // Test out bit 1
  $display("Task request_grant_test: asserting and checking reset");
  #100 arbif.cb.request <= 2'b10;
  @arbif.cb;
  @arbif.cb;
  @(arbif.cb) a3: assert (arbif.cb.grant == 2'b10);
  
  // Test out 2 bits
  $display("Task request_grant_test: asserting and checking reset");
  #100 arbif.cb.request <= 2'b11;
  @arbif.cb;
  @arbif.cb;
  @(arbif.cb) a4: assert (arbif.cb.grant == 2'b11);

endtask


initial begin
  repeat (10) @arbif.cb;

  reset_test();
  request_grant_test();

  repeat (10) @arbif.cb;
  $finish;

end
endprogram

