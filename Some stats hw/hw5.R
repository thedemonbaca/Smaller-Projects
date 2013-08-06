#Estimate and Interpret the trend line for Liberal Party Support
plot(elecseq ~ lib2partyvote, data= hw2, xlab="Liberal 2-Party Vote",
	 ylab="Eection Sequence", col= "blue")
	title(main="Scatter plot with best-fit line", font.main= 4)
	abline(lm(elecseq ~ lib2partyvote, data= hw2), col= "red")
#Plot time series for individual variable
lib2partyvote
lib2<-ts(lib2partyvote)
plot(lib2)
#plot a specific point
plot(lib2partyvote[2],elecseq[11])
#autocorrelation plot for evidence of cyclical behavior
acf(lib2,main="")
#Time lags in the generation of these cycles
acf(lib2,type="p",main="")
#Downward trend after the fifth wk?
second<-lib2[5:18]
#I means "as is"
summary(lm(second~I(1:length(second))))
#Plotting detrended data
detrended<-second - predict(lm(second~I(1:length(second))))
ts.plot(detrended)
#programing a moving average
ma3<-function (x) {
	y<-numeric(length(x)-2)
	for (i in 2:(length(x)-1)) {
	y[i]<-(x[i-1]+x[i]+x[i+1])/3
	}
	y }
#plotting a moving average to see a pattern, 3 point moving avg
lb<-ma3(lib2partyvote)
plot(lb)
lines(lb[1:18])
#comparison
plot(lib2)
plot(lb)
lines(lb[1:18])
#Test for autocorrelation
#Runs test or Geary test
library(spdep)
#create matrix
myco<-cbind(elecseq,lib2partyvote)
myco<-matrix(myco,ncol=2)
#convert to a knn object
myco.knn <- knearneigh(myco, k=4)
#This list object has the following structure
str(myco.knn)
#convert a knn object to a nb object
myco.nb<-knn2nb(myco.knn)
#plot the nb object
plot(myco.nb,myco)
#create the weight list object
myco.lw<-nb2listw(myco.nb, style="W")
myco.lw
#Moran's I test
moran(1:18,myco.lw,length(myco.nb),Szero(myco.lw))
#Geary's other test? check this
geary(1:18,myco.lw,length(myco.nb),length(myco.nb)-1,Szero(myco.lw))
#geary.test(x, listw, randomisation=TRUE, zero.policy=NULL,
alternative="greater", spChk=NULL, adjust.n=TRUE)
#running the geary c test, runs test, for autocorrelation
geary.test(lib2partyvote, myco.lw, randomisation=TRUE, zero.policy=NULL,
alternative="greater", spChk=NULL, adjust.n=TRUE)
#Durbin Watson test
v1<-lm(lib2partyvote~elecseq)
summary(v1)
library(car)
#time variable is set to elecseq, independent variable
durbinWatsonTest(v1)
dataEllipse(elecseq,lib2partyvote)
library(lmtest)
#Breusch-Godfrey LM test for autocorrelation
bgtest(v1, order = 1, type = c("Chisq", "F"))
#saving the residuals from model v1
v1.res<-resid(v1)
#Function: tslag (lagging a vector), lagged one observation
#tslag <- 
function(x, d=1)
{
  x <- as.vector(x)
  n <- length(x)
  c(rep(NA,d),x)[1:n]
}
#using tslag function
v1.lagres<-tslag(v1.res)
#cor of observed residuals and one-period lagged residuals to dwstat
cor(v1.res,v1.lagres)
#lag lib2partyvote 
lib2.lag<-tslag(lib2partyvote)
v2<-lm(lib2partyvote~lib2.lag)
summary(v2)
#bg test for v2
bgtest(v2, order = 1, type = c("Chisq", "F"))
#including a dummy variable for post-70s
attach(hw1)
#running final model
v3<-lm(lib2partyvote~lib2.lag+X)
summary(v3)
#bgtest on v3
bgtest(v3, order = 1, type = c("Chisq", "F"))