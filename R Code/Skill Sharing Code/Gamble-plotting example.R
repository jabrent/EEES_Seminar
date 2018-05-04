#This script creates figures that show habitat occupancy for each stock. Separate graphs for 2014 and 2015.
#Written by Madi Gamble 100917


setwd("~/Documents/Grad School/UW SAFS/SSMSP/Data")
#read 2014 data from database
file14 <- read.csv("SSMSP2014 Salmon Processing 100717.csv", header=TRUE)
#read 2015 data from database
file15 <- read.csv("SSMSP2015 Salmon Processing 100717.csv", header=TRUE)

#==================================Data Manipulation===================================================
#get rid of non-cohort fish
file14 <- file14[!(file14$Cohort.name==""),]
file15 <- file15[!(file15$Cohort.name==""),]
unique(file14$Cohort.name)
unique(file15$Cohort.name)

#get rid of any lifestages other than Estuary, Nearshore, Offshore
file14 <- file14[(file14$Lifestage=="Estuary" | file14$Lifestage=="Nearshore" | 
                       file14$Lifestage=="Offshore"),]
unique(file14$Lifestage)

file15 <- file15[(file15$Lifestage=="Estuary" | file15$Lifestage=="Nearshore" | 
                       file15$Lifestage=="Offshore"),]
unique(file15$Lifestage)

#get rid of Lampara and Ricker fish
file14 <- file14[!(file14$Gear.Type=="Lampara" | file14$Gear.Type=="Trawl-Ricker"),]
unique(file14$Gear.Type)
file15 <- file15[!(file15$Gear.Type=="Lampara" | file15$Gear.Type=="Trawl-Ricker"),]
unique(file15$Gear.Type)

#get rid of unused levels
file14 <- droplevels(file14)
file15 <- droplevels(file15)


setwd("~/Documents/Grad School/UW SAFS/SSMSP/Analyses Maps Figures/Habitat Occupancy")
#===============================================YEAR 2014===================================================
par(mfrow = c(3,3), mar = c(1,0,1,0), oma = c(4,4,1,1), bty = "l")

#NS Kendall
#subset for stock
NSKendall <- file14[file14$Cohort.name=="NKKndl",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSKendall$Julian.Date ~ NSKendall$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Nooksack Kendall Creek", side = 3, adj = 0, line = -0.5)

#NS Skookum
NSSkookum <- file14[file14$Cohort.name=="NKSkook",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSSkookum$Julian.Date ~ NSSkookum$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Nooksack Skookum Creek", side = 3, adj = 0, line = -0.5)

#NS Fall
NSFall <- file14[file14$Cohort.name=="NKFallGSI",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSFall$Julian.Date ~ NSFall$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Nooksack Fall (N)", side = 3, adj = 0, line = -0.5)

#SK Spring
SKSpring <- file14[file14$Cohort.name=="SKMrblSpr",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKSpring$Julian.Date ~ SKSpring$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Skagit Spring", side = 3, adj = 0, line = -0.5)

#SK Summer
SKSummer <- file14[file14$Cohort.name=="SKMrblSum",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKSummer$Julian.Date ~ SKSummer$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Skagit Summer", side = 3, adj = 0, line = -0.5)

#SK Upper Summer
SKUppSum <- file14[file14$Cohort.name=="SKUpSum",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKUppSum$Julian.Date ~ SKUppSum$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = F)
mtext(text = "Upper Skagit Summer (N)", side = 3, adj = 0, line = -0.5)

#SN Tulalip
SNTulalip <- file14[file14$Cohort.name=="SnTul",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SNTulalip$Julian.Date ~ SNTulalip$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(65,287,20), labels = T, cex.axis = 1.5)
mtext(text = "Snohomish Tulalip", side = 3, adj = 0, line = -0.5)

#SN Wallace
SNWallace <- file14[file14$Cohort.name=="SnWal",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SNWallace$Julian.Date ~ SNWallace$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = T, cex.axis = 1.5)
mtext(text = "Snohomish Wallace", side = 3, adj = 0, line = -0.5)

#NQ ClrCrk
NQClrCrk <- file14[file14$Cohort.name=="NQClCr",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NQClrCrk$Julian.Date ~ NQClrCrk$Lifestage, horizontal = T, frame = F, ylim = c(65,290),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(65,287,20), labels = T, cex.axis = 1.5)
mtext(text = "Nisqually Clear Creek", side = 3, adj = 0, line = -0.5)

#axis labels
mtext(text = "Day of Year", side = 1, cex = 1.5, outer = T, line = 2)
mtext(text = "Habitat", side = 2, cex = 1.5, outer = T, line = 2)


#================================================YEAR 2015===================================================
par(mfrow = c(3,3), mar = c(1,0,1,0), oma = c(4,4,1,1), bty = "l")

#NS Kendall
#subset for stock
NSKendall <- file15[file15$Cohort.name=="NKKndl",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSKendall$Julian.Date ~ NSKendall$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Nooksack Kendall Creek", side = 3, adj = 0, line = -0.5)

#NS Skookum
NSSkookum <- file15[file15$Cohort.name=="NKSkook",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSSkookum$Julian.Date ~ NSSkookum$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Nooksack Skookum Creek", side = 3, adj = 0, line = -0.5)

#NS Fall
NSFall <- file15[file15$Cohort.name=="NKFallGSI",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NSFall$Julian.Date ~ NSFall$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Nooksack Fall (N)", side = 3, adj = 0, line = -0.5)

#SK Spring
SKSpring <- file15[file15$Cohort.name=="SKMrblSpr",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKSpring$Julian.Date ~ SKSpring$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Skagit Spring", side = 3, adj = 0, line = -0.5)

#SK Summer
SKSummer <- file15[file15$Cohort.name=="SKMrblSum",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKSummer$Julian.Date ~ SKSummer$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Skagit Summer", side = 3, adj = 0, line = -0.5)

#SK Upper Summer
SKUppSum <- file15[file15$Cohort.name=="SKUpSum",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SKUppSum$Julian.Date ~ SKUppSum$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = F)
mtext(text = "Upper Skagit Summer (N)", side = 3, adj = 0, line = -0.5)

#SN Tulalip
SNTulalip <- file15[file15$Cohort.name=="SnTul",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SNTulalip$Julian.Date ~ SNTulalip$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", names = c("E", "N", "O"), las = 1, cex.axis = 1.5)
axis(side = 1, at = seq(45,285,20), labels = T, cex.axis = 1.5)
mtext(text = "Snohomish Tulalip", side = 3, adj = 0, line = -0.5)

#SN Wallace
SNWallace <- file15[file15$Cohort.name=="SnWal",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = SNWallace$Julian.Date ~ SNWallace$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = T, cex.axis = 1.5)
mtext(text = "Snohomish Wallace", side = 3, adj = 0, line = -0.5)

#NQ ClrCrk
NQClrCrk <- file15[file15$Cohort.name=="NQClCr",]
#horizontal box plots of DOY catch date, 1 per habitat
boxplot(formula = NQClrCrk$Julian.Date ~ NQClrCrk$Lifestage, horizontal = T, frame = F, ylim = c(45,285),
        xaxt = "n", yaxt = "n")
axis(side = 1, at = seq(45,285,20), labels = T, cex.axis = 1.5)
mtext(text = "Nisqually Clear Creek", side = 3, adj = 0, line = -0.5)

#axis labels
mtext(text = "Day of Year", side = 1, cex = 1.5, outer = T, line = 2)
mtext(text = "Habitat", side = 2, cex = 1.5, outer = T, line = 2)


