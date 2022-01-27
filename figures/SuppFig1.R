library(ggpubr)
library(ggplot2)

prsors<-read.table("./data/prs_deciles.txt", header=T)

histplot<-ggplot(prsors, aes(y=or, x=decile)) + geom_bar(position="dodge", stat="identity", fill="blue") + ylab("Odds ratio") + xlab("PRS Decile")+facet_wrap(phenotype ~ ., ncol=3, scales="free") + theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))

#+ theme(legend.key.size = unit(0.25, 'cm'),legend.text=element_text(size=6), axis.text=element_text(size=6),axis.title=element_text(size=7),panel.grid.major.y = element_line(size=0.25, color="gray"), panel.grid.major.x = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), legend.title=element_blank(),axis.text.x = element_text(angle = 45)) + coord_cartesian(ylim = c(85, 102))

ggsave("./figures/SuppFig1.pdf", plot=histplot, dpi=300, width=180, height=225, units=c("mm"), device="pdf")

