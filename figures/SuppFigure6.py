#!/usr/env python


import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt


datapath = os.path.abspath(os.path.join(os.path.dirname(__file__), '../data'))
figpath = os.path.abspath(os.path.dirname(__file__))

popdata = pd.read_csv(os.path.join(datapath, 'sup6data.csv'))


fig, axs = plt.subplots(ncols=2, sharey=False)

sns.kdeplot(popdata['PGS000008_breast_cancer_score'].loc[popdata.population == 'EUR'], ax=axs[0], legend=False)
sns.kdeplot(popdata['PGS000008_breast_cancer_score'].loc[popdata.population == 'AFR'], ax=axs[0], legend=False)
sns.kdeplot(popdata['PGS000008_breast_cancer_score'].loc[popdata.population == 'SAS'], ax=axs[0], legend=False)
sns.kdeplot(popdata['PGS000008_breast_cancer_score'].loc[popdata.population == 'EAS'], ax=axs[0], legend=False)
sns.kdeplot(popdata['PGS000008_breast_cancer_score'].loc[popdata.population == 'AKJ'], ax=axs[0], legend=False)
axs[0].set(xlabel="raw score")

sns.kdeplot(popdata['standardized'].loc[popdata.population == 'AFR'], ax=axs[1], legend=False)
sns.kdeplot(popdata['standardized'].loc[popdata.population == 'EUR'], ax=axs[1], legend=False)
sns.kdeplot(popdata['standardized'].loc[popdata.population == 'SAS'], ax=axs[1], legend=False)
sns.kdeplot(popdata['standardized'].loc[popdata.population == 'EAS'], ax=axs[1], legend=False)
sns.kdeplot(popdata['zscore'].loc[popdata.population == 'AKJ'], ax=axs[1], legend=False)
axs[1].set(xlabel="corrected score")
axs[1].set(ylabel=None)

plt.legend(title=None, labels=['EUR', 'AFR', 'SAS', 'EAS', 'AKJ'])

fig.savefig(os.path.join(figpath, 'sup6.pdf'))
