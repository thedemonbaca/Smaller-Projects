# Tyler Brown, 9/12/13
# 
# Task:
# Produce  cross-tabulations of non-members by region and sector to
# determine the "richest veins to mine" for MNN to increase their
# membership.
#
# The results should be conducted on the MNN target organizations meeting
# following criteria:
#  >50000  budget in 2011
# [Use the "NCCS_2011_Budget" column to filter]
#  501c3 or 501c4.  (use the "Designation.501c" column to filter.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Libaries
library(sqldf)
library(vcd)

# Load data
data1 <- read.csv("/home/ty/code/Smaller-Projects/mnn/irsbmf_201307_ma_v14_JM_DEV.csv")

# Here's the columns that Jeff suggested as most interesting:
# Region
# Sector
# NCCS_2011_Budget

# Filter out organizations < 50,000 budget
data2 <- sqldf("SELECT * FROM data1 WHERE NCCS_2011_Budget > 50000")

# Let's check out the data
summary(data2$NCCS_2011_Budget)
plot(data2$NCCS_2011_Budget)

summary(data2$Region)
summary(data2$Sector)
summary(data2$MNN_Name)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Create separate tables for each region. Order by sector within  # 
# region.                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

Berkshire <- sqldf("SELECT * FROM data2 WHERE Region = 'Berkshire'
ORDER BY Sector")
summary(Berkshire$Region)

# No entries found for Boston Cape & Islands
Boston <- sqldf("SELECT * FROM data2 WHERE Region =
'Boston' ORDER BY Sector")
summary(Boston$Region)

# Cape & Islands
Cape.Island <- sqldf("SELECT * FROM data2 WHERE Region =
'Cape & Islands' ORDER BY Sector")
summary(Cape.Island$Region)

Central <- sqldf("SELECT * FROM data2 WHERE Region = 'Central' ORDER
BY Sector")
summary(Central$Region)

Metrowest <- sqldf("SELECT * FROM data2 WHERE Region = 'Metrowest' ORDER
BY Sector")
summary(Metrowest$Region)

# No entries found for Northeast Pioneer Valley
Northeast.Pioneer.Valley <- sqldf("SELECT * FROM data2 WHERE Region =
'Northeast Pioneer Valley' ORDER BY Sector")
summary(Northeast.Pioneer.Valley$Region)

Southeast <-  sqldf("SELECT * FROM data2 WHERE Region = 'Southeast'
ORDER BY Sector")
summary(Southeast$Region)

# # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Do crosstabs to see relationships b/t budget & sector  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# #  #  #  #  #  #  #  #  #  #  # #
# 2-Way Frequency Table by region #
# #  #  #  #  #  #  #  #  #  #  # # 

# Having trouble with data types here !!

# Berkshire
mytable <- cbind(Berkshire$Sector, Berkshire$NCCS_2011_Budget)
xtabs(V2~V1, data =mytable)# A frequencies (summed over B)

# Boston.Cape.Island
mytable <- cbind(Boston.Cape.Island$Sector,
                 Boston.Cape.Island$NCCS_2011_Budget)
margin.table(mytable, 1)# A frequencies (summed over B)

# Central
mytable <- cbind(Central$Sector, Central$NCCS_2011_Budget)
margin.table(mytable, 1)# A frequencies (summed over B)

# Metrowest
mytable <- cbind(Metrowest$Sector, Metrowest$NCCS_2011_Budget)
margin.table(mytable, 1)# A frequencies (summed over B)

# Northeast.Pioneer.Valley
mytable <- cbind(Northeast.Pioneer.Valley$Sector,
                 Northeast.Pioneer.Valley$NCCS_2011_Budget)
margin.table(mytable, 1)# A frequencies (summed over B)

# Southeast
mytable <- cbind(Southeast$Sector, Southeast$NCCS_2011_Budget)
margin.table(mytable, 1)# A frequencies (summed over B)
