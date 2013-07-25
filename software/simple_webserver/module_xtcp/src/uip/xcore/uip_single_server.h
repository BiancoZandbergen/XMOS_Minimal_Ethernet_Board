#include <xs1.h>

#include "mii.h"
#include "smi.h"
#include "xtcp_client.h"

/**
 * The top level thread function for a single threaded XTCP server, interfacing
 * to a single thread ethernet MII.
 *
 * The xtcp_client_conf.h file should define the compile time flag
 * UIP_USE_SINGLE_THREADED_ETHERNET in order to use this function.
 *
 * \note This function should be used in a top level 'par' in the main function.
 *       It will internally create the single MII thread.
 *
 * \param clk_smi        Clock block for controlling the SMI interface
 * \param p_mii_resetn   Optional port which resets the PHY
 * \param smi            Structure describing the SMI ports
 * \param mii            Structure describing the MII ports
 * \param xtcp           Array of client comms channels
 * \param num_xtcp       The number of TCP client channels
 * \param ipconfig       The configuration structure for the IP address
 * \param mac_address    The unicast MAC address for this device
 *
 */
void uipSingleServer(clock clk_smi,
                     out port ?p_mii_resetn,
                     smi_interface_t &smi,
                     mii_interface_t &mii,
                     chanend xtcp[], int num_xtcp,
                     xtcp_ipconfig_t& ipconfig,
                     char mac_address[6]);
