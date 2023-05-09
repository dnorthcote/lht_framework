
name = {'1080', '720', '768', '600', '512', '334', '240'};
status = ones(1, length(name));
heightName = [1080, 720, 768, 600, 512, 334, 240];
widthName = [1920, 1280, 1024, 800, 512, 334, 320];
fclk = [175, 175, 185, 185, 200, 200, 200];

I = imread('chess.jpg');
sobelThreshold = 100;
theta = (0:1:179);
nTheta = length(theta);

open_system('arlht');
hdlset_param('arlht', 'GenerateValidationModel', 'on');
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
    [edge, dir, mag] = SobelEdge(Y, sobelThreshold);
    dirNew = floor(dir);
    simDirNew = dirNew;
    simDirNew(edge==0) = 255;

    % Create input array
    inarray = uint8(simDirNew);
    
    set_param('arlht', 'SimulationCommand', 'update');
    
    %% Set Model 'arlht' HDL parameters
    hdlset_param('arlht', 'HDLSubsystem', 'arlht/DUT');
    hdlset_param('arlht', 'ReferenceDesign', 'Default System (Vivado 2020.1)');
    hdlset_param('arlht', 'ReferenceDesignParameter', {'IPAddress','192.168.137.66'});
    hdlset_param('arlht', 'SynthesisTool', 'Xilinx Vivado');
    hdlset_param('arlht', 'SynthesisToolChipFamily', 'Zynq UltraScale+');
    hdlset_param('arlht', 'SynthesisToolDeviceName', 'xczu7ev-ffvc1156-2-e');
    hdlset_param('arlht', 'SynthesisToolPackageName', '');
    hdlset_param('arlht', 'SynthesisToolSpeedValue', '');
    hdlset_param('arlht', 'TargetDirectory', strjoin(['hdl_prj_',name(nameIdx),'\hdlsrc'], ''));
    hdlset_param('arlht', 'TargetFrequency', fclk(nameIdx));
    hdlset_param('arlht', 'TargetPlatform', 'ZCU104 Development Board');
    hdlset_param('arlht', 'Workflow', 'IP Core Generation');
    
    % Set SubSystem HDL parameters
    hdlset_param('arlht/DUT', 'AXI4SlaveIDWidth', '12');
    hdlset_param('arlht/DUT', 'IPCoreName', 'AXIS_Architecture');
    hdlset_param('arlht/DUT', 'ProcessorFPGASynchronization', 'Free running');

    % Set Inport HDL parameters
    hdlset_param('arlht/DUT/Valid In', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('arlht/DUT/Valid In', 'IOInterfaceMapping', 'Valid');

    % Set Inport HDL parameters
    hdlset_param('arlht/DUT/Data In', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('arlht/DUT/Data In', 'IOInterfaceMapping', 'Data');

    % Set Inport HDL parameters
    hdlset_param('arlht/DUT/EoF In', 'IOInterface', 'AXI4-Stream Slave');
    hdlset_param('arlht/DUT/EoF In', 'IOInterfaceMapping', 'TLAST (optional)');

    % Set Outport HDL parameters
    hdlset_param('arlht/DUT/Valid Out', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('arlht/DUT/Valid Out', 'IOInterfaceMapping', 'Valid');

    % Set Outport HDL parameters
    hdlset_param('arlht/DUT/HPS', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('arlht/DUT/HPS', 'IOInterfaceMapping', 'Data');

    % Set Outport HDL parameters
    hdlset_param('arlht/DUT/EoF Out', 'IOInterface', 'AXI4-Stream Master');
    hdlset_param('arlht/DUT/EoF Out', 'IOInterfaceMapping', 'TLAST (optional)');
    
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
    hdlcoder.runWorkflow('arlht/DUT', hWC);

end

