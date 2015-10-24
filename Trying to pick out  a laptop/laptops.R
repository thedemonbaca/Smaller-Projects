#library
	library(ggplot2)
	library(reshape2)
	library(plyr)
#load files
	compare1<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\Downloads\\laptops\\compare1.csv")
	compare2<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\Downloads\\laptops\\compare2.csv")
	comp1<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\Downloads\\laptops\\comp1.csv")
	comp2<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\Downloads\\laptops\\comp2.csv")

#check
	ggplot(compare1, aes(company, fill = hardware)) + geom_bar()+
	labs(title="Figure1: Roughly the Same Laptop Hardware")

	ggplot(compare2, aes(company, fill = hardware)) + geom_bar()+
	labs(title="Figure1: Roughly the Same Laptop Hardware")
#change
library(sqldf)
#
	comp1<- sqldf("select company, hardware, price, sum(score) as total 
			from compare1 group by company, price")
	comp<- sqldf(" select * from comp1 group by price")

