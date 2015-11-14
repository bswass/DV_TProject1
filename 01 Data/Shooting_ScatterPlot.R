require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(extrafont)
library(reshape2)

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from shootingsmass"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
summary(df)
head(df)

df.m = melt(df, id.vars ="TOTAL_VICTIMS", measure.vars = c("FATALITIES","INJURED"))
df.m$VENUE = df$VENUE
View(df.m)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_grid(~FATALITIES) +
  labs(title='Mass Shootings') +
  labs(x="Venue", y=paste("Count Of Fatalities/Injured")) +
  layer(data=df.m, 
        mapping=aes(x=VENUE, y=value, color=variable), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  ) 