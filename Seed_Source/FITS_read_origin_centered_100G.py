#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun May 19 00:05:15 2024

@author: shreeyeshbiswal
"""

import numpy as np
import matplotlib.pyplot as plt
from astropy.visualization import astropy_mpl_style 
from astropy.io import fits
from astropy.utils.data import get_pkg_data_filename

#filestring = 'hmi.sharp_cea_720s.377.20110215_000000_TAI.Br.fits' # --- File format not supported
filestring = 'hmi.sharp_cea_720s.377.20110215_000000_pbz.fits'
file_loc = '/home/shreeyeshbiswal/IDLWorkspace/Dataset_PF/Codes/Astropy/11158/' + filestring

plt.style.use(astropy_mpl_style) 
image_file = get_pkg_data_filename(file_loc)
fits.info(image_file)
image_data = fits.getdata(image_file, ext=0)

print(image_data.shape)
fig1 = plt.figure()
plt.grid(False)
plt.imshow(image_data, cmap='gray', extent = [0, 267.48, 0, 135.36], origin = 'lower')
plt.xticks(fontsize=9)
plt.yticks(fontsize=9)
plt.colorbar(fraction=0.025, pad=0.04)
fig1.savefig('Bz_map.png', dpi = 800, bbox_inches='tight')

original_data = image_data # DEFAULT BUG IN ASTROPY
image_data = np.flip(image_data, axis=0) # CORRECTED DATA

# I pixels along vertical = I-1 units along vertical across ~ 137 Mm (ylen)
# J pixels along horizontal = J-1 units along horizontal across ~ 271 Mm (xlen)

[I, J] = np.shape(image_data) # 377, 744
[xlen, ylen] = [271.13, 137.38]
I_fact = 137.38/(I-1)
J_fact = 271.13/(J-1)

P = 1387; # Number of points (Run once to get errors and ascertain the value)

point_matrix = np.zeros((P, 3)) # Simply contains location of points in (i,j) format
location_matrix = np.zeros((P, 3)) # Contains location in (x,y) format

p = 0

for i in range(0,I,10):
    for j in range(0,J,10):
        if abs(image_data[i,j]) > 100:
            point_matrix[p,2] = 0
            point_matrix[p,1] = j
            point_matrix[p,0] = i
            location_matrix[p,2] = 0
            location_matrix[p,1] = ylen/2 - i*I_fact
            location_matrix[p,0] = j*J_fact - xlen/2
            p = p+1
            print(p)

np.savetxt("data_selected_origin_centered_100G.csv", location_matrix, delimiter = ",", header='x,y,z')
