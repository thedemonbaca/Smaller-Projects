## Business cards heatmap

library(reshape)
library(d3heatmap) # has bugs

# data
contacts <- read.csv("Contacts - Business Cards.csv")
                                      
# manipulation
contacts.m <- melt(cbind(contacts["City"], contacts["Industry"]),
                   id=("Industry"))
contacts.h <- cast(contacts.m, Industry ~ ., summary)

# plot
d3heatmap(contacts.h, Rowv=FALSE, Colv=FALSE,
          colors = "Spectral", theme="dark",
          xaxis_height= 110, yaxis_width=130,
          yaxis_font_size = 14)
