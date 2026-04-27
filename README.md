# Event-Seeker

Event Seeker is a MATLAB script, generated using version R2025b, designed to take time-scaled fluorescence imaging data (ideally from line scans) and highlight significant fluorescence changes as "events".

This specific version is useful in ratiometric determination of exocytotic release events from neurons.
Using a fluorescent glutamate indicator as a metric for glutamate activity, neurons loaded with FM dyes or pHrodo dyes can be imaged to visualize exocytosis using two channels (green & red). Time-scaled fluorescence profiles from line scans can be copied or uploaded as arrays in the following format

	col    1 2 3 4 5 6 7 8...
	X(time) Y Y Y Y Y Y Y
... w any number of rows

With X denoting time increasing by the sampling rate (ms/line, etc) and Y as fluorescence (Au's), data is uploaded in xlsx format. G input is for the green channel data, and P is for the red channel data. I prefer to copy (CTRL + C) and paste data tables (no headers/column titles) directly using the following command in the command window:

>> uiimport -pastespecial 

then rename them in the workspace accordingly. (uploading using G =  readtable("example.xlsx") also works)

Background subtraction steps can be useful. Uploading a trace of a non-physiological black region, such as in between cells in the line scan, per channel, can help improve SNR. 

**Note if both of your fluorophores are excited well during imaging, this may be unnecessary, but can still reduce artefactual noise**

This program is designed to be User-friendly, with script comments and explanations as you go. Try the mock data sets for a more detailed walkthrough of the program. 

Play around with this code and have fun! It can be modified for correlated relationships between channels, but is set up originally for anticorrelated relationships (Fluorescence in the green (CH1) is expected to be high when that of red (Ch2) is expected to be low).
