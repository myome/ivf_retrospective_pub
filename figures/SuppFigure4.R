library(ggplot2)
#Read data into a table
oddsratios<-read.table("./data/retro.or.lifetimerisk.txt", header=T)

#Choose file to save figure
png("./figures/suppfig4a.png", width=1000, height=700)

#Generate plots for each phenotype with data for each family
ggplot(oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=phenotype),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=as.numeric(oddsratio)),shape = 21,size=2, color="black",alpha=.31,show.legend=FALSE) + facet_wrap(~ phenotype, ncol=4, scales = "free_y")+theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank()) + theme_bw()+ylab("Odds ratio") + xlab("Case ID")+geom_blank(data=oddsratios, aes(x=0, y=5))+theme(text = element_text(size=15))
dev.off()


#Choose file to save figure
png("./figures/suppfig4b.png", width=1000, height=700)

#Generate plots for each phenotype with data for each family
ggplot(oddsratios,aes(x=as.factor(caseid),y=lifetimerisk*100,fill=phenotype),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=as.numeric(lifetimerisk*100)),shape = 21,size=2, color="black",alpha=.31,show.legend=FALSE) + facet_wrap(~ phenotype, ncol=4, scales = "free_y")+theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank()) + theme_bw()+ylab("Absolute Risk (%)") + xlab("Case ID")+geom_blank(data=oddsratios, aes(x=0, y=10))+theme(text = element_text(size=15))
dev.off()