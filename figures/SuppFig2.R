library(ggpubr)
library(ggplot2)

rawscores<-read.table("./data/corr_data_rawscore.txt", header=T)
zscores<-read.table("./data/corr_data_zscore.txt", header=T)

#Generate Figure panels
rawscoreplot<-ggplot(rawscores,aes(x=measured,y=predicted,color = caseID)) + geom_point() + theme_bw() + theme(text = element_text(size=7))+labs(color="Case ID")

zscoreplot<-ggplot(zscores,aes(x=measured,y=predicted,color = as.factor(caseID))) + geom_point() + theme_bw() + theme(text = element_text(size=7))+labs(color="Case ID")

combinedplot<-ggarrange(rawscoreplot, zscoreplot,ncol=2,nrow=1)
ggsave("./figures/SuppFig2.pdf", plot=combinedplot, dpi=300, width=180, height=110, units=c("mm"), device="pdf")


