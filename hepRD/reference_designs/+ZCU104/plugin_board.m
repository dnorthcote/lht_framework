function hB = plugin_board()
% Board definition

% Construct board object
hB = hdlcoder.Board;
hB.BoardName    = 'ZCU104 Development Board';

% FPGA device information
hB.FPGAVendor   = 'Xilinx';
hB.FPGAFamily   = 'Zynq UltraScale+';
hB.FPGADevice   = 'xczu7ev-ffvc1156-2-e';

% Tool information
hB.SupportedTool = {'Xilinx Vivado'};

% FPGA JTAG chain position
hB.JTAGChainPosition = 2;

%% Add interfaces
% Standard "External Port" interface
hB.addExternalPortInterface( ...
    'IOPadConstraint', {'IOSTANDARD = LVCMOS33'});
