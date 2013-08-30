#write foreign
#the fun begins
	library(XML)
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\twitter test")
# write out text datafile and
# an SPSS program to read it
library(foreign)
write.foreign(pac2, "C:\\Documents and Settings\\Ty\\My Documents\\leadership paper\\data\\Merge02.csv", "C:\\Documents and Settings\\Ty\\My Documents\\leadership paper\\data\\mydata.sps",   package="SPSS")


#spss
# write out text datafile and
# an SPSS program to read it
library(foreign)
write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sps",   package="SPSS")

#stata
# export data frame to Stata binary format 
library(foreign)
write.dta(m1, "C://Documents and Settings\\Ty\\My Documents\\twitter test\\count.dta")

#sas
# write out text datafile and
# an SAS program to read it
library(foreign)
write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sas",   package="SAS")