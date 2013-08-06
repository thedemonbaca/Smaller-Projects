library(ggplot2)
df <- data.frame(x = rnorm(1000, 0, 1), y = rnorm(1000,
     0, 2), z = rnorm(1000, 2, 1.5))
df.m <- melt(df)
ggplot(df.m) + geom_freqpoly(aes(x = value,
     y = ..density.., colour = variable))

ggplot(df.m) + geom_density(aes(x = value,
     colour = variable)) + labs(x = NULL) +
     opts(legend.position = "none") + 
	opts(title = "Densities from a kernel density estimator")

#test

	dta<-melt(data)
	ggplot(hou) + geom_freqpoly(aes(x = value,
     y = ..density.., colour = variable))	