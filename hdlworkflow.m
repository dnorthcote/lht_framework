%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.8 (R2020a) at 16:36:37 on 15/06/2023
% This script was generated using the following parameter values:
%     Filename  : 'C:\GitHub\dn_thesis\Thesis\repos\lht_framework\hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'symmetric_lht/Symmetric LHT'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','symmetric_lht/Symmetric LHT');
%--------------------------------------------------------------------------

%% Load the Model
load_system('symmetric_lht');

%% Restore the Model to default HDL parameters
%hdlrestoreparams('symmetric_lht/Symmetric LHT');

%% Model HDL Parameters
%% Set Model 'symmetric_lht' HDL parameters
hdlset_param('symmetric_lht', 'GenerateModel', 'off');
hdlset_param('symmetric_lht', 'HDLSubsystem', 'symmetric_lht/Symmetric LHT');
hdlset_param('symmetric_lht', 'ReferenceDesign', 'Default System (Vivado 2020.1)');
hdlset_param('symmetric_lht', 'ReferenceDesignParameter', {'IPAddress','192.168.137.66'});
hdlset_param('symmetric_lht', 'ResetType', 'Synchronous');
hdlset_param('symmetric_lht', 'SynthesisTool', 'Xilinx Vivado');
hdlset_param('symmetric_lht', 'SynthesisToolChipFamily', 'Zynq UltraScale+');
hdlset_param('symmetric_lht', 'SynthesisToolDeviceName', 'xczu7ev-ffvc1156-2-e');
hdlset_param('symmetric_lht', 'SynthesisToolPackageName', '');
hdlset_param('symmetric_lht', 'SynthesisToolSpeedValue', '');
hdlset_param('symmetric_lht', 'TargetDirectory', 'hdl_prj_ch\hdlsrc');
hdlset_param('symmetric_lht', 'TargetFrequency', 250);
hdlset_param('symmetric_lht', 'TargetPlatform', 'ZCU104 Development Board');
hdlset_param('symmetric_lht', 'Workflow', 'IP Core Generation');

% Set SubSystem HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT', 'AXI4SlaveIDWidth', '12');
hdlset_param('symmetric_lht/Symmetric LHT', 'IPCoreName', 'AXIS_Architecture');
hdlset_param('symmetric_lht/Symmetric LHT', 'ProcessorFPGASynchronization', 'Free running');

% Set Inport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tvalid', 'IOInterface', 'AXI4-Stream Slave');
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tvalid', 'IOInterfaceMapping', 'Valid');

% Set Inport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tdata', 'IOInterface', 'AXI4-Stream Slave');
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tdata', 'IOInterfaceMapping', 'Data');

% Set Inport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tlast', 'IOInterface', 'AXI4-Stream Slave');
hdlset_param('symmetric_lht/Symmetric LHT/s_axis_tlast', 'IOInterfaceMapping', 'TLAST (optional)');

% Set SubSystem HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/Symmetric Hough Kernel/HDL FILO/Single Port RAM', 'RAMDirective', 'distributed');

% Set SubSystem HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/Symmetric Hough Kernel/Symmetric Kernel/Precompute ysin/sin LUT', 'AdaptivePipelining', 'off');

% Set Outport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tvalid', 'IOInterface', 'AXI4-Stream Master');
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tvalid', 'IOInterfaceMapping', 'Valid');

% Set Outport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tdata', 'IOInterface', 'AXI4-Stream Master');
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tdata', 'IOInterfaceMapping', 'Data');

% Set Outport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tlast', 'IOInterface', 'AXI4-Stream Master');
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tlast', 'IOInterfaceMapping', 'TLAST (optional)');

% Set Outport HDL parameters
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tuser', 'IOInterface', 'No Interface Specified');
hdlset_param('symmetric_lht/Symmetric LHT/m_axis_tuser', 'IOInterfaceMapping', '');


%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado','TargetWorkflow','IP Core Generation');

% Specify the top level project directory
hWC.ProjectFolder = 'hdl_prj_ch';
hWC.ReferenceDesignToolVersion = '2020.1';
hWC.IgnoreToolVersionMismatch = false;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndIPCore = true;
hWC.RunTaskCreateProject = true;
hWC.RunTaskGenerateSoftwareInterfaceModel = false;
hWC.RunTaskBuildFPGABitstream = true;
hWC.RunTaskProgramTargetDevice = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndIPCore' Task
hWC.IPCoreRepository = '';
hWC.GenerateIPCoreReport = true;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';
hWC.EnableIPCaching = true;

% Set properties related to 'RunTaskGenerateSoftwareInterfaceModel' Task
hWC.OperatingSystem = 'Linux';

% Set properties related to 'RunTaskBuildFPGABitstream' Task
hWC.RunExternalBuild = true;
hWC.TclFileForSynthesisBuild = hdlcoder.BuildOption.Default;
hWC.CustomBuildTclFile = '';

% Set properties related to 'RunTaskProgramTargetDevice' Task
hWC.ProgrammingMethod = hdlcoder.ProgrammingMethod.Custom;

% Validate the Workflow Configuration Object
hWC.validate;

%% Run the workflow
hdlcoder.runWorkflow('symmetric_lht/Symmetric LHT', hWC);
