#Dice roll function
	RollDie = function(n) sample(1:6,n,replace=T)
#use Die
	RollDie(5)
#hw1
#generate random variables w/ mean & sd
	var1<-rnorm(40,0,.9)
	var2<-rnorm(40,0,0.591607978)
	var3<-rnorm(40,1.75,0.447213595)
#make dataset
	x<-cbind(var1,var2,var3)
#write table
#library
	library(XML)
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Krasno.RA\\Data")
#writing table to csv
out_file <- file("retail94.csv", open="a")
write.table(e1, file=out_file, sep=",", dec=".", quote=FALSE, 
col.names=NA, row.names=TRUE)
close(out_file)