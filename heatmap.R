#!/usr/bin/Rscript

# Make a colored heatmap plot from heatmap.txt. heatmap.txt should be a text file
# whose first line reads "X\tY\tZ" and all subsequent lines provide an x, y
# coordinate and a value at that coordinate, tab delimited. Commonly, values
# are Hi-C link counts or link densities. The file may be sparse; any missing
# x,y pairs are plotted as Z=0.
#
#
# Copyright (C) 2018 Phase Genomics
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#


library(ggplot2,quietly=TRUE) # ggplot
library(RColorBrewer) # colorRampPalette
#library(plyr) # used by library(reshape)
#library(reshape) # melt

#a function we will use in making the title on our graphs
simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1, 1)), tolower(substring(s, 2)),
    sep = "", collapse = " ")
}

#input file
heatmap.file <- 'heatmap.txt'

#if a command line arg was passed in, it will be used in the title of the heatmap
species <- "Sample"
args <- commandArgs(trailingOnly=TRUE)
if (length(args) > 0) {
    species <- args[1]
}

species.title = simpleCap(species)

#output file
jpeg.file <- paste(species,".heatmap.jpg", sep="")

# Get a ColorBrewer palette.
#palette <- colorRampPalette( rev( brewer.pal( 11, "Spectral" ) ) )
# Get a ColorBrewer palette.
# Spectrum: blue = no links; yellow = some links; red = lots of links
pal <- c( "#9E0142","#D53E4F","#F46D43","#FDAE61","#FEE08B","#FFFFBF","#E6F598","#ABDDA4","#66C2A5","#3288BD","#5E4FA2" ) # this is brewer.pal( 11,"Spectral" )
pal <- c( "#9E0142","#B91F48","#D53E4F","#E45549","#F46D43","#FDAE61","#FEE08B","#FFFFBF","#E6F598","#ABDDA4","#66C2A5","#3288BD","#5E4FA2" ) # added 2 interpolated colors at the red end of the spectrum
pal <- rev(pal)

# Reds!
pal <- brewer.pal( 9, "Reds" ) # e.g., c( "#FFF5F0", "#FEE0D2", "#FCBBA1", "#FC9272", "#FB6A4A", "#EF3B2C", "#CB181D", "#A50F15", "#67000D" )
pal <- c( pal[1:7], pal[8], "#76040F", pal[9], "#500007", "#300000" ) # darken overall palette by interpolating at dark end of spectrum
palette <- colorRampPalette( pal )

# Read the file.
heatmap <- read.table( heatmap.file, header=TRUE )

# Melt the heatmap from an NxN table into a 4x(N^2) list of columns.
#heatmap.m <- melt( heatmap, id.vars=c("Row"), na.rm=TRUE )

# Create a plot of this heatmap.
p <- ggplot( heatmap, aes( x=X, y=Y, fill=log10(Z+1) ) ) # load data
#p <- ggplot( heatmap, aes( x=X, y=Y, fill=Z ) ) # load data
p <- p + geom_tile() # choose a rectangular tiling
p <- p + xlab("") # clear x- and y-axis labels
p <- p + ylab("")
p <- p + ggtitle(paste(species.title, "Pre-Scaffolding Heatmap"))
p <- p + scale_fill_gradientn( colours = palette(100), name="log10(N links)" ) # choose colors from the palette
#p <- p + scale_x_continuous(breaks=seq(0,1588,100))
#p <- p + scale_y_continuous(breaks=seq(0,1588,100))

ggsave( filename=jpeg.file, plot=p, width=7, height=6 )
