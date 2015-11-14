require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(extrafont)
library(reshape2)

df <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select YEARINC, sum_fatalities from (select YEARINC, sum(FATALITIES) as sum_fatalities from shootingsmass group by YEARINC) order by YEARINC;"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df2 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select YEARINC, HOMICIDES from HOMICIDES"'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

df3 <- dplyr::inner_join(df, df2, by="YEARINC") 

ggplot() + 
  coord_cartesian() + 
  #facet_grid(~FATALITIES) +
  labs(title='Mass Shootings of Homicides per Year') +
  labs(x="Year", y=paste("Homicides (per year)")) +
  layer(data=df3, 
        mapping=aes(x=YEARINC, y=as.numeric(HOMICIDES)), 
        stat="identity", 
        stat_params=list(), 
        geom="line",
        geom_params=list(), 
        position=position_identity()
  ) 

ggplot() + 
  coord_cartesian() + 
  #facet_grid(~FATALITIES) +
  labs(title='Mass Shootings of Fatalities per Year') +
  labs(x="Year", y=paste("Fatalities (per year)")) +
  layer(data=df3, 
        mapping=aes(x=YEARINC, y=SUM_FATALITIES), 
        stat="identity", 
        stat_params=list(), 
        geom="line",
        geom_params=list(), 
        position=position_identity()
  ) 