##legislative heatmap
#load files
	h109<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\leadership paper\\for fun\\top50Bfor109.csv")

#create variable
	h109$candname<-with(h109, reorder(candname, chvotrec))
#library
	library(ggplot2)
	library(plyr)

	h109.m<- melt(h109)
	h109.m<- ddply(h109.m, .(variable), transform,
		rescale = scale(value))

(p <- ggplot(h109.m, aes(variable, candname)) + geom_tile(aes(fill = rescale),
	colour = "white") + scale_fill_gradient(low = "white",
	high = "black")+ 
	opts(title="Figure1: Top 50 Increases in Money from Business PACs (110th)"))
#check

base_size <- 9

p + theme_grey(base_size = base_size) + labs(x = "",
	y = "") + scale_x_discrete(expand = c(0, 0)) +
	scale_y_discrete(expand = c(0, 0)) + opts(legend.position = "right",
	axis.ticks = theme_blank(), axis.text.x = theme_text(size = base_size *
	1.2, angle = 330, hjust = 0, colour = "grey50"))

#check