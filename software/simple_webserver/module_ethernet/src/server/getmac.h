// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*************************************************************************
 *
 * Ethernet MAC Layer Implementation
 * IEEE 802.3 Device MAC Address
 *
 *
 *
 * Retreives three bytes of MAC address from OTP.
 *
 *************************************************************************/

#ifndef _getmac_h_
#define _getmac_h_

#ifdef __XC__
/** Retrieves least significant 24bits from MAC address stored in OTP.
 *
 *  \param otp_data Data port connected to otp
 *  \param otp_addr Address port connected to otp
 *  \param otp_ctrl Control port connected to otp
 *  \param macaddr Array to be filled with the retrieved MAC address
 *
 **/
void ethernet_getmac_otp(port otp_data, out port otp_addr, port otp_ctrl, char macaddr[]);
#endif

#endif
