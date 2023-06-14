
name = {'720', '768', '600', '512', '334', '240'};
status = ones(1, length(name));
heightName = [720, 768, 600, 512, 334, 240];
widthName = [1280, 1024, 800, 512, 334, 320];
fclk = [225, 225, 230, 250, 250, 250];

I = imread('chess.jpg');
sobelThreshold = 100;
theta = (0:1:179);
nTheta = length(theta);

open_system('symmetric_lht');
hdlset_param('symmetric_lht', 'GenerateValidationModel', 'off');
hdlsetuptoolpath('ToolName','Xilinx Vivado','ToolPath','C:\Xilinx\Vivado\2020.1\bin')

%% Iterate through each test
for nameIdx = 1:length(name)

    % Initialise parameters
    height = heightName(nameIdx);
    width = widthName(nameIdx);
    fs = fclk(1)*1e6;

    % Derive variables
    maxRho = ceil(sqrt((height/2)^2+(width/2)^2));
    nRho = maxRho*2;

    % Read in image and resize
    Ir = imresize(I, [height, width]);

    % Get greyscale
    Y = rgb2gray(Ir);

    % Get Sobel and Gradient
    [edge, ~, ~] = Sobel(Y, sobelThreshold);
    simDirNew = uint8(fi(edge, 0, 1, 0));

    % Create input array
    inarray = uint8(simDirNew);
    
    set_param('symmetric_lht', 'SimulationCommand', 'update');
    
    % Set model params
    memBlock = strcat('symmetric_lht', ...
        '/DUT/Symmetric Hough Accumulator/Symmetric Accumulator/', ...
        'Symmetric Memory/Simple Dual Port RAM Generator');
    set_param(memBlock, 'b', int2str(eval('ceil(log2(maxRho*2))*2')));
    set_param(memBlock, 'd', int2str(eval('maxRho*2')));
    
    %% Set Model 'symmetric_lht' HDL parameters
    hdlset_param('symmetric_lht', 'HDLSubsystem', 'symmetric_lht/DUT');
    hdlset_param('symmetric_lht', 'ReferenceDesign', 'Default System (Vivado 2020.1)');
    hdlset_param('symmetric_lht', 'ReferenceDesignParameter', {'IPAddress','192.168.137.66'});
    hdlset_param('symmetric_lht', 'SynthesisTool', 'Xilinx Vivado');
    hdlset_param('symmetric_lht', 'SynthesisToolChipFamily', 'Zynq UltraScale+');
    hdlset_param('symmetric_lht', 'SynthesisToolDeviceName', 'xczu7ev-ffvc1156-2-e');
    hdlset_param('symmetric_lht', 'SynthesisToolPackageName', '');
    hdlset_param('symmetric_lht', 'SynthesisToolSpeedValue', '');
    hdlset_param('symmetric_lht', 'TargetDirectory', strjoin(['hdl_prj_',name(nameIdx),'\hdlsrc'], ''));
    hdlset_param('symmetric_lht', 'TargetFrequency', fclk(nameIdx));
    hdlset_param('symmetric_lht', 'TargetPlatform', 'ZCU104 Development Board');
    hdlset_param('symmetric_lht', 'Workflow', 'IP Core Generation');
    
    % Set SubSystem HDL parameters
    hdlset_param('symmetric_lht/DUT', 'AXI4SlaveIDWidth', '12');
    hdlset_param('symmetric_lht/DUT', 'IPCoreName', 'AXIS_Architecture');
    hdlset_param('symmetric_lht/DUT', 'ProcessorFPGASynchronization', 'Free running');

    % Set Inport HDL parameters
    hdlset_param('symmetric_lht/DUT/s_axis_tvalid', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('symmetric_lht/DUT/s_axis_tvalid', 'IOInterfaceMapping', 'Valid');

    % Set Inport HDL parameters
    hdlset_param('symmetric_lht/DUT/s_axis_tdata', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('symmetric_lht/DUT/s_axis_tdata', 'IOInterfaceMapping', 'Data');

    % Set Inport HDL parameters
    hdlset_param('symmetric_lht/DUT/s_axis_tlast', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('symmetric_lht/DUT/s_axis_tlast', 'IOInterfaceMapping', 'TLAST (optional)');

    % Set Outport HDL parameters
    hdlset_param('symmetric_lht/DUT/m_axis_tvalid', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('symmetric_lht/DUT/m_axis_tvalid', 'IOInterfaceMapping', 'Valid');

    % Set Outport HDL parameters
    hdlset_param('symmetric_lht/DUT/m_axis_tdata', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('symmetric_lht/DUT/m_axis_tdata', 'IOInterfaceMapping', 'Data');

    % Set Outport HDL parameters
    hdlset_param('symmetric_lht/DUT/m_axis_tlast', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('symmetric_lht/DUT/m_axis_tlast', 'IOInterfaceMapping', 'TLAST (optional)');
    
    %% Workflow Configuration Settings
    % Construct the Workflow Configuration Object with default settings
    hWC = hdlcoder.WorkflowConfig('SynthesisTool','Xilinx Vivado','TargetWorkflow','IP Core Generation');

    % Specify the top level project directory
    hWC.ProjectFolder = strjoin(['hdl_prj_',name(nameIdx)], '');
    hWC.ReferenceDesignToolVersion = '2020.1';
    hWC.IgnoreToolVersionMismatch = false;

    % Set Workflow tasks to run
    hWC.RunTaskGenerateRTLCodeAndIPCore = true;
    hWC.RunTaskCreateProject = true;
    hWC.RunTaskGenerateSoftwareInterfaceModel = false;
    hWC.RunTaskBuildFPGABitstream = true;
    hWC.RunTaskProgramTargetDevice = true;

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
    hWC.RunExternalBuild = false;
    hWC.TclFileForSynthesisBuild = hdlcoder.BuildOption.Default;
    hWC.CustomBuildTclFile = '';

    % Set properties related to 'RunTaskProgramTargetDevice' Task
    hWC.ProgrammingMethod = hdlcoder.ProgrammingMethod.Custom;

    % Validate the Workflow Configuration Object
    hWC.validate;

    %% Run the workflow
    hdlcoder.runWorkflow('symmetric_lht/DUT', hWC);

end

