#include "hls_design_meta.h"
const Port_Property HLS_Design_Meta::port_props[]={
	Port_Property("s_axi_AXILiteS_AWVALID", 1, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_AWREADY", 1, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_AWADDR", 6, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_WVALID", 1, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_WREADY", 1, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_WDATA", 32, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_WSTRB", 4, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_ARVALID", 1, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_ARREADY", 1, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_ARADDR", 6, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_RVALID", 1, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_RREADY", 1, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_RDATA", 32, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_RRESP", 2, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_BVALID", 1, hls_out, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_BREADY", 1, hls_in, -1, "", "", 1),
	Port_Property("s_axi_AXILiteS_BRESP", 2, hls_out, -1, "", "", 1),
	Port_Property("ap_clk", 1, hls_in, -1, "", "", 1),
	Port_Property("ap_rst_n", 1, hls_in, -1, "", "", 1),
};
const char* HLS_Design_Meta::dut_name = "add";
