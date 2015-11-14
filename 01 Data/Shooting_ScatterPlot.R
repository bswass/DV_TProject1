require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(extrafont)

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from shootingsmass"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
View (df)

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_grid(FATALITIES, labeller=label_both) +
  labs(title='Mass Shootings') +
  labs(x="Venue", y=paste("INJURED")) +
  layer(data=df, 
        mapping=aes(x=VENUE, y=as.numeric(as.character(INJURED))), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )

ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  #facet_grid(FATALITIES, labeller=label_both) +
  labs(x="Venue", y=paste("FATALITIES")) +
  layer(data=df, 
        mapping=aes(x=VENUE, y=as.numeric(as.character(FATALITIES))), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        #position=position_identity()
        position=position_jitter(width=0.3, height=0)
  )