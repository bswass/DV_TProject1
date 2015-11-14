require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(tidyr)

# These will be made to more resemble Tableau Parameters when we study Shiny.
KPI_High_Max_value = .6666     
KPI_Medium_Max_value = .4

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                "select YEARINC, RACE, sum_fatalities, sum_total, kpi as ratio,
                                                case
                                                when kpi > "p1" then \\\'01 High Fatality\\\'
                                                when kpi > "p2" then \\\'02 Medium Fatality\\\'
                                                else \\\'03 Low Fatality\\\'
                                                end kpi
                                                from (select YEARINC, RACE,
                                                sum(FATALITIES) as sum_fatalities, sum(TOTAL_VICTIMS) as sum_total,
                                                sum(FATALITIES) / sum(TOTAL_VICTIMS) as kpi
                                                from shootingsmass
                                                group by YEARINC, RACE)
                                                order by YEARINC desc;"
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', 
                                                                  USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', 
                                                                  MODEL='model', returnDimensions = 'False', returnFor = 'JSON', 
                                                                  p1=KPI_High_Max_value, p2=KPI_Medium_Max_value), verbose = TRUE))); View(df)


spread(df, RACE, SUM_TOTAL) %>% View

ggplot() + 
  coord_cartesian()  +
  scale_x_discrete() +
  labs(title='Shootings Crosstab\nSUM_TOTAL') +
  labs(x=paste("RACE(group)"), y=paste("YEAR")) +
  layer(data=df, 
        mapping=aes(x=RACE, y=YEARINC, label=SUM_TOTAL), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=RACE, y=YEARINC, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  )