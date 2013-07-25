// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*************************************************************************
 *
 * Ethernet MAC Layer Implementation
 * IEEE 802.3 MAC Client Interface (Send)
 *
 *
 * This implement Ethernet frame sending client interface.
 *
 *************************************************************************/

#include <xs1.h>
#include <xclib.h>

#ifdef __ethernet_conf_h_exists__
#include "ethernet_conf.h"
#endif

#include "ethernet_server_def.h"
#include "ethernet_tx_client.h"

#pragma unsafe arrays
static void ethernet_send_frame_unify(chanend ethernet_tx_svr, unsigned int Buf[], int count, unsigned int &sentTime, unsigned int Cmd, int ifnum)
{
  int i;
  
  sentTime = 0;

  ethernet_tx_svr <: Cmd;

  // sent the request/count to sent
  
  slave {
    ethernet_tx_svr <: count;
    ethernet_tx_svr <: ifnum;
    for (i=0;i<(count+3)>>2;i++)
      ethernet_tx_svr <: Buf[i];
  }
    

  if (Cmd == ETHERNET_TX_REQ_TIMED) {
    ethernet_tx_svr :> sentTime;
  }
  
  return; 
}


void mac_tx(chanend ethernet_tx_svr, unsigned int Buf[], int count, int ifnum)
{
  unsigned sentTime;
  ethernet_send_frame_unify(ethernet_tx_svr, Buf, count, sentTime, ETHERNET_TX_REQ, ifnum);
  return;
}

#pragma unsafe arrays
void mac_tx_offset2(chanend ethernet_tx_svr, 
                    unsigned int Buf[], 
                    int count, 
                    int ifnum)
{
  ethernet_tx_svr <: ETHERNET_TX_REQ_OFFSET2;

  slave {
    ethernet_tx_svr <: count;
    ethernet_tx_svr <: ifnum;
    for (int i=0;i<(count+7)>>2;i++)
      ethernet_tx_svr <: byterev(Buf[i]);
  }
  return;
}



void mac_tx_timed(chanend ethernet_tx_svr, unsigned int Buf[], int count, unsigned int &sentTime, int ifnum)
{
  ethernet_send_frame_unify(ethernet_tx_svr, Buf, count, sentTime, ETHERNET_TX_REQ_TIMED, ifnum);
  return;
}


int mac_get_macaddr(chanend ethernet_tx_svr, unsigned char Buf[])
{
  int i;

    
  ethernet_tx_svr <: ETHERNET_GET_MAC_ADRS;
   
  master {
    // transfer start of data.
    for (i = 0; i < 6; i++)
      {
         ethernet_tx_svr :> Buf[i];
      }
  }

  return 0;   
}


#ifdef AVB_MAC
void send_avb_1722_router_cmd(chanend c,
                              unsigned key0,
                              unsigned key1,
                              unsigned link,
                              unsigned hash)
{
  c <: ETHERNET_TX_UPDATE_AVB_ROUTER;
  slave {
    c <: key0;
    c <: key1;
    c <: link;
    c <: hash;
  }
}
#endif
