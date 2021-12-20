# PYNQ libraries
from pynq import Overlay
from pynq import allocate

# Python Libraries
import cv2
import plotly as py
import plotly.graph_objs as go
from PIL import Image
import numpy as np
import os

# Custom Libraries
from hpa import HoughPerformance

class HoughEvaluation(Overlay):
    """Hough Evaluation Platform Overlay Class"""
    
    def __init__(self, width, height, frequency, drho=1, 
                 dtheta=1, **kwargs):
        """Construct a new HoughEvaluation class
        width: Required. The width of the image to be processed.
        height: Required. The height of the image to be processed.
        frequency: Required. The system frequency of the Hough architecture.
        drho: quantisation interval across the rho axis.
        dtheta: quantisation interval across the theta axis.
        """
        
        # Set bitfile_name
        this_dir = os.path.dirname(__file__)
        bitfile_name = os.path.join(this_dir, 'zcu104_hep.bit')

        # Create Overlay
        super().__init__(bitfile_name, **kwargs)
        
        # Set system parameters
        self.width = width
        self.height = height
        self.frequency = frequency
        self.drho = drho
        self.dtheta = dtheta
        self.nrho = int(np.ceil(np.sqrt(
            (self.width/2)**2 + \
            (self.height/2)**2))*2/self.drho)
        self.ntheta = np.size(np.arange(0,180,self.dtheta))
        
        # Initialise performance output
        self.time = 0
        
        # Extract ipcore from the overlay with friendly name
        self.hpa = self.hpa_module
        self.hpa.frequency = self.frequency
        
        # Set up dma buffers
        self.inarray = allocate(shape=(self.height, self.width),
                                dtype=np.uint32)
        self.outarray = allocate(shape=(self.ntheta, self.nrho),
                                 dtype=np.uint32)
        
    def imread(self, imgfile_name='chessboard.jpg'):
        """Returns an image resized to the architecture requirements.
        imgfile_name: A string containing the address location of an image.
        """
        return cv2.resize(cv2.imread(imgfile_name),
                          (self.width, self.height))
    
    def rgb2grey(self, rgb):
        """Returns a greyscale image.
        rgb: An rgb image to be converted to greyscale.
        """
        return cv2.cvtColor(rgb, cv2.COLOR_BGR2GRAY)
    
    def sobeledge(self, grey, threshold):
        """Returns the Sobel edge image.
        grey: A greyscale image to undergo edge detection.
        threshold: The edge detector threshold for segmentation.
        """
        sobelx = cv2.convertScaleAbs(cv2.Sobel(grey,
                                               cv2.CV_16S,
                                               1, 0, ksize=3))
        sobely = cv2.convertScaleAbs(cv2.Sobel(grey,
                                               cv2.CV_16S,
                                               0, 1, ksize=3))
        gmag = cv2.addWeighted(sobelx, 0.5, sobely, 0.5, 0)
        ret, edge = cv2.threshold(gmag,
                                  threshold,
                                  255, cv2.THRESH_BINARY)
        return edge
    
    def houghlines(self, edge):
        """Returns the HPS for an input edge image.
        edge: The input edge image.
        """
        self.inarray[:, :] = np.array(edge,
                                      dtype=np.uint32)[:, :]
        self.axi_dma.recvchannel.transfer(self.outarray)
        self.axi_dma.sendchannel.transfer(self.inarray)
        self.axi_dma.sendchannel.wait()
        self.axi_dma.recvchannel.wait()
        self.time = self.hpa.clock_cycles/self.frequency
        self.hpa.reset = 1
        self.hpa.reset = 0
        return np.array(self.outarray, dtype=np.uint32)
    
    def plotSurface(self, hps):
        """Returns a plotly figure handle of the HPS surface.
        hps: The HPS to be plotted.
        """
        data = [go.Surface(z=hps,
                           x=np.arange(-int(self.nrho/2),
                                       int(self.nrho/2), 1),
                           colorscale='Jet')]
        layout = go.Layout(
            title='Hough Parameter Space (Surface)',
            title_x=0.5,
            autosize=False,
            width=600,
            height=600,
            font=dict(
                size=12),
            scene=dict(
                yaxis=dict(
                    title='Orientation (θ)'),
                xaxis=dict(
                    title='Displacement (ρ)'),
                zaxis=dict(
                    title='Votes'),
            )
        )
        fig = go.Figure(data=data, layout=layout)
        camera = dict(center=dict(x=0.1, y=0, z=-0.12))
        fig.update_layout(scene_camera=camera)
        py.offline.iplot(fig)
        return fig
    
    def plotHeatmap(self, hps):
        """Returns a plotly figure handle of the HPS heatmap.
        hps: The HPS to be plotted.
        """
        data = [go.Heatmap(z=hps.transpose(),
                           y=np.arange(-int(self.nrho/2),
                                       int(self.nrho/2), 1),
                           colorscale='Jet')]
        layout = go.Layout(
            title='Hough Parameter Space (Heatmap)',
            title_x=0.5,
            autosize=False,
            width=600,
            height=600,
            font=dict(
                size=12),
            scene=dict(
                yaxis=dict(
                    title='Orientation (θ)'),
                xaxis=dict(
                    title='Displacement (ρ)'),
                zaxis=dict(
                    title='Votes'),
            )
        )
        fig = go.Figure(data=data, layout=layout)
        py.offline.iplot(fig)
        return fig
    
    def pmvr(self, hps):
        """Returns the PMVR of a given hps.
        hps: The HPS to be analysed.
        """
        return hps.max()/hps[np.nonzero(hps)].mean()
    
    def display(self, img):
        """Returns a PIL of an image.
        img: The image to display.
        """
        return Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    