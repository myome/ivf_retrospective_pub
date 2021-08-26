library(lme4)
library(data.table)
#library(nlme)
library(dplyr)
library(ggplot2)

df <- fread("brca12pos.csv")

## csvs are created in /home/tate/notebooks/Embryo-Selection-Algorithm.py

justscore <- glm(breast_cancer ~ standardized, family="binomial", data=df)
summary(justscore)

scoreAge <- glm(breast_cancer ~ standardized + age_at_recruitment, family="binomial", data=df)
summary(scoreAge)

wfhx <- glm(breast_cancer ~ standardized + age_at_recruitment + bc_mother + bc_sib, family="binomial", data=df)
summary(wfhx)

anyfhx <- glm(breast_cancer ~ standardized + age_at_recruitment + anyfh, family="binomial", data=df)
summary(anyfhx)


brca1 <- glm(breast_cancer ~ standardized*brca1, family="binomial", data=df)
summary(brca1)



## embryos

emb <- fread("./indivbrca_data_noids.csv")


## emb <- emb %>%
##     rename_with(~ gsub(" ", "_", .x, fixed=TRUE)) %>%
##     rename_with(~ gsub("_(PRS)", "", .x, fixed=TRUE))

ggplot(emb, aes(percentile, Odds_Ratio)) + geom_point(aes(color=factor(BRCA1_variant)))
ggsave("brca1plot_old.png")

emb <- emb %>%
    mutate(beta_PRS = case_when(BRCA=='negative' ~ .39, TRUE ~ beta_PRS )) %>%
    mutate(OR = exp(resid_zscore_EUR*beta_PRS)*gene_OR)


ggplot(emb, aes(percentile, OR)) + geom_point(aes(color=factor(BRCA1_variant)))
ggsave("brca1plot.pdf")

df2 <- data.frame(percentile=rep(seq(.01, .99, by=.01), 2),
                  BRCA1_variant=c(rep(0, 99), rep(1, 99)),
                  Gene_Odds_Ratio=c(rep(1, 99), rep(4.5, 99)),
                  beta=c(rep(0.39, 99), rep(0.2623643, 99)))
df2 <- df2 %>%
    mutate(zscore = qnorm(percentile)) %>%
    mutate(OR = exp(zscore*beta)*Gene_Odds_Ratio)

ggplot() +
    geom_point(data=df2, aes(percentile, OR, color=factor(BRCA1_variant))) +
    scale_color_manual(values=c("black", "darkblue", "red")) + 
    geom_point(data=emb, aes(resid_percentile, OR, color="red", shape=sex), size=3) +
    scale_y_continuous(trans='log2') +
    geom_hline(yintercept=c(0.94, 1.04), linetype='dashed', color=c('blue', 'red')) + 
    theme_bw() +
    theme(legend.position = "none") +
    xlab("Percentile") +
    ylab("Odds Ratio")


ggsave("brca1plot.pdf")


## using family means

## fit me model
df <- fread("/home/tate/brca_attenuation/fam_atten2.csv")

df <- df %>%
    mutate(famdiff = score - family_mean)

df3 <-
df %>% 
  group_by(famnum) %>% 
  filter(row_number()==1)

b1 <- glm(sample1_phenotype ~ score, data=df, family='binomial')
summary(b1)

b2 <- glmer(sample1_phenotype ~ (1|famnum) + famdiff + family_mean + brca1, data=df, family='binomial')
summary(b2)

b3 <- glmer(sample1_phenotype ~ (1|famnum) + famdiff + family_mean, data=df3, family='binomial')
summary(b3)

model <- b3
cfs <- coef(summary(model))

## with brca


emb <- fread("./indivbrca_data_noids.csv")

emb <- emb %>%
    mutate(fam_mean = mean(resid_zscore_EUR), fam_diff = resid_zscore_EUR - fam_mean) %>%
    mutate(logOdds = case_when(BRCA=='negative' ~ fam_mean*cfs["family_mean","Estimate"] + fam_diff*cfs["famdiff","Estimate"], TRUE ~ resid_zscore_EUR*beta_PRS )) %>%
    mutate(OR = exp(logOdds)*gene_OR)

df2 <- data.frame(percentile=rep(seq(.01, .99, by=.01), 2),
                  BRCA1_variant=c(rep(0, 99), rep(1, 99)),
                  Gene_Odds_Ratio=c(rep(1, 99), rep(4.5, 99)),
                  beta=c(rep(0.56, 99), rep(0.2623643, 99)))
df2 <- df2 %>%
    mutate(zscore = qnorm(percentile)) %>%
    mutate(OR = exp(zscore*beta)*Gene_Odds_Ratio)


ggplot() +
    geom_point(data=df2, aes(percentile, OR, color=factor(BRCA1_variant))) +
    scale_color_manual(values=c("black", "darkblue", "red")) +
    geom_point(data=emb, aes(resid_percentile, OR, color="red"), size=3) +
    scale_y_continuous(trans='log2') +
    geom_hline(yintercept=c(0.94, 1.04*4.5), linetype='dashed', color=c('blue', 'red')) + 
    theme_bw() +
    theme(legend.position = "none") +
    xlab("Percentile") +
    ylab("Odds Ratio")

ggsave("brca1plot.pdf")


## Fixed effects:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept) -7.38962    0.16712 -44.218  < 2e-16 ***
## famdiff      1.13344    0.09849  11.508  < 2e-16 ***
## family_mean  0.54608    0.08558   6.381 1.76e-10 ***
## brca1        1.99289    2.32043   0.859     0.39    

p <- predict(b2, with(emb, data.frame(famdiff=fam_diff, family_mean=fam_mean, brca1=0)), re.form=NA)

test1 <- predict(b2)
test2 <- predict(b2, with(df, data.frame(famnum=0, famdiff=famdiff, family_mean=family_mean, brca1=brca1)))




df4 <-
df %>% 
  group_by(famnum) %>% 
  filter(row_number()==2)

b4 <- glmer(sample1_phenotype ~ (1|famnum) + famdiff + family_mean, data=df4, family='binomial')
summary(b4)




