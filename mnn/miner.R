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

# Load data
data1 <- read.csv("/home/ty/workspace/mnn/irsbmf_201307_ma_v14_JM_TEST.csv")

# Filter out organizations < 50,000 budget
data2 <- sqldf("SELECT * FROM data1 WHERE NCCS_2011_Budget > 50000")

# Let's check out the data
summary(data2$NCCS_2011_Budget)
plot(data2$NCCS_2011_Budget)

# Try to filter on the "Designation.501c" column
summary(data2$Designation.501c)

# The "Designation.501c" column returns a null value
# so let's try some other stuff and maybe go with that

# Get the names of the columns
names(data2)

# Looks like "Designation_501c" might be what we wanted.
# "MNN_Name" also looks interesting.

summary(data2$Designation_501c)
data2$MNN_Name[0:300]
