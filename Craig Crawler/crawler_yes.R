# RSTART 
library(RCurl)
library(XML)
doc <- getURL('http://binghamton.craigslist.org/apa/')
html <- htmlTreeParse(doc, useInternalNodes = TRUE)
atts <- xpathApply(html, '//p[@class="row"]//a[@href]', xmlToList)
df <- data.frame(name = sapply(atts, function(x) x$text),
url = sapply(atts, function(x) x$.attrs[[1]]),
stringsAsFactors = FALSE)

##see 'write dta' in crawler scripts 


#check