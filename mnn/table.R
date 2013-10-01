# Here we go

# Load functions
setwd("/home/ty/code/Smaller-Projects/mnn/")
source("irs.R")
# Load data
mnn.dat <- mnn.load.targ.dat("irsbmf_201307_ma_v15_JM.csv")

# other stuff
budget.levels <-c("Under 25k", "25k-75k", "75k-250k", "250k-750k", "750k-2.5m", "2.5m-10m", "10m-25m","25m-50m",
                "50m-100m","100m-200m","200m-500m", "Over 500m")
bl <- factor(mnn.dat$NCCS_2011_Budget.Level, levels=budget.levels)
table(mnn.dat$Region, bl)



