function hRD = plugin_rd()
% Reference design definition
% Construct reference design object
hRD = hdlcoder.ReferenceDesign('SynthesisTool', 'Xilinx Vivado');

hRD.ReferenceDesignName = 'Default System (Vivado 2020.1)';
hRD.BoardName = 'ZCU104 Development Board';

% Tool information
hRD.SupportedToolVersion = {'2020.1'};

% Add optional custom parameter for setting the ip address of the board.
hRD.addParameter( ...
    'ParameterID',   'IPAddress', ...
    'DisplayName',   'IP Address of ZCU104', ...
    'DefaultValue',  '192.168.2.99');

% Remove option for HDL Verifier
hRD.AddJTAGMATLABasAXIMasterParameter = 'false';
hRD.JTAGMATLABasAXIMasterDefaultValue = 'off';

% Remove option for "Generate Software Interface Model"
hRD.EmbeddedCoderSupportPackage = hdlcoder.EmbeddedCoderSupportPackage.None;

%% add IP Repository
hRD.addIPRepository(...
    'IPListFunction', 'strath.hdlcoder.vivado_dma_system_2020_1_iplist', ...
		 'NotExistMessage', 'IP repository not found');

%% Add custom design files
% add custom Vivado design
hRD.addCustomVivadoDesign( ...
    'CustomBlockDesignTcl', 'zcu104_hep.tcl', ...
    'VivadoBoardPart',      'xilinx.com:zcu104:part0:1.1');

%% Add interfaces
% add clock interface
hRD.addClockInterface( ...
    'ClockConnection',   'clk_wiz/clk_out1', ...
    'ResetConnection',   'proc_sys_reset_clk_wiz/peripheral_aresetn',...
    'DefaultFrequencyMHz', 150,...
    'MinFrequencyMHz', 10,...
    'MaxFrequencyMHz', 250,...
    'ClockModuleInstance', 'clk_wiz',...
    'ClockNumber', 1);

% add AXI4 and AXI4-Lite slave interfaces
hRD.addAXI4SlaveInterface( ...
    'InterfaceConnection', 'ps8_0_axi_periph/M03_AXI', ...
    'BaseAddress',         '0xA0030000', ...
    'MasterAddressSpace',  'zynq_ultra_ps_e/Data');

% add AXI-Stream interfaces
hRD.addAXI4StreamInterface( ...
'MasterChannelNumber', 1, ...
'SlaveChannelNumber', 1, ...
'MasterChannelConnection', 'axis_broadcaster_s2mm/S_AXIS', ...
'SlaveChannelConnection', 'axis_broadcaster_mm2s/M00_AXIS', ...
'MasterChannelDataWidth', 32, ...
'SlaveChannelDataWidth', 32, ...
'InterfaceID', 'AXI4-Stream');

%% Custom Callback Functions
hRD.CallbackCustomProgrammingMethod = ...
    @ZCU104.vivado_dma_system_2020_1.callback_CustomProgrammingMethod;

end