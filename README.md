# fungus_heatmap
This repository contains a simple R script for generating a Hi-C heatmap
(sometimes also called a Hi-C contact map). The script requires a file named
heatmap.txt to be present in the current working directory. heatmap.txt should
be in the following format:

```
X  Y   Z
x1  y1  z1
x1  y2  z2
x1  y3  z3
...
xn  yn  znn
```

In other words, a text file with a header with the letters "X" "Y" and "Z"
tab-delimited, followed by one line per pair of (x,y) coordinates that have a
non-zero Z value, with x, y, and z tab-delimited. The file may be sparse; any
missing (x,y) coordinates will be shown as Z=0. Comments may be indicated with
a "#" at the start of a line.

Additionally, an optional command line argument specifying the name of the 
species or sample may be specified, which causes the R script to include that
name in the title of the figure instead of "Sample".

The output figure is written to <species>.heatmap.jpg in the current working
directory.