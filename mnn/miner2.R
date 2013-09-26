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
# Northeast Pioneer Valley
Northeast.Pioneer.Valley <- sqldf("SELECT * FROM data2 WHERE Region =
'Northeast Pioneer Valley' ORDER BY Sector")
# Southeast
Southeast <-  sqldf("SELECT * FROM data2 WHERE Region = 'Southeast'
ORDER BY Sector")

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Write regions out to a csv                                      # 
#                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Boston
write.csv(MyData, file = "MyData.csv")
# Cape & Islands
write.csv(MyData, file = "MyData.csv")
# Central
write.csv(MyData, file = "MyData.csv")
# Metrowest
write.csv(MyData, file = "MyData.csv")
# Northeast Pioneer Valley
write.csv(Northeast.Pioneer.Valley, file = "NortheastPioneerValley.csv")
# Southeast
write.csv(Southeast, file = "Southeast.csv")
