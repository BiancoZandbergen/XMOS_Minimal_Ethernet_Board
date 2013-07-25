XCORE.com xTcp SOFTWARE COMPONENT
.................................

:Latest release: 3.0.1rc0
:Maintainer: davidn@xmos.com
:Description: Implementation of uIP TCP/IP stack for XMOS devices. Runs in a single thread.


Key Features
============

   * TCP + UDP connections
   * ICMP
   * DHCP
   * mDNS
   * Example of HTTP server and Telnet
   * TFTP server

Firmware Overview
=================

Multiple threads are used to process IP packets and forward them through a channel to upper layer handlers.

Documentation can be found at http://github.xcore.com/sc_xtcp/index.html

Known Issues
============

none

Support
=======

Issues may be submitted via the Issues tab in this github repo. Response to any issues submitted as at the discretion of the maintainer for this line.

Required software (dependencies)
================================

  * sc_ethernet (git@github.com:xcore/sc_ethernet.git)
  * xcommon (if using development tools earlier than 11.11.0)

