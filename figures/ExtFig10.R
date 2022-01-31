library(ggpubr)
library(ggplot2)

simdat<-read.table("./data/embryo_sims_or.txt", header=T)

histplot<-ggplot(simdat, aes(odds_ratio))+geom_histogram(bins=20, fill="blue")+facet_wrap(phenotype ~ type, ncol=4, scales="free")+ xlab("Odds ratio") + xlab("Count") + theme(panel.background = element_blank(),axis.line = element_line(colour = "black"))

ggsave("./figures/ExtFig10.pdf", plot=histplot, dpi=300, width=180, height=280, units=c("mm"), device="pdf")
ggsave("./figures/ExtFig10.jpg", plot=histplot, dpi=300, width=180, height=280, units=c("mm"), device="jpg")
