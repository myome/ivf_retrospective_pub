library(data.table)
library(dplyr)
library(ggplot2)

## with brca

## embryo simulation results

emb <- fread("./indivbrca_data_noids.csv")

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

ggplot() +
    geom_point(data=df2, aes(percentile, OR, color=factor(BRCA1_variant))) +
    scale_color_manual(values=c("black", "darkblue", "red", "red")) +
    geom_point(data=emb, aes(resid_percentile, OR, color=sex, shape=sex), size=4) +
    scale_shape_manual(values = c(19,17)) +
    scale_y_continuous(trans='log2') +
    geom_hline(yintercept=c(0.94, 1.04*4.5), linetype='dashed', color=c('lightgreen', 'pink'), size=0.75) +
    theme_bw() +
    theme(legend.position = "none") +
    xlab("Percentile") +
    ylab("Odds Ratio")


ggsave("fig2a.png", dpi=600)





