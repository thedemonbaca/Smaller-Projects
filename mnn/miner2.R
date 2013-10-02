# Tyler Brown, 9/12/13
# 
# Task:
# Produce  cross-tabulations of non-members by region and sector to
# determine the "richest veins to mine" for MNN to increase their
# membership.
#
# The results should be conducted on the MNN target organizations meeting
# following criteria:
#  >50000  budget in 2011 <10mil
# [Use the "NCCS_2011_Budget" column to filter]
#  501c3 or 501c4.  (use the "Designation.501c" column to filter.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Libaries
library(sqldf)
library(ggplot2)
library(reshape2)
library(plyr)

# Load data
setwd("/home/ty/code/Smaller-Projects/mnn/")
data1 <- read.csv("irsbmf_201307_ma_v15_JM.csv")


# Grab data the data they want #
# Filter out organizations < $50k budget < $10mil
data2 <- sqldf("SELECT * FROM data1 WHERE NCCS_2011_Budget > 50000
AND NCCS_2011_Budget < 10000000")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Create separate tables for each region. Order by sector within  # 
# region.                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Boston
Boston <- sqldf("SELECT * FROM data2 WHERE Region =
'Boston' ORDER BY Sector")
# Cape & Islands
Cape.Island <- sqldf("SELECT * FROM data2 WHERE Region =
'Cape & Islands' ORDER BY Sector")
# Central
Central <- sqldf("SELECT * FROM data2 WHERE Region = 'Central' ORDER
BY Sector")
# Metrowest
Metrowest <- sqldf("SELECT * FROM data2 WHERE Region = 'Metrowest' ORDER
BY Sector")
# Northeast
Northeast <- sqldf("SELECT * FROM data2 WHERE Region =
'Northeast' ORDER BY Sector")
# Pioneer Valley
Pioneer.Valley <- sqldf("SELECT * FROM data2 WHERE Region =
'Pioneer Valley' ORDER BY Sector")
# Southeast
Southeast <-  sqldf("SELECT * FROM data2 WHERE Region = 'Southeast'
ORDER BY Sector")
# Berkshire
Berkshire <-  sqldf("SELECT * FROM data2 WHERE Region = 'Berkshire'
ORDER BY Sector")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Write regions out to a csv                                      # 
#                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

setwd("/home/ty/code/Smaller-Projects/mnn/csv_data/")

# Boston
write.csv(Boston, file = "Boston.csv")
# Cape & Islands
write.csv(Cape.Island, file = "CapeIsland.csv")
# Central
write.csv(Central, file = "Central.csv")
# Metrowest
write.csv(Metrowest, file = "Metrowest.csv")
# Northeast 
write.csv(Northeast, file = "Northeast.csv")
# Pioneer Valley
write.csv(Pioneer.Valley, file = "PioneerValley.csv")
# Southeast
write.csv(Southeast, file = "Southeast.csv")
# Berkshire
write.csv(Berkshire, file = "Berkshire.csv")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Count number of MNN Members                                     # 
#                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Boston
Boston.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Boston' AND MNN_Name != 'NA' GROUP BY MNN_Name")
Boston.A
# Cape & Islands
CapeIslands.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Cape & Islands' AND MNN_Name != 'NA' GROUP BY MNN_Name")
CapeIslands.A
# Central
Central.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Central' AND MNN_Name != 'NA' GROUP BY MNN_Name")
Central.A
# Metrowest
Metrowest.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Metrowest' AND MNN_Name != 'NA' GROUP BY MNN_Name")
Metrowest.A
# Northeast Pioneer Valley
NortheastPioneerValley.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Northeast Pioneer Valley' AND MNN_Name != 'NA' GROUP BY MNN_Name")
NortheastPioneerValley.A
# Southeast
Southeast.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Southeast' AND MNN_Name != 'NA' GROUP BY MNN_Name")
Southeast.A
# Berkshire
Berkshire.A <-  sqldf("SELECT MNN_Name, COUNT(MNN_Name) FROM data2 WHERE
Region = 'Berkshire' AND MNN_Name != 'NA' GROUP BY MNN_Name")
Berkshire.A

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Visualization                                                   # 
#                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Description:
#  We're going to use color so we can compare R3 instead of R2 
# x: location
# y: count
# z: budget

# x: location
#  Let's use Region
#
# y: count
#  Let's use a count of Region
# z: budget
#  Let's use NCCS_2011_Budget.Range

ggplot(data2, aes(data2$NCCS_2011_Budget.Range, fill = data2$Region )) + geom_bar()+
    labs(title="Figure1: Roughly the Same Laptop Hardware")

