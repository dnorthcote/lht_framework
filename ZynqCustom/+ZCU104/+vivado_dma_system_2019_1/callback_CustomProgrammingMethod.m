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
web(['http://', infoStruct.ParameterStruct.IPAddress, ':9090'])

status = true;
log = [newline, 'A browser window will have opened at the specified IP Address. Upload the Bitstream and hwh files from this project to PYNQ.'];
% Enter your commands for custom programming here

end
