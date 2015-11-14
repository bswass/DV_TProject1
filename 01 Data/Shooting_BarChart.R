require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

KPI_High_Max_value = .666
KPI_Medium_Max_value = .4

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
                                                "select YEARINC, RACE, sum_fatalities, sum_total, kpi as ratio, DATEINC,
                                                case
                                                when kpi > "p1" then \\\'01 High Fatality\\\'
                                                when kpi > "p2" then \\\'02 Medium Fatality\\\'
                                                else \\\'03 Low Fatality\\\'
                                                end kpi
                                                from (select YEARINC, RACE, 
                                                sum(FATALITIES) as sum_fatalities, sum(TOTAL_VICTIMS) as sum_total,
                                                sum(FATALITIES) / sum(TOTAL_VICTIMS) as kpi, DATEINC
                                                from shootingsmass
                                                group by YEARINC, DATEINC, RACE)
                                                order by YEARINC desc;"
                                                ')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', 
                                                                  USER='C##cs329e_btb687', PASS='orcl_btb687', MODE='native_mode', 
                                                                  MODEL='model', returnDimensions = 'False', returnFor = 'JSON', 
                                                                  p1=KPI_High_Max_value, p2=KPI_Medium_Max_value), verbose = TRUE))); View(df)

df$DATEINC <- as.Date(df$DATEINC,format='%m/%d/%Y')
View(df$DATEINC)


ggplot() + 
  coord_cartesian() + 
  scale_x_date() +
  scale_y_continuous() +
  labs(title='BarChart') +
  labs(x=paste("YEAR"), y=paste("FATALITY RATIO")) +
  geom_bar(position="dodge") +
  
  layer(data=df, 
        mapping=aes(x=DATEINC, y= RATIO, ymax=max(1)*1.05 ), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="black"), 
        position=position_identity()
        
  ) + coord_flip() + 
  #labels
  layer(data=df, 
        mapping=aes(x=DATEINC, y=RATIO, label=round(RATIO,4), ymax=max(1)*1.05 ), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(colour="black", hjust=-0.5), 
        position=position_identity()
  ) +
  #Color
  layer(data=df, 
        mapping=aes(x=DATEINC, y=RATIO, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  ) +  
  #H-line
  layer(data=df, 
        mapping=aes(yintercept = mean(RATIO)), 
        geom="hline",
        geom_params=list(colour="red")
  )