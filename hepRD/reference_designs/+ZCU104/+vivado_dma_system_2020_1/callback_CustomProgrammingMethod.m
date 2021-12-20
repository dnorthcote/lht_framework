function [status, log] = callback_CustomProgrammingMethod(infoStruct)
% Reference design callback function for custom programming method
% 
% infoStruct: information in structure format
% infoStruct.ReferenceDesignObject: current reference design registration object
% infoStruct.BoardObject: current board registration object
% infoStruct.ParameterStruct: custom parameters of the current reference design, in struct format
% infoStruct.HDLModelDutPath: the block path to the HDL DUT subsystem
% infoStruct.BitstreamPath: the path to the generated FPGA bitstream file
% infoStruct.ToolProjectFolder: the path to synthesis tool project folder
% infoStruct.ToolProjectName: the synthesis tool project name
% infoStruct.ToolCommandString: the command for running a tcl file
% 
% status: process run status
%         status == true means process run successfully
%         status == false means process run failed
% log:    output log string

% Set unsuccessful status.
status = false;

% Set IP Address and open default browser
ipAddress = infoStruct.ParameterStruct.IPAddress;
web(['http://', ipAddress, ':9090/lab'])

% Set date and time and correct format for folder directory
dt = datetime;
dt.Format = 'ddMMyy_ssmmHH';

% Make Jupyter working directory
plinkCmd = "plink -ssh xilinx@" + string(ipAddress) + " -pw xilinx ";
mkdirCmd = "mkdir -p /home/xilinx/jupyter_notebooks/hep/" + string(dt);
system(plinkCmd + mkdirCmd);

% Transfer bitstream file
bitstreamDir = fullfile(pwd, infoStruct.ToolProjectFolder, ...
    'vivado_prj.runs','impl_1','zcu104_hep_wrapper.bit');
pscpBitCmd = "pscp -pw xilinx " + bitstreamDir + " xilinx@" + ipAddress ...
    +":/home/xilinx/jupyter_notebooks/hep/"+string(dt)+"/zcu104_hep.bit";
system(pscpBitCmd);

% Transfer hardware handoff file
hwhDir = fullfile(pwd, infoStruct.ToolProjectFolder, 'vivado_prj.srcs', ...
    'sources_1', 'bd', 'zcu104_hep', 'hw_handoff', 'zcu104_hep.hwh');
pscpHwhCmd = "pscp -pw xilinx " + hwhDir + " xilinx@" + ipAddress ...
    + ":/home/xilinx/jupyter_notebooks/hep/" + string(dt);
system(pscpHwhCmd);

% Transfer driver files and notebook
driverDir = replace(mfilename('fullpath'), ...
    'callback_CustomProgrammingMethod', 'drivers\');
dirContents = dir(driverDir);
for idx = 1:length(dirContents)
    file = dirContents(idx);
    pscpDriverCmd = "pscp -pw xilinx " + driverDir + file.name + ...
        " xilinx@" + ipAddress + ":/home/xilinx/jupyter_notebooks/hep/" ...
        + string(dt);
    if contains(file.name, '.py') || contains(file.name, '.ipynb') || ...
        contains(file.name, '.jpg')
        system(pscpDriverCmd);
    end
end

% Report information to user
log = [newline, 'A browser window has opened at the IP Address.', ...
       newline, 'Design files have been uploaded to this folder:', ...
       strcat('/home/xilinx/jupyter_notebooks/hep/', string(dt))];
  
% Set successful status
status = true;
end
