# Reference: http://www.statmethods.net/stats/frequencies.html

# Load functions
setwd("/home/ty/code/Smaller-Projects/mnn/")
source("irs.R")
# Load data
mnn.dat <- mnn.load.targ.dat("irsbmf_201307_ma_v15_JM.csv")

# other stuff
budget <-c("Under 25k", "25k-75k", "75k-250k", "250k-750k", "750k-2.5m", "2.5m-10m", "10m-25m","25m-50m",
                "50m-100m","100m-200m","200m-500m", "Over 500m")

## Jeff suggestions
bl <- factor(mnn.dat$NCCS_2011_Budget.Range, levels=budget.levels)
mytable <- table(mnn.dat$Region, bl)

## Picking up from reference
prop.table(mytable) # cell percentages
prop.table(mytable, 1) # row percentages
prop.table(mytable, 2) # column percentages 

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Here's what I have in mind


# Figure 1: Comparison of Region, Budget Range, and MNN Status
# 3-Way Frequency Table
mytable2 <- table(mnn.dat$Region, bl, mnn.dat$MNN.Status)
ftable(mytable2)

# Figure 2: Sum of table entries for a given index
margin.table(mytable2, 1) # mnn.dat$Region frequencies (summed over bl)
margin.table(mytable2, 2) # bl frequencies (summed over mnn.dat$Region)
margin.table(mytable2, 3) # mnn.dat$MNN.Status (summed over mnn.dat$Region)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
