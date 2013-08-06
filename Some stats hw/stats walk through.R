#Statistics run through
#library
	library(foreign)
	library(lmtest)
#load file
	bon<-read.dta("C:\\Documents and Settings\\Ty\\My Documents\\spring 2012\\Judcial Seminar\\Paper\\Empirics\\Bonneau2007replication.dta")

#correlation
	cor(bon, method= "pearson")

#OLS
	a1<-lm(anymarmm~lnadj90incex+lnadj90chex+prehot55+qualchal+primcomp)

#heteroscedasticity
	bptest(a1)

#probit
	

#logit
	