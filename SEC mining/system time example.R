
library(XML)
library(RCurl)

time<-function(){

setwd('C:\\Documents and Settings\\Ty\\My Documents\\Past program ideas\\SEC mining')

#define URL CIK variable urla/urlb constant
urla <- "http://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK="
cik <-c("0027419","0104169","0354950")
urlb <- "&type=10-k%25&dateb=&owner=exclude&start=0&count=100&output=atom"

searchresults <- function(a){

xmlurl <- paste(urla,a,urlb,sep = "")

#Get 10K url doc list.
xx <- xmlToList(xmlurl)
xx <- xx[7:length(xx)]
urlList <- as.character(lapply(xx,function(x) x$link[3]))
urlList

#Get year filing doc url

urldoc <-function(x){	
	Filing <- scan(x, what=character())
	Filing
	txt <- grep(".txt",Filing, value=TRUE)
	url <- strsplit(txt, '"')
	
	
	fileurl <- paste("http://www.sec.gov",url[[1]][2],sep = "")
	doc <- getURL(fileurl)

	
	mvline <- (strsplit(doc,"based on the closing price of"))
	spl1 <- as.character(mvline[[1]][1])
	mvline2 <- (strsplit(spl1,"\\d{4}\\swas\\s"))
	marketcap <-mvline2[[1]][2]
	marketcap

	
	mvline <- (strsplit(doc,"\n\t*DATE AS OF CHANGE:"))
	spl1 <- as.character(mvline[[1]][1])
	mvline2 <- (strsplit(spl1,"FILED AS OF DATE:\t*"))
	date <- as.character(mvline2[[1]][2])
	date

	
	mvline <- (strsplit(doc,"\n\t*CENTRAL INDEX KEY:"))
	spl1 <- as.character(mvline[[1]][1])
	mvline2 <- (strsplit(spl1,"CONFORMED NAME:\t*"))
	company <- as.character(mvline2[[1]][2])
	company

	info <- c(company,date,marketcap)

}

	
list<- as.character(lapply(urlList,urldoc))

}

data<-as.character(lapply(cik,searchresults))

write.table(data,file="companyeval.csv",sep = ",",col.names = NA,qmethod = "double")

}
#system time

##check

