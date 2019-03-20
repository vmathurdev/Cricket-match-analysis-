# Loading dependent packages and libraries

install.packages("tidyverse")
install.packages("ggplot2")
library(tidyr)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(readr)
library(dplyr)
library(scales)
library(reshape2)


# Checking current directory
getwd()
# Setting destination directory
setwd("C:/Users/vmathur9/Documents/Cricket project")

# Reading the CSV file
cricket <- read.csv("CricketData.csv", stringsAsFactors = FALSE)

# Look at the structure of cricket data"
str(cricket)

# Viewing the tabular structure of cricket data
View(cricket)

# Converting Match Date to Year
cricket$year <- str_sub(cricket$Match.Date,-4)
cricket$year <- as.numeric(cricket$year)
head(cricket)

# Viewing the tabular structure of cricket data post match date conversion
View(cricket)

# Subsetting the data to include only matches where India is the host or visiting team
cricket.1 <- cricket [which(cricket$Team.1=="India" | cricket$Team.2=="India"),]

# Look at the structure of filtered cricket data and view the new data"
str(cricket.1)
View(cricket.1)

# Checking whether the Winner column has any blank entries
sum(is.na(cricket.1$Winner))

# Identifying transaction where result is either winner, tie, blank, no result
cricket.1$Winning_team<- ifelse(cricket.1$Winner==cricket.1$Team.1,cricket.1$Winner,
ifelse(cricket.1$Winner==cricket.1$Team.2,cricket.1$Winner,"No result"))

# Setting win/lost status for India
cricket.1$ind_win_status<- ifelse(cricket.1$Winning_team=="India","win",
      ifelse(cricket.1$Winning_team=="No result","none","lost"))

# Setting team type (host/visitor) in  a new colum
cricket.1$team_type <- ifelse(cricket.1$Team.1=="India","Home","Visitor")
View(cricket.1)


# Write a new working file in the destination directory
write.csv(cricket.1, file = "Cricket.1.csv", row.names = FALSE)
cricket.1 <- read.csv("Cricket.1.csv", stringsAsFactors = FALSE)

# Total number of matches India played
nrow(cricket.1)

# Number of matches India Win
sum(cricket.1$Winning_team=="India")

# Number of matches India Lost
nlost <- nrow(cricket.1) - ((sum(cricket.1$Winning_team == "India")) + (sum(cricket.1$Winning_team == "No result")))
nlost

# India winning Percentage
ind_win_perc <- as.data.frame(table(cricket.1$ind_win_status))
ind_win_perc
names(ind_win_perc)[1] = "Status"
head(ind_win_perc)
indiawon <- ind_win_perc %>%
  mutate(ad=sum(Freq))%>%
  mutate(ind.win = round((Freq/ad)*100,2))
indiawon
View(cricket.1)

# Examining % India won when it was a home or host team
tab.1 <- table(cricket.1$team_type,cricket.1$ind_win_status)
tab.1.df <- as.data.frame(round(prop.table(tab.1, margin = 1)*100,0))
names(tab.1.df)[1]="TeamType"
names(tab.1.df)[2]="Result"
names(tab.1.df)[3]="Win%"
tab.1.df
tab.2.df <- subset(tab.1.df, tab.1.df$Result=="win")
tab.2.df$Result<-NULL
tab.2.df

# Plot-% India won when it was a home or host team
ggplot(data=tab.2.df, aes(x=tab.2.df$TeamType, y=tab.2.df$`Win%`))+
  geom_bar(stat="identity",fill="steelblue", width = 0.5)+
  geom_text(aes(label=paste0(tab.2.df$`Win%`,"%")),vjust=1.5, color="white", size=3.5, position = "stack")+
  labs(x="Team Type-India" , y="win%")+
  ggtitle("% India won when it was a home or host team")+
  theme_minimal()+
  theme(plot.title = element_text(color="steelblue", size=12))

# Percentage of Matches India Won annually
annual.trend.table <- table(cricket.1$year,cricket.1$ind_win_status)
annual.trend.table
annual.trend.df<-as.data.frame(round(prop.table(annual.trend.table,margin = 1)*100,0))
annual.trend.df
annual.trend <-annual.trend.df[annual.trend.df$Var2=="win",]
annual.trend$Var2 <- NULL
names(annual.trend)[1]="Year"
names(annual.trend)[2]="Winning %"
head(annual.trend)

# Plot-Percentage of Matches India Won annually
ggplot(data=annual.trend, aes(x=annual.trend$Year, y=annual.trend$`Winning %`, group=1))+
  geom_line(color="steelblue")+geom_abline(color="red")+
  xlab("Year")+
  ylab ("Winning %")+
  ggtitle("India winning trend over the years")+
  theme_minimal()+
  theme(plot.title = element_text(color="steelblue", size=12))+
  theme(axis.text.x=element_text(size=rel(1), angle=90))


