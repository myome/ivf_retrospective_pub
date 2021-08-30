library(ggpubr)
library(ggplot2)

rawscores<-read.table("./data/corr_data_rawscore.txt", header=T)
zscores<-read.table("./data/corr_data_zscore.txt", header=T)

#Generate Figure panels
#png("./figures/prs_correlation_raw.png", width = 300, height = 300)
rawscoreplot<-ggplot(rawscores,aes(x=measured,y=predicted,color = caseID)) + geom_point() + theme_bw() + theme(text = element_text(size=15))+labs(color="Case ID")


#png("./figures/prs_correlation_zscore.png", width = 300, height = 300)
zscoreplot<-ggplot(zscores,aes(x=measured,y=predicted,color = as.factor(caseID))) + geom_point() + theme_bw() + theme(text = element_text(size=15))+labs(color="Case ID")

png("./figures/suppfigure2.png",width=600, height=230)
ggarrange(rawscoreplot, zscoreplot,ncol=2,nrow=1)
dev.off()

