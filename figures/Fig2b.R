library(ggplot2)

#Read data into a table
oddsratios<-read.table("./data/retro.or.breastcancer.txt", header=T)
sims<-read.table("./data/retro.breastcancer_ors_sims.txt", header=T)
parents<-read.table("./data/retro.breastcancer_ors_parents.txt", header=T)


#Generate dot plot for each family

violinplot<-ggplot(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio), shape = 21,size=0.5, color="black", fill="black", alpha=1,show.legend=FALSE) + theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank())+geom_violin(data=sims,aes(x=as.factor(caseid),y=oddsratio),alpha=0.25, position = position_dodge(width = .75),size=.5,color="black",fill="#FF3333",show.legend=FALSE)+scale_fill_viridis_d( option = "D")+theme_bw()+ylab("PRS-informed odds ratio") + xlab("Case ID") + theme(text = element_text(size = 7))+geom_point(data=parents,aes(x=as.factor(caseid),y=oddsratio), shape = 95,size=5, color="blue", fill="blue", alpha=1,show.legend=FALSE)

ggsave("./figures/Fig2b.pdf", plot=violinplot, dpi=300, width=88, height=43, units=c("mm"), device="pdf")
