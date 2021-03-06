# Tyler Brown, 9/8/13
# This code tries to understand whether there are any duplicates
# in the data. I didn't use the right column but maybe some of this
# can be recycled to meet another need.
#
# File input

data <- read.csv("/home/ty/workspace/mnn/irsbmf_201307_ma_v13_JM.csv")

# Let's see if there's duplicate names
names(data)

library(sqldf)
# Find duplicates by name
duplicates <- sqldf("SELECT Name, COUNT(Name) AS N FROM data GROUP BY Name")

# Find out the distribution of duplicates
count.duplicates <- sqldf("SELECT N, COUNT(N) AS Dist FROM duplicates
GROUP BY N")

# Plot it
plot(count.duplicates$Dist, count.duplicates$N)

# There's an outlier in count.duplicates$Dist so let's zoom in a bit
# Now let's plot it agaxin & limit the y axis
plot(count.duplicates, type="o", col="blue", ylim=c(0,300))
# Get the descriptive statistics
summary(count.duplicates)
summary(duplicates)

# Alright, now let's make it look nice and tell a story

# Create a title with a red, bold/italic font
plot(count.duplicates, type="o", col="blue", ann=FALSE, ylim=c(0,300))
title(main="How many duplicate names are in the data?",
      xlab="Number of duplicate names",
      ylab="Count of names with duplicates",
      col.main="red", font.main=4)
# In terms of percentages, how many names have duplicates?
ok.duplicates <- sqldf(c("UPDATE 'duplicates' SET N = 3
WHERE N > 2","SELECT * FROM duplicates"))

percent.duplicates <- sqldf("SELECT N, COUNT(N) AS Number FROM
'ok.duplicates' GROUP BY N")

# Pie Chart with pecentages
slices <- percent.duplicates$Number
lbls <- c("None", "One", "> One")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels
lbls <- paste(lbls,"%",sep="") # ad % to labels
pie(slices,labels = lbls, col=rainbow(length(lbls)),
   main="Pie Chart of Duplicates") 




# Might as well up our game
library(plotrix)
pie3D(pct,radius=1,height=0.1,
   main="Pie Chart of Duplicates")
color.legend(11,6,11.8,9,lbls,pct,gradient="y")


