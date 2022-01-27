library(ggplot2)
library(ggpubr)
#Read data into a table
oddsratios<-read.table("./data/retro.or.lifetimerisk.txt", header=T)

#Generate plots for each phenotype with data for each family
orplot<-ggplot(oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=phenotype),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=as.numeric(oddsratio)),shape = 21,size=1, color="black",alpha=.31,show.legend=FALSE) + facet_wrap(~ phenotype, ncol=4, scales = "free_y")+theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank()) + theme_bw()+ylab("Odds ratio") + xlab("Case ID")+geom_blank(data=oddsratios, aes(x=0, y=8))+theme(text = element_text(size=7))

#ggsave("./figures/SuppFig3a.pdf", plot=orplot, dpi=300, width=180, height=95, units=c("mm"), device="pdf")



#Generate plots for each phenotype with data for each family
absplot<-ggplot(oddsratios,aes(x=as.factor(caseid),y=lifetimerisk*100,fill=phenotype),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=as.numeric(lifetimerisk*100)),shape = 21,size=1, color="black",alpha=.31,show.legend=FALSE) + facet_wrap(~ phenotype, ncol=4, scales = "free_y")+theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank()) + theme_bw()+ylab("Absolute Risk (%)") + xlab("Case ID")+geom_blank(data=oddsratios, aes(x=0, y=15))+theme(text = element_text(size=7))

combinedplot<-ggarrange(orplot, absplot, ncol=1,nrow=2, labels=c("a","b"),font.label=list(color="black", size=8),hjust=-0.65)

ggsave("./figures/SuppFig3.pdf", plot=combinedplot, dpi=300, width=180, height=190, units=c("mm"), device="pdf")

#ggsave("./figures/SuppFig3b.pdf", plot=absplot, dpi=300, width=180, height=90, units=c("mm"), device="pdf")