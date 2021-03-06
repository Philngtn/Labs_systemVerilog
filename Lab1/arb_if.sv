interface arb_if(input bit clk); 

// LAB: Add signal definitions
  bit reset;
  logic [1:0] grant, request;

  modport DUT (input request, reset,
               output grant);
  
// LAB: Add Clocking block for synchronous signals
  clocking cb @(posedge clk);
    output request;
    input grant;
  endclocking
    
    
endinterface


