#get file
e1<-read.dta(file.choose())
#write table
#library
	library(XML)
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Krasno.RA\\Data")
#writing table to csv
out_file <- file("pac_donations_1990-2010.csv", open="a")
write.table(e1, file=out_file, sep=",", dec=".", quote=FALSE, 
col.names=NA, row.names=TRUE)
close(out_file)