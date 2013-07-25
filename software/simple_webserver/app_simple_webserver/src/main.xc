// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <platform.h>
#include "uip_server.h"
#include "xhttpd.h"
#include "getmac.h"
#include "ethernet_server.h"

#define PORT_ETH_RXCLK  XS1_PORT_1G  
#define PORT_ETH_RXER   XS1_PORT_1F
#define PORT_ETH_RXD    XS1_PORT_4D
#define PORT_ETH_RXDV   XS1_PORT_1E
#define PORT_ETH_TXCLK  XS1_PORT_1I
#define PORT_ETH_TXEN   XS1_PORT_1J
#define PORT_ETH_TXD    XS1_PORT_4E
#define PORT_ETH_MDIO   XS1_PORT_1L
#define PORT_ETH_MDC    XS1_PORT_1K
#define PORT_ETH_RST_N  XS1_PORT_1H

// Ethernet Ports
on stdcore[0]: port otp_data = XS1_PORT_32B; // OTP_DATA_PORT
on stdcore[0]: out port otp_addr = XS1_PORT_16C; // OTP_ADDR_PORT
on stdcore[0]: port otp_ctrl = XS1_PORT_16D; // OTP_CTRL_PORT


on stdcore[0]: clock clk_smi = XS1_CLKBLK_5;

on stdcore[0]: mii_interface_t mii =
{
	XS1_CLKBLK_1,
	XS1_CLKBLK_2,

	PORT_ETH_RXCLK,
	PORT_ETH_RXER,
	PORT_ETH_RXD,
	PORT_ETH_RXDV,

	PORT_ETH_TXCLK,
	PORT_ETH_TXEN,
	PORT_ETH_TXD,
};

#ifdef PORT_ETH_RST_N
on stdcore[0]: out port p_mii_resetn = PORT_ETH_RST_N;
on stdcore[0]: smi_interface_t smi = {PORT_ETH_MDIO, PORT_ETH_MDC, 0};
#else
on stdcore[0]: smi_interface_t smi = {PORT_ETH_RST_N_MDIO, PORT_ETH_MDC, 1};
#endif

// IP Config - change this to suit your network.  Leave with all
// 0 values to use DHCP
xtcp_ipconfig_t ipconfig = {
		{ 192, 168, 2, 2 }, // ip address (eg 192,168,0,2)
		{ 255, 255, 255, 0 }, // netmask (eg 255,255,255,0)
		{ 0, 0, 0, 0 } // gateway (eg 192,168,0,1)
};

on stdcore[0] : out port p_led = XS1_PORT_1P;
#define DELAY_HZ 50000000
void flash_led()
{
  timer t;
  unsigned time;
  while (1) {
    p_led <: 1;
    t :> time;
    time += DELAY_HZ;
    t when timerafter(time) :> void;
    
    
    p_led <: 0;
    t :> time;
    time += DELAY_HZ;
    t when timerafter(time) :> void;
    
  }
}

// Program entry point
int main(void) {
	chan mac_rx[1], mac_tx[1], xtcp[1], connect_status;

	par
	{
		// The ethernet server
		on stdcore[0]:
		{
			int mac_address[2] = { 0x44332211, 0x88776655 };

			phy_init(clk_smi,
#ifdef PORT_ETH_RST_N
					p_mii_resetn,
#else
					null,
#endif
					smi, mii);

			ethernet_server(mii, mac_address,
					mac_rx, 1, mac_tx, 1, smi,
					connect_status);
		}

		// The TCP/IP server thread
		on stdcore[0]: uip_server(mac_rx[0], mac_tx[0],
				xtcp, 1, ipconfig,
				connect_status);

		// The webserver thread
		on stdcore[0]: xhttpd(xtcp[0]);
		on stdcore[0]: flash_led();

	}
	return 0;
}
