##Adjust empirical model to formal model
#load files
	library(foreign)
	final<-read.spss("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox\\Public (1)\\data & script.2\\Final Data reduced agg.sav")

##Post-Workshop Script

#MEANS TABLES=sindon BY prefinc
  #/CELLS MEAN COUNT STDDEV
  #/STATISTICS ANOVA LINEARITY.

#MEANS TABLES=sindon BY prefchal
  #/CELLS MEAN COUNT STDDEV
  #/STATISTICS ANOVA LINEARITY.

#MEANS TABLES=sindon BY prefopen
  #/CELLS MEAN COUNT STDDEV
  #/STATISTICS ANOVA LINEARITY.

#MEANS TABLES=sindon BY pref
  #/CELLS MEAN COUNT STDDEV
  #/STATISTICS ANOVA LINEARITY.


#SAVE OUTFILE='C:\Users\Joshua\Dropbox\Public (1)\Final Data reduced agg.sav'.



#REGRESSION
  #/MISSING LISTWISE
  #/STATISTICS COEFF OUTS R ANOVA
  #/CRITERIA=PIN(.05) POUT(.10)
  #/NOORIGIN 
  #/DEPENDENT AdjAmount
  #/METHOD=ENTER incumbent challenger pref.


#REGRESSION
  #/MISSING LISTWISE
  #/STATISTICS COEFF OUTS R ANOVA
  #/CRITERIA=PIN(.05) POUT(.10)
  #/NOORIGIN 
  #/DEPENDENT sindon
  #/METHOD=ENTER incumbent challenger pref.}

##Hypotheses used for class (post-workshop)
	#H1: Strategic donations will be a larger share of contributions.
	#H2: Sincere donations will be a smaller share of contributions.

##Updated Hypotheses for Midwest
	#H1: In election where the preferred candidate is likely to 
	#	win donors will only give an access seeking contribution 
	#	to their favored candidate  
	#H2: In election where the non-preferred candidate is likely to 
	#	win donors will only give an access seeking contribution 
	#	to the non-preferred candidate  

##Updated Models for Midwest

#data
	attach(final)

#add interaction variables
	win<-inc*pwin
	pi<-pref*incumbent
	winning<-pi*win

#Model 1 (H1)
	
	m1<-lm(AdjAmount~pref+incumbent+challenger+win+winning)
	m2<-lm(AdjAmount~pref+incumbent+challenger)

#output
	summary(m1)
	summary(m2)

#descriptive statistics

#export to .sav

	final2<-cbind( final$Cycle,final$PACID,final$Name,final$CID,
		final$Amount,final$Date,final$PACShort,
		final$Ultorg,final$com_nam,final$Company,state,final$District,
		final$FIPS,final$stcd,final$inc,final$pwin,
		final$dv,final$fr,final$po1,final$po2,final$dexp,final$rexp,
		final$dpres,final$AdjAmount,final$demdum,final$repdum,
		final$incumbent,final$challenger,final$openseat,final$pref,
		final$Stratgicdon,final$sindon) 
		
	midwest<-cbind(final2,win,pi,winning)


#write table
	library(XML)
	setwd(("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox\\Public (1)\\data & script.2")
#writing table to sav
	out_file <- file("midwest.sav", open="a")
	write.foreign(midwest,file=out_file ,package= c("SPSS"),
	sep=",", dec=".", quote=FALSE, 
	col.names=NA, row.names=TRUE)
	close(out_file)
#check

	