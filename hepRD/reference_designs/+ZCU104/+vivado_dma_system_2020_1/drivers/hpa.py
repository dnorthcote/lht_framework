# PYNQ Libraries
from pynq import DefaultIP

class HoughPerformance(DefaultIP):
    """Driver for Hough Performance Analyser core logic IP.
    """
    
    def __init__(self, description):
        """Construct a HoughPerformance object for
        controlling the HPA IP core.
        """
        super().__init__(description=description)
    
    @property
    def reset(self):
        """Returns the reset register value.
        """
        return self.read(256)
    
    @reset.setter
    def reset(self, reset):
        """Sets the reset register value.
        """
        self.write(256, reset)
        
    @property
    def clock_cycles(self):
        """Returns the clock_cycles register value.
        """
        return self.read(260)
        
    @property
    def overflow(self):
        """Returns the overflow register value.
        """
        return self.read(264)
    
    bindto = ['xilinx.com:ip:hpa_module:1.2']
    