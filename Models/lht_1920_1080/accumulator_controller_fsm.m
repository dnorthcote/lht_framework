function [mode, read, clear, index, valid, debug_state] ...
    = fsm(sof, eof, ntheta, nrho)
% FSM Controls the voting of the parallel.accumulator array

% Initialise states as fi objects
IDLE = fi(0, 0, 2, 0);
VOTE = fi(1, 0, 2, 0);
READ = fi(2, 0, 2, 0);
CLEAR = fi(3, 0, 2, 0);

% Declare persistent objects for current state and counters
persistent current_state;
persistent rho_counter;
persistent theta_counter;

% Initialise persistent object current_state
if isempty(current_state)
    current_state = IDLE;
end

% Initialise persistent object rho_counter
if isempty(rho_counter)
    rho_counter = fi(0, 0, 16, 0);
end

% Initialise persistent object theta_counter
if isempty(theta_counter)
    theta_counter = fi(0, 0, 16, 0);
end

% Perform state transition and output assignment
switch current_state
    case IDLE
        % When IDLE, reset counters and no valid output
        rho_counter = fi(0, 0, 16, 0);
        theta_counter = fi(0, 0, 16, 0);
        clear = false;
        valid = false;
        debug_state = current_state;
        read = rho_counter;
        index = theta_counter;
        
        % Transition from IDLE to VOTE is start of frame (sof) detected
        % else, stay in IDLE
        if sof
            mode = true;
            current_state = VOTE;
        else
            mode = false;
            current_state = IDLE;
        end
        
    case VOTE
        % When VOTE, keep counters at zero, keep mode True
        rho_counter = fi(0, 0, 16, 0);
        theta_counter = fi(0, 0, 16, 0);
        mode = true;
        clear = false;
        valid = false;
        debug_state = current_state;
        read = rho_counter;
        index = theta_counter;
        
        % If end of frame (eof) detected, go to the READ state
        % else, stay in the VOTE state
        if eof
            current_state = READ;
        else
            current_state = VOTE;
        end
        
    case READ
        % To read out the HPS, cycle through the theta and rho counters.
        % mode set to False and valid is True
        mode = false;
        clear = false;
        read = rho_counter;
        index = theta_counter;
        valid = true;
        debug_state = current_state;
        
        % If theta_counter and rho_counter are at limits then transition
        % to the CLEAR state
        % else, stay in the READ state
        if theta_counter >= ntheta && rho_counter >= nrho
            rho_counter = fi(0, 0, 16, 0);
            theta_counter = fi(0, 0, 16, 0);
            current_state = CLEAR;
        elseif rho_counter >= nrho
            theta_counter = fi(theta_counter + 1, 0, 16, 0);
            rho_counter = fi(0, 0, 16, 0);
            current_state = READ;
        else
            rho_counter = fi(rho_counter + 1, 0, 16, 0);
            current_state = READ;
        end
        
    case CLEAR
        % Clear output is set to True in this state to clear the memory
        mode = false;
        clear = true;
        valid = false;
        read = rho_counter;
        index = theta_counter;
        debug_state = current_state;
        
        % The rho_counter and theta_counter are reset after full clear
        % Then transition to the IDLE state
        if rho_counter >= nrho
            rho_counter = fi(0, 0, 16, 0);
            theta_counter = fi(0, 0, 16, 0);
            current_state = IDLE;
        else
            rho_counter = fi(rho_counter + 1, 0, 16, 0);
            theta_counter = fi(0, 0, 16, 0);
            current_state = CLEAR;
        end
        
    otherwise
        rho_counter = fi(0, 0, 16, 0);
        theta_counter = fi(0, 0, 16, 0);
        mode = false;
        clear = false;
        valid = false;
        debug_state = current_state;
        read = rho_counter;
        index = theta_counter;
        current_state = IDLE;
end