# Table showing the win/loss number for India by opponent
cricket.1$opponent<-ifelse(cricket.1$ind_win_status=="lost",cricket.1$Winning_team,
  ifelse(cricket.1$ind_win_status=="win",ifelse(cricket.1$Team.1=="India",cricket.1$Team.2,cricket.1$Team.1),"none"))
head(cricket.1)
opponent.df<-as.data.frame(table(cricket.1$opponent,cricket.1$ind_win_status))
names(opponent.df)[1]="Opponent"
names(opponent.df)[2]="Result"
names(opponent.df)[3]="Played"
opponent.df
opponent.df.table <- dcast(opponent.df,Opponent~opponent.df$Result,value.var = "Played")
opponent.df.table$none=NULL
opponent.df.table.1 <- opponent.df.table %>%
  rowwise()%>%
  filter(Opponent!="none")
head(opponent.df.table.1)

# Plot-win/loss count by opponent
opponent.df.table.m<-melt(opponent.df.table.1)
opponent.df.table.m
ggplot(data=opponent.df.table.m, aes(x=opponent.df.table.m$Opponent, y=value, fill=variable))+
  geom_bar(stat="identity")+
  geom_text(aes(label=opponent.df.table.m$value),hjust=1, color="white", size=3, position = "stack")+
  labs(x="Opponent" , y="win/loss count")+
  coord_flip()+
  ggtitle("Win/Loss Count for India by Opponent")+
  theme(plot.title = element_text(color="steelblue", size=12))


# Sorting the table by number of matches played with the opponent in decreasing order
sort.played <- opponent.df.table.1%>%
  mutate(total= sum(lost + win))
sort.played
sort.played.display <- sort.played[order(sort.played$total, decreasing = T),]
head(sort.played.display)

# Plot-Total number of matches played with the opponent in decreasing order
ggplot(data=sort.played.display, aes(x=reorder(sort.played.display$Opponent,sort.played.display$total), 
                                     y=sort.played.display$total))+
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=sort.played.display$total), hjust=-0.5, color="black", size=3)+
  labs(x="Opponent" , y="Count of Matches played")+
  coord_flip()+
  ggtitle("Total number of matches India played with the Opponent")+
  theme_minimal()+
  theme(plot.title = element_text(color="steelblue",size=12))

# Top 3 opponents in terms of number of matches India won
sort.top3op <- sort.played%>%
  mutate(ind_winpercent=round(100*win/total,0))
sort.top3op
sort.top3op.display <-sort.top3op[order(sort.top3op$win, decreasing = T),]
sort.top3op.display <-sort.top3op.display [1:3,]
head(sort.top3op.display)

# Plot-Top 3 opponents in terms of number of matches India won
ggplot(sort.top3op.display)  + 
  geom_bar(aes(x=sort.top3op.display$Opponent, y=sort.top3op.display$win),stat="identity", fill="lightblue",width = 0.5, color="grey")+
  geom_line(aes(x=sort.top3op.display$Opponent, y=sort.top3op.display$ind_winpercent),stat="identity",color="steelblue", group=1)+
  geom_text(aes(label=sort.top3op.display$win, x=sort.top3op.display$Opponent, y=sort.top3op.display$win), 
            colour="black", vjust=1.5, size=3)+
  geom_text(aes(label=paste0(sort.top3op.display$ind_winpercent,"%"), x=sort.top3op.display$Opponent, y=sort.top3op.display$ind_winpercent), 
            colour="black",vjust=-.5, size=3)+
  scale_y_continuous(sec.axis = sec_axis(~.*1, name="Win %"))+
  labs(x="Opponent" , y="Wining Count")+
  ggtitle(expression(atop("Top 3 opponents ~ Number of matches India won & Winning % ",
                          atop(italic("Maximum wins against Srilanka followed by England and West Indies"),""))))+
  theme_minimal()+
  theme(plot.title = element_text(color="steelblue",size=12, hjust=.5))

# Teams with highest winning percentage against india
sort.hwp <- sort.played.display%>%
  mutate(opponent_winpercent = round(100*lost/total,0))
sort.hwp$lost=NULL
sort.hwp$win=NULL
sort.hwp$total=NULL
sort.hwp
sort.hwp.display <- sort.hwp[order(sort.hwp$opponent_winpercent, decreasing = T),]
head(sort.hwp.display)

# Plot-Teams with highest winning percentage against india
ggplot(data=sort.hwp.display, aes(x=reorder(sort.hwp.display$Opponent,sort.hwp.display$opponent_winpercent), 
                                     y=sort.hwp.display$opponent_winpercent))+
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=paste0(sort.hwp.display$opponent_winpercent,"%")), hjust=-0.5, color="black", size=3)+
  labs(x="Opponent" , y="Winning %")+
  coord_flip()+
  ggtitle("Teams by highest winning percentage against India")+
  theme_minimal()+
  theme(plot.title = element_text(color="steelblue",size=12))




