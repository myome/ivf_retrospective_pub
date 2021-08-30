library(ggplot2)

#Read data into a table
oddsratios<-read.table("./data/retro.or.breastcancer.txt", header=T)
head(oddsratios)
sims<-read.table("./data/retro.breastcancer_ors_sims2.txt", header=T)

#Choose file to save figure
png("./figures/fig2b.png", width=600, height=400)

#Generate dot plot for each family

ggplot(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)), shape = 21,size=1, color="black",alpha=1,show.legend=FALSE) + theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank())+geom_violin(data=sims,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)),alpha=0.25, position = position_dodge(width = .75),size=.5,color="black",show.legend=FALSE)+scale_fill_viridis_d( option = "D")+theme_bw()+ylab("PRS-informed odds ratio") + xlab("Case ID")

dev.off()