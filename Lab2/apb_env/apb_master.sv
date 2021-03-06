/***************************************************************************
 *
 * File:        $RCSfile: apb_master.sv,v $
 * Revision:    $Revision: 1.8 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Basic Transaction Verification Module aimed at
 * creating read() and write() transactions based
 * on APB management Interface
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */

`include "apb_env/apb_trans.sv"

class apb_master;

    // APB Transaction mailboxes
    mailbox #(apb_trans) apb_mbox;

    // Verbosity level
    bit verbose;
  
    // Constructor
    // LAB: Construct a new master with the mailbox connection and verbosity bit
	  function new(mailbox #(apb_trans)apb_mbox, bit verbose=0);
   
     this.apb_mbox = apb_mbox;
     this.verbose = verbose;       
     
    endfunction;
        
    // Main daemon. Runs forever to switch APB transaction to
    // corresponding read/write/idle command
    task main();
       apb_trans tr;

       if(verbose)
         $display($time, ": Starting apb_master");

       // LAB: Create a loop to run forever.  It gets a transaction out of the mailbox,
       // decodes it, and executes with the tasks read(), write(), and idle()
       forever begin
    
         // LAB: Get a transaction
         tr = apb_mbox.copy();
        
         // LAB: Decode the incoming transaction
         if(tr.transaction == "READ")
            read(tr);
         else if(tr.transaction == "WRITE")
            write(tr);
         else if(tr.transaction == "IDLE")
            idle();
        
         // LAB: Print the transaction: verbose should be on
          
        
        end //End of loop
         
       if(verbose)
         $display($time, ": Ending apb_master");

    endtask: main


    // Method to reset the DUT then going to active mode
    task reset();
      apb.cb.Rst <= 0;
      idle();
      #5 apb.cb.Rst <= 1;
   endtask: reset


    // Method to put the APB Bus in idle mode
    task idle();
      apb.cb.PAddr   <= 0;
      apb.cb.PSel    <= 0;
      apb.cb.PWData  <= 0;
      apb.cb.PEnable <= 0;
      apb.cb.PWrite  <= 0;
      #1 apb.cb.PWrite  <= 0;
   endtask: idle


   // Implementation of the read() method
   //    - drives the address bus,
   //    - select the  bus,
   //    - assert Penable signal,
   //    - read the data and return it.
   task read(apb_trans tr);
     // Drive Control bus
     apb.cb.PAddr  <= tr.addr;
     apb.cb.PWrite <= 1'b0;
     apb.cb.PSel   <= 1'b1;

     // Assert Penable
     #1 apb.cb.PEnable <= 1'b1;

     // Deassert Penable & return the read data
     #1 apb.cb.PEnable <= 1'b0;
     tr.data = apb.cb.PRData;

    // Check the transaction
    check_read(tr);
  endtask: read
        

  // Perform a write cycle
   //    - Drive the address bus,
   //    - Select the  bus,
   //    - Drive data bus
   //    - Assert Penable signal,
  task write(apb_trans tr);
     // Drive Control bus
     apb.cb.PAddr  <= tr.addr;
     apb.cb.PWData <= tr.data;
     apb.cb.PWrite <= 1'b1;
     apb.cb.PSel   <= 1'b1;

     // Assert Penable
     #1 apb.cb.PEnable <= 1'b1;

     // Deassert it
     #1 apb.cb.PEnable <= 1'b0;

    // Check the transaction
    check_write(tr);
  endtask: write


  function void check_read (apb_trans tr);
  apb_data_t mem_data;
  mem_data = $root.top.m1.memory_read(tr.addr);
  if (tr.data == mem_data)
    begin
      if (verbose)
        $display("@%0d: Success: Read bus data (%h) matches memory data", 
                 $time, tr.data);
      end
  else
    $display("@%0d: ERROR: Read bus data (%h) does not match memory data (%h)", 
             $time, tr.data, mem_data);
  endfunction


  function void check_write (apb_trans tr);
  apb_data_t mem_data;
  mem_data = $root.top.m1.memory_read(tr.addr);
  if (tr.data == mem_data)
    begin
      if (verbose)
        $display("%d: Success: Write transaction data (%h) matches memory data", 
                 $time, tr.data);
      end
  else
    $display("%d: ERROR: Write transaction data (%h) does not match memory data (%h)", 
             $time, tr.data, mem_data);
  endfunction

endclass: apb_master
