from pynq import DefaultIP
from pynq import DefaultHierarchy

from time import sleep

class HoughPerformance(DefaultIP):
    """Driver for Hough Performance Analyser core logic IP
    Exposes all the configuration registers by name via data-driven properties
    """
    
    def __init__(self, description):
        super().__init__(description=description)
        
    bindto = ['xilinx.com:ip:hpa_module:1.0']
    
    
# LUT of property addresses for our data-driven properties
_houghperformance_props = [("frequency", 256), ("reset", 260), ("seconds", 264), ("fraction", 268), ("pmvr_nonzero", 272), ("pmvr_sum", 276)]

# Func to return a MMIO getter and setter based on a relative addr
def _create_mmio_property(addr):
    def _get(self):
        return self.read(addr)

    def _set(self, value):
        self.write(addr, value)

    return property(_get, _set)


# Generate getters and setters based on _houghperformance_props
for (name, addr) in _houghperformance_props:
    setattr(HoughPerformance, name, _create_mmio_property(addr))