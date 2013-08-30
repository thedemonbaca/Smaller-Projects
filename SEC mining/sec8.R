
#library
	library(XML)
	library(RCurl)
	library(reshape2)
	library(sqldf)
	library(foreign)
time<- function(){
#go to link
	doc<-getURL('http://www.sec.gov/cgi-bin/browse-edgar?company=&match=&CIK=+0000320193+&filenum=&State=&Country=&SIC=&owner=exclude&Find=Find+Companies&action=getcompany')
	tab<-readHTMLTable(doc)
	n.rows <- unlist(lapply(tab, function(t) dim(t)[1]))
	c<-data.frame(tab[[which.max(n.rows)]])

	html <- htmlTreeParse(doc, useInternalNodes = TRUE)
	atts <- xpathApply(html, '//td[@nowrap="nowrap"]//a[@href]', xmlToList)

	df <- data.frame(name = sapply(atts, function(x) x$text),
	url = sapply(atts, function(x) x$.attrs[[1]]),
	stringsAsFactors = FALSE)

#isolate addresses to possible 10-Q
	arch<- sqldf("select * from df where url like '%Archives%'")

#combine into dataset
	archy<-cbind(arch,c)

#tenQ forms
	tenQ<- sqldf("select * from archy where Filings like '%10-Q%'")

#isolate web address

	Q<-tenQ[1,]
	R<-sqldf("select url from Q")

#create web address
	S<-paste('www.sec.gov',R,sep = "")

#go to web address
	doc2<-getURL(S)
	html2 <- htmlTreeParse(doc2, useInternalNodes = TRUE)
	atts2 <- xpathApply(html2, '//table[@class="tableFile"]//a[@href]', xmlToList)
	df2 <- data.frame(name = sapply(atts2, function(x) x$text),
	url = sapply(atts2, function(x) x$.attrs[[1]]),
	stringsAsFactors = FALSE)

#Isolate 10-Q pdf link
	T<- sqldf("select * from df2 where name like '%10q%'")

#create web/pdf address
	U<-paste('www.sec.gov',T$url,sep = "")

#go to link
	doc3<-getURL(U)
	tab2<-readHTMLTable(doc3)
	V<-melt(tab2)

#write table
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Past program ideas\\SEC mining\\spreadsheet")
#writing table to csv
write.dta(V, "C://Documents and Settings\\Ty\\My Documents\\Past program ideas\\SEC mining\\spreadsheet\\sec8.dta")

#check

}

