library(data.table)
library(dplyr)
library(ggplot2)
library(ggpubr)


#Figure 2A
## with brca

## embryo simulation results

emb <- fread("./data/indivbrca_data_noids.csv")

## with original beta

emb <- emb %>%
    mutate(logOdds = beta_PRS*resid_zscore_EUR) %>%
    mutate(OR = exp(logOdds)*gene_OR)


df2 <- data.frame(percentile=rep(seq(.01, .99, by=.01), 2),
                  BRCA1_variant=c(rep(0, 99), rep(1, 99)),
                  Gene_Odds_Ratio=c(rep(1, 99), rep(4.5, 99)),
                  beta=c(rep(emb$beta_PRS[emb$BRCA=="negative"][1], 99),
                         rep(emb$beta_PRS[emb$BRCA=="positive"][1], 99)
                         )
                  )

df2 <- df2 %>%
    mutate(zscore = qnorm(percentile)) %>%
    mutate(OR = exp(zscore*beta)*Gene_Odds_Ratio)


### plot

fig2a<-ggplot() +
    geom_point(data=df2, aes(percentile, OR, color=factor(BRCA1_variant)), size=0.5) +
    scale_color_manual(values=c("black", "darkblue", "red", "red")) +
    geom_point(data=emb, aes(resid_percentile, OR, color=sex, shape=sex), size=1.5) +
    scale_shape_manual(values = c(19,17)) +
    scale_y_continuous(trans='log2') +
    geom_hline(yintercept=c(0.94, 1.04*4.5), linetype='dashed', color=c('lightgreen', 'pink'), size=0.5) +
    theme_bw() + 
    theme(legend.position = "none") + theme(text = element_text(size = 7)) +
    annotate("text", x=c(.4, .4), y=c(1.35, 5.5), label = c("italic(Non-carrier)", "italic(BRCA1)"), color="darkblue", size=5, parse=TRUE) +
    xlab("Percentile") +
    ylab("Odds Ratio")



## Figure 2B
#Read data into a table
oddsratios<-read.table("./data/retro.or.breastcancer.txt", header=T)
sims<-read.table("./data/retro.breastcancer_ors_sims.txt", header=T)
parents<-read.table("./data/retro.breastcancer_ors_parents.txt", header=T)

fig2b<-ggplot(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio,fill=as.factor(phenotype)),show.legend=FALSE) + geom_point(data=oddsratios,aes(x=as.factor(caseid),y=oddsratio), shape = 21,size=0.5, color="black", fill="black", alpha=1,show.legend=FALSE) + theme(panel.border = element_rect(colour = "black", fill=NA, size=0.1),strip.background = element_blank())+geom_violin(data=sims,aes(x=as.factor(caseid),y=oddsratio),alpha=0.25, position = position_dodge(width = .75),size=.5,color="black",fill="#FF3333",show.legend=FALSE)+scale_fill_viridis_d( option = "D")+theme_bw()+ylab("PRS-informed odds ratio") + xlab("Case ID") + theme(text = element_text(size = 7))+geom_point(data=parents,aes(x=as.factor(caseid),y=oddsratio), shape = 95,size=5, color="blue", fill="blue", alpha=1,show.legend=FALSE)

#Joint plot
#ggsave("./figures/fig2.png", dpi=600)
combinedplot<-ggarrange(fig2a, fig2b, ncol=1,labels=c("a","b"),heights=c(1.75,1.25),font.label=list(color="black", size=7),hjust=-0.65)

ggsave("./figures/Fig2.pdf", plot=combinedplot, dpi=300, width=88, height=130, units=c("mm"), device="pdf")






