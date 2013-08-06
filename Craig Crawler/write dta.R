##write craigslist files
	load("C:\\Documents and Settings\\Ty\\My Documents\\Tongo\\Crawler\\craig813.Rdata") 
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Tongo\\Crawler")

#library
	library(XML)
	library(RCurl)
	library(foreign)

#dataframe
	t<-data.frame(df)

# export data frame to Stata binary format 

	write.dta(t, "C:\\Documents and Settings\\Ty\\My Documents\\Tongo\\Crawler\\craig813.dta")

#check

