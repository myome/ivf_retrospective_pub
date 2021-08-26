library(ggpubr)
library(ggplot2)

gwstats<-read.table("./data/figure1c_gw.txt", header=T)
prstats<-read.table("./data/figure1c_prs.txt", header=T)

#Generate Figure 1C
totalstats<-gwstats[ which(gwstats$gt=='total'), ]
totalcovplot<-ggplot(totalstats, aes(y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(85, 100))
totalerrorplot<-ggplot(totalstats, aes(y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(90, 100))

prstotalstats<-prstats[ which(prstats$gt=='total'), ]
prstotalcovplot<-ggplot(prstotalstats, aes(y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(85, 100))
prstotalerrorplot<-ggplot(prstotalstats, aes(y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(90, 100))

png("./figures/totalcoverage_error.png", width=800, height=800)
ggarrange(totalcovplot, prstotalcovplot,totalerrorplot,prstotalerrorplot,ncol=2,nrow=2, labels=c("Genome-wide", "Polygenic Model Sites"), common.legend=TRUE)
dev.off()

#Generate Supp figure
#Genome-wide coverage and error plots
cov<-ggplot(gwstats, aes(fill=gt, y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(85, 102))
error<-ggplot(gwstats, aes(fill=gt, y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(90, 100))

#PRS cov and error plots
prscovbygt<-ggplot(prstats, aes(fill=gt, y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(85, 102))
prserrorbygt<-ggplot(prstats, aes(fill=gt, y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank()) + coord_cartesian(ylim = c(90, 100))

#Put together in grid
png("./figures/coverage_error_bygt.png", width=800, height=800)
ggarrange(cov, prscovbygt,error,prserrorbygt,ncol=2,nrow=2, labels=c("Genome-wide", "Polygenic Model Sites"), common.legend=TRUE)
dev.off()
