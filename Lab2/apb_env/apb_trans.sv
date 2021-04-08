/***************************************************************************
 *
 * File:        $RCSfile: apb_trans.sv,v $
 * Revision:    $Revision: 1.5 $  
 * Date:        $Date: 2003/07/02 15:47:08 $
 *
 *******************************************************************************
 *
 * APB Transaction Structure
 *
 *******************************************************************************
 * Copyright (c) 1991-2005 by Synopsys Inc.  ALL RIGHTS RESERVED.
 * CONFIDENTIAL AND PROPRIETARY INFORMATION OF SYNOPSYS INC.
 *******************************************************************************
 */

`ifndef APB_IF_DEFINE
`define APB_IF_DEFINE

`include "hdl/root.sv"


class apb_trans;
    static int count=0;
    int id, trans_cnt;

    function new;
      id = count++;
    endfunction

// LAB: Create a random address, data, and transaction, 
// using data types defined in hdl/root.v
    rand apb_addr_t addr;
    rand apb_data_t data;
    rand trans_e transaction;

    function void display(string prefix);
      $display("%0d", prefix);
      // LAB: Display the time, transaction's type, address, and data field
      $display("Time: %0t, transction's type=%0d, address=%0h, data=%0h", $time, transaction, addr, data);
    endfunction: display
    
    

  function apb_trans copy();
// LAB: Construct a new() apb_trans and fill it with this's information
// Don't forget to return the handle
      copy = new();
      copy.addr = addr;
      copy.data = data;
      copy.transaction = transaction;
    return copy;
  endfunction: copy
    
endclass

`endif