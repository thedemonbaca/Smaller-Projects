##Stability of Preferences
#load files
	library(foreign)
	game<-read.spss("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox\\Public (1)\\Data\\Final Data Reduced agg.sav")
	Game=game
	game=data.frame(Game)

#library
	library(sqldf)

#Separate by Cycle

	c94<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=1994")
	c96<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=1996")
	c98<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=1998")
	c00<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2000")
	c02<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2002")
	c04<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2004")
	c06<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2006")
	c08<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2008")
	c10<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Party,PACShort from game where Cycle=2010")

##write table (temp shortcut for dummy)
	game<-data.frame(rbind(c94,c96,c98,c00,c02,c04,c06,c08,c10))

##write table (temp shortcut for dummy)
#write table
#library
	library(XML)
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox backup")
#writing table to csv
	out_file <- file("game.csv", open="a")
	write.table(game, file=out_file, sep=",", dec=".", quote=FALSE, 
	col.names=NA, row.names=TRUE)
	close(out_file)
#check

#load file
	game<-read.csv("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox backup\\game.csv")

#Separate Preferences

#Separate by Cycle

	c94<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=1994")
	c96<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=1996")
	c98<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=1998")
	c00<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2000")
	c02<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2002")
	c04<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2004")
	c06<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2006")
	c08<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2008")
	c10<-sqldf("select Cycle, PACID, CID, FECRecNo,Amount, Date,FECCandID,
		Damount,Ramount,Party,PACShort from game where Cycle=2010")

#Preference	
	d94<-sqldf("select *, sum(Ramount) as RepMoney from c94 group by PACID")
	d96<-sqldf("select *, sum(Ramount) as RepMoney from c96 group by PACID")
	d98<-sqldf("select *, sum(Ramount) as RepMoney from c98 group by PACID")
	d00<-sqldf("select *, sum(Ramount) as RepMoney from c00 group by PACID")
	d02<-sqldf("select *, sum(Ramount) as RepMoney from c02 group by PACID")
	d04<-sqldf("select *, sum(Ramount) as RepMoney from c04 group by PACID")
	d06<-sqldf("select *, sum(Ramount) as RepMoney from c06 group by PACID")
	d08<-sqldf("select *, sum(Ramount) as RepMoney from c08 group by PACID")
	d10<-sqldf("select *, sum(Ramount) as RepMoney from c10 group by PACID")

	e94<-sqldf("select *, sum(Amount) as Total from c94 group by PACID")
	e96<-sqldf("select *, sum(Amount) as Total from c96 group by PACID")
	e98<-sqldf("select *, sum(Amount) as Total from c98 group by PACID")
	e00<-sqldf("select *, sum(Amount) as Total from c00 group by PACID")
	e02<-sqldf("select *, sum(Amount) as Total from c02 group by PACID")
	e04<-sqldf("select *, sum(Amount) as Total from c04 group by PACID")
	e06<-sqldf("select *, sum(Amount) as Total from c06 group by PACID")
	e08<-sqldf("select *, sum(Amount) as Total from c08 group by PACID")
	e10<-sqldf("select *, sum(Amount) as Total from c10 group by PACID")

#game2 data
	g94<-sqldf("select * from e94 join d94 using (PACID)")
	g96<-sqldf("select * from e96 join d96 using (PACID)")
	g98<-sqldf("select * from e98 join d98 using (PACID)")
	g00<-sqldf("select * from e00 join d00 using (PACID)")
	g02<-sqldf("select * from e02 join d02 using (PACID)")
	g04<-sqldf("select * from e04 join d04 using (PACID)")
	g06<-sqldf("select * from e06 join d06 using (PACID)")
	g08<-sqldf("select * from e08 join d08 using (PACID)")
	g10<-sqldf("select * from e10 join d10 using (PACID)")
	
	game2<-data.frame(rbind(g94,g96,g98,g00,g02,g04,g06,g08,g10))

#write table
#library
	library(XML)
	setwd("C:\\Documents and Settings\\Ty\\My Documents\\Corporate Pref\\Dropbox backup")
#writing table to csv
	out_file <- file("game2.csv", open="a")
	write.table(game2, file=out_file, sep=",", dec=".", quote=FALSE, 
	col.names=NA, row.names=TRUE)
	close(out_file)
#check



