###########################
# File: CBS Projections.R
# Description: Downloads Fantasy Football Projections from cbssports.com
# Date: 3/3/2013
# Author: Isaac Petersen (isaactpetersen@gmail.com)
# Notes:
# -These projections are from last year (CBS has not yet updated them for the upcoming season)
###########################

#Load libraries
library("XML")
library("stringr")

#Download fantasy football projections from cbssports.com
qb_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/QB/season", stringsAsFactors = FALSE)[7]$'NULL'
rb1_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/RB/season", stringsAsFactors = FALSE)[7]$'NULL'
rb2_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/RB/season?&start_row=51", stringsAsFactors = FALSE)[7]$'NULL'
wr1_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/WR/season", stringsAsFactors = FALSE)[7]$'NULL'
wr2_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/WR/season?&start_row=51", stringsAsFactors = FALSE)[7]$'NULL'
te_cbs <- readHTMLTable("http://fantasynews.cbssports.com/fantasyfootball/stats/weeklyprojections/TE/season", stringsAsFactors = FALSE)[7]$'NULL'

#Add variable names for each object
names(qb_cbs) <- c("player_cbs","passAtt_cbs","passComp_cbs","passYds_cbs","passTds_cbs","passInt_cbs","passCompPct_cbs","passYdsPerAtt_cbs","rushAtt_cbs","rushYds_cbs","rushYdsPerAtt_cbs","rushTds_cbs","fumbles_cbs","pts_cbs")
names(rb1_cbs) <- names(rb2_cbs) <- c("player_cbs","rushAtt_cbs","rushYds_cbs","rushYdsPerAtt_cbs","rushTds_cbs","rec_cbs","recYds_cbs","recYdsPerRec_cbs","recTds_cbs","fumbles_cbs","pts_cbs")
names(wr1_cbs) <- names(wr2_cbs) <- c("player_cbs","rec_cbs","recYds_cbs","recYdsPerRec_cbs","recTds_cbs","fumbles_cbs","pts_cbs")
names(te_cbs) <- c("player_cbs","rec_cbs","recYds_cbs","recYdsPerRec_cbs","recTds_cbs","fumbles_cbs","pts_cbs")

#Trim dimensions
qb_cbs <- qb_cbs[4:(dim(qb_cbs)[1]-1),]
rb1_cbs <- rb1_cbs[4:(dim(rb1_cbs)[1]-1),]
rb2_cbs <- rb2_cbs[2:(dim(rb2_cbs)[1]-1),]
wr1_cbs <- wr1_cbs[4:(dim(wr1_cbs)[1]-1),]
wr2_cbs <- wr2_cbs[2:(dim(wr2_cbs)[1]-1),]
te_cbs <- te_cbs[4:(dim(te_cbs)[1]-1),]

#Merge within position
rb_cbs <- rbind(rb1_cbs,rb2_cbs)
wr_cbs <- rbind(wr1_cbs,wr2_cbs)

#Add variable for player position
qb_cbs$pos <- as.factor("QB")
rb_cbs$pos <- as.factor("RB")
wr_cbs$pos <- as.factor("WR")
te_cbs$pos <- as.factor("TE")

#Calculate position rank
qb_cbs$positionRank_cbs <- 1:dim(qb_cbs)[1]
rb_cbs$positionRank_cbs <- 1:dim(rb_cbs)[1]
wr_cbs$positionRank_cbs <- 1:dim(wr_cbs)[1]
te_cbs$positionRank_cbs <- 1:dim(te_cbs)[1]

#Merge across positions
projections_cbs <- merge(qb_cbs,rb_cbs, all=TRUE)
projections_cbs <- merge(projections_cbs,wr_cbs, all=TRUE)
projections_cbs <- merge(projections_cbs,te_cbs, all=TRUE)

#Convert variables from character strings to numeric
projections_cbs$fumbles_cbs <- as.numeric(projections_cbs$fumbles_cbs)
projections_cbs$pts_cbs <- as.numeric(projections_cbs$pts_cbs)
projections_cbs$rec_cbs <- as.numeric(projections_cbs$rec_cbs)
projections_cbs$recYds_cbs <- as.numeric(projections_cbs$recYds_cbs)
projections_cbs$recYdsPerRec_cbs <- as.numeric(projections_cbs$recYdsPerRec_cbs)
projections_cbs$recTds_cbs <- as.numeric(projections_cbs$recTds_cbs)
projections_cbs$rushAtt_cbs <- as.numeric(projections_cbs$rushAtt_cbs)
projections_cbs$rushYds_cbs <- as.numeric(projections_cbs$rushYds_cbs)
projections_cbs$rushYdsPerAtt_cbs <- as.numeric(projections_cbs$rushYdsPerAtt_cbs)
projections_cbs$rushTds_cbs <- as.numeric(projections_cbs$rushTds_cbs)
projections_cbs$passAtt_cbs <- as.numeric(projections_cbs$passAtt_cbs)
projections_cbs$passComp_cbs <- as.numeric(projections_cbs$passComp_cbs)
projections_cbs$passYds_cbs <- as.numeric(projections_cbs$passYds_cbs)
projections_cbs$passTds_cbs <- as.numeric(projections_cbs$passTds_cbs)
projections_cbs$passInt_cbs <- as.numeric(projections_cbs$passInt_cbs)
projections_cbs$passCompPct_cbs <- as.numeric(projections_cbs$passCompPct_cbs)
projections_cbs$passYdsPerAtt_cbs <- as.numeric(projections_cbs$passYdsPerAtt_cbs)

#Player names
projections_cbs$name <- str_sub(projections_cbs$player, end=str_locate(string=projections_cbs$player, ',')[,1]-1)

#Player teams
projections_cbs$team_cbs <- str_trim(str_sub(projections_cbs$player, start= -3))

#Calculate overall rank
projections_cbs$overallRank_cbs <- rank(-projections_cbs$pts_cbs, ties.method="min")

#Order variables in data set
projections_cbs <- projections_cbs[,c("name","pos","team_cbs","positionRank_cbs","overallRank_cbs",
                                      "passAtt_cbs","passComp_cbs","passYds_cbs","passTds_cbs","passInt_cbs","passCompPct_cbs","passYdsPerAtt_cbs",
                                      "rushAtt_cbs","rushYds_cbs","rushYdsPerAtt_cbs","rushTds_cbs",
                                      "rec_cbs","recYds_cbs","recYdsPerRec_cbs","recTds_cbs","fumbles_cbs","pts_cbs")]

#Order players by overall rank
projections_cbs <- projections_cbs[order(projections_cbs$overallRank_cbs),]
row.names(projections_cbs) <- 1:dim(projections_cbs)[1]

#Save file
save(projections_cbs, file = paste(getwd(),"/Data/CBS-Projections-2012.RData", sep=""))