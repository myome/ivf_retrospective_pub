library(ggpubr)
library(ggplot2)

gwstats<-read.table("./data/figure1c_gw.txt", header=T)
prstats<-read.table("./data/figure1c_prs.txt", header=T)

#Generate Figure 1C
#Genome-wide coverage and error plots by genotype
cov<-ggplot(gwstats, aes(fill=gt, y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(legend.key.size = unit(0.25, 'cm'),legend.text=element_text(size=6), axis.text=element_text(size=6),axis.title=element_text(size=7),panel.grid.major.y = element_line(size=0.25, color="gray"), panel.grid.major.x = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank(),axis.text.x = element_text(angle = 45)) + coord_cartesian(ylim = c(85, 102))
error<-ggplot(gwstats, aes(fill=gt, y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(legend.key.size = unit(0.25, 'cm'),legend.text=element_text(size=6), axis.text=element_text(size=6),axis.title=element_text(size=7),panel.grid.major.y = element_line(size=0.25, color="gray"), panel.grid.major.x = element_blank(),panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank(),axis.text.x = element_text(angle = 45)) + coord_cartesian(ylim = c(90, 100))

#PRS cov and error plots
prscovbygt<-ggplot(prstats, aes(fill=gt, y=cov*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Coverage (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(legend.key.size = unit(0.25, 'cm'),legend.text=element_text(size=6), axis.text=element_text(size=6),axis.title=element_text(size=7),panel.grid.major.y = element_line(size=0.25, color="gray"), panel.grid.major.x = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank(),axis.text.x = element_text(angle = 45)) + coord_cartesian(ylim = c(85, 102))
prserrorbygt<-ggplot(prstats, aes(fill=gt, y=(1-error)*100, x=index)) + geom_bar(position="dodge", stat="identity") + ylab("Accuracy (%)") + xlab("Case ID")+scale_fill_manual(values = c("#999999","#666666","black")) + theme(legend.key.size = unit(0.25, 'cm'),legend.text=element_text(size=6), axis.text=element_text(size=6),axis.title=element_text(size=7),panel.grid.major.y = element_line(size=0.25, color="gray"), panel.grid.major.x = element_blank(),panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank(),axis.text.x = element_text(angle = 45)) + coord_cartesian(ylim = c(90, 100))

#Put together in grid
combinedplot<-ggarrange(cov, prscovbygt,error,prserrorbygt,ncol=2,nrow=2,  common.legend=TRUE, legend=c("bottom"), labels=c("Genome-wide", "Polygenic model sites"), font.label=list(color="black", size=5),hjust=-0.65)
#ggsave("./figures/coverage_error_bygt.png", plot=combinedplot, dpi=300, width=4.4, height=4.8, units=c("in"))
ggsave("./figures/Fig1C.pdf", plot=combinedplot, dpi=300, width=85, height=115, units=c("mm"), device="pdf")
dev.off()
