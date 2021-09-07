library(ggplot2)

#Read data into a table
oddsratios<-read.table("./data/retro.or.breastcancer.txt", header=T)
sims<-read.table("./data/retro.breastcancer_ors_sims.txt", header=T)

#Choose file to save figure
png("./figures/fig2b.png", width=700, height=400)

#Generate dot plot for each family

ggplot(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio), shape = 21,size=2, color="black", fill="black", alpha=1,show.legend=FALSE) + theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank())+geom_violin(data=sims,aes(x=as.factor(caseid),y=oddsratio),alpha=0.25, position = position_dodge(width = .75),size=.5,color="black",fill="#FF3333",show.legend=FALSE)+scale_fill_viridis_d( option = "D")+theme_bw()+ylab("PRS-informed odds ratio") + xlab("Case ID") + theme(text = element_text(size = 20))

dev.off()