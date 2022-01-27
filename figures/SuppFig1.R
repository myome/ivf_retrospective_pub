library(ggpubr)
library(ggplot2)

prsors<-read.table("./data/prs_deciles.txt", header=T)

histplot<-ggplot(prsors, aes(y=or, x=decile)) + geom_bar(position="dodge", stat="identity", fill="blue") + ylab("Odds ratio") + xlab("PRS Decile")+facet_wrap(phenotype ~ ., ncol=3, scales="free") + theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))

ggsave("./figures/SuppFig1.pdf", plot=histplot, dpi=300, width=180, height=225, units=c("mm"), device="pdf")
