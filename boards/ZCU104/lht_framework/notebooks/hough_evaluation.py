# PYNQ libraries
from pynq import Overlay
from pynq import allocate
from PIL import Image

import cv2
import plotly as py
import plotly.graph_objs as go
import numpy as np
import os
import hough_performance

class HoughEvaluation(Overlay):
    
    def __init__(self, width, height, frequency, bitfile_name=None, **kwargs):
        """Construct a new HoughEvaluation
        width: Required. The width of the image to be processed.
        height: Required. The height of the image to be processed.
        frequency: Required. The system frequency of the Hough architecture.
        bitfile_name: Optional. If left None, the 'zcu104_hep.bit' bundled
                      with the hough_evaluation_platform package will be used.
        """
        
        # Generate default bitfile name
        if bitfile_name is None:
            this_dir = os.path.dirname(__file__)
            bitfile_name = os.path.join(this_dir, 'bitstream', 'zcu104_hep.bit')

        # Set FPD and LPD interface widths
        from pynq import MMIO
        fpd_cfg = MMIO(0xfd615000, 4)
        fpd_cfg.write(0, 0x00000A00)
        lpd_cfg = MMIO(0xff419000, 4)
        lpd_cfg.write(0, 0x00000000)

        # Create Overlay
        super().__init__(bitfile_name, **kwargs)
        
        # Set system parameters
        self.width = width
        self.height = height
        self.frequency = frequency
        self.nrho = int(np.ceil(np.sqrt((self.width/2)**2 + (self.height/2)**2))*2)
        self.ntheta = np.size(np.arange(0,180))
        
        # Initialise system outputs
        self.time = 0
        self.pmvr = 0
        
        # Extract ipcore from the overlay with friendly name and initialise
        self.hpa = self.hpa_module
        self.hpa.frequency = self.frequency
        
        # Set up dma buffers
        self.inarray = allocate(shape=(self.height, self.width), dtype=np.uint32)
        self.outarray = allocate(shape=(self.ntheta, self.nrho), dtype=np.uint32)
        
    def imread(self, imgfile_name='assets/dirtyroof.bmp'):
        return cv2.resize(cv2.imread(imgfile_name), (self.width, self.height))
    
    def rgb2grey(self, rgb):
        return cv2.cvtColor(rgb, cv2.COLOR_BGR2GRAY)
    
    def sobel(self, grey, threshold):
        sobelx = cv2.convertScaleAbs(cv2.Sobel(grey, cv2.CV_16S, 1, 0, ksize=3))
        sobely = cv2.convertScaleAbs(cv2.Sobel(grey, cv2.CV_16S, 0, 1, ksize=3))
        gmag = cv2.addWeighted(sobelx, 0.5, sobely, 0.5, 0)
        ret, edge = cv2.threshold(gmag, threshold, 255, cv2.THRESH_BINARY)
        return edge
    
    def hough(self, edge):
        self.inarray[:, :] = np.array(edge, dtype=np.uint32)[:, :]
        self.axi_dma.recvchannel.transfer(self.outarray)
        self.axi_dma.sendchannel.transfer(self.inarray)
        self.axi_dma.sendchannel.wait()
        self.axi_dma.recvchannel.wait()
        self.time = (self.hpa.fraction/self.hpa.frequency) + self.hpa.seconds
        self.pmvr = np.array(np.max(self.outarray))/(self.hpa.pmvr_sum/self.hpa.pmvr_nonzero)
        self.hpa.reset = 1
        self.hpa.reset = 0
        return np.array(self.outarray, dtype=np.uint32)
    
    def plot(self, hps):
        data = [go.Surface(z=hps,colorscale='Jet')]
        layout = go.Layout(
            title='Hough Parameter Space',
            autosize=False,
            width=800,
            height=800,
            scene=dict(
                yaxis=dict(
                    title='Orientation'
                ),
                xaxis=dict(
                    title='Displacement'
                ),
                zaxis=dict(
                    title='Votes'
                )
            )
        )
        fig = go.Figure(data=data, layout=layout)
        py.offline.iplot(fig)
        return fig
    
    def display(self, img):
        return Image.fromarray(img)