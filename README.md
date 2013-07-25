XMOS Minimal Ethernet Board
===========================

XMOS XS1-L1 board with TI DP83848 Ethernet PHY
----------------------------------------------

This is a prototype board for the
Texas Instruments (Formerly National Semiconductor) DP83848C Ethernet PHY.

http://www.ti.com/product/dp83848c

The main advantage of this PHY over the SMSC LANx products
used in XMOS reference designs is that it is also available
in an easy to solder LQFP-48 package.

To use the PHY the following has to be changed in 
the ethernet module supplied by XMOS: module_ethernet\src\server\eth_phy.xc:

#define PHY_ID 0x8001
#define PHY_ADDRESS 0x01 (depends on the hardware design, 0x01 is for this board)

It is likely that the TI TLK110 PHY can also be used on this design,
they are pin compatible I believe, but I have yet to confirm it.

Please note that the pictures (except the 3D render) in the images folder
are from an earlier board revision.
