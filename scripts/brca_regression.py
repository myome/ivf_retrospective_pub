#!/usr/bin/env python

import os
import pandas as pd
import numpy as np
import re
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression


# FHX_PATH = '/home/jovyan/ukb/research/brca_project/brca_fhx.tsv'
RAW_DATA = '/myome/share/ukb/47431/ukb47431.csv'  # path to UKBB phenotype data
PHENOTYPES = '/home/tate/prsPipelineSharedFiles/extracted_phenotypes.tsv'  # path to derived phenotypes
related_file = '/myome/share/ukb/ukb48991_rel_s488282.dat'


def get_cases(codes: list, field: str, pheno_data: pd.DataFrame) -> (str, pd.Series):
    '''
    Return boolean of phenotypes for a given code and field

    codes: list of codes corresponding to phenotype to search
    field: field to search
    pheno_data: pandas dataframe containing phenotype data
    '''

    cols_to_check = pheno_data.filter(regex=f'^{field}', axis=1)
    if cols_to_check.empty:
        print(f'No columns found in UKBB data for field {field}')
    codes = [str(i) for i in codes]
    if len(codes) > 1:
        sstring = re.compile("|".join(codes))
    else:
        sstring = re.compile(codes[0])

        # true of any row has a match
    bool = cols_to_check.apply(lambda x: x.str.match(sstring)).any(axis=1)
    return(bool)


def find_first_diag_age(r, code, icd_type=10):
    c = r.filter(regex=fr'^icd{icd_type}')
    if all(c.isna()):  # no fields to search
        return(np.nan)
    else:
        i = c[~c.isnull() & c.str.startswith(code)].index
        if len(i) > 0:
            f = i[0].split('-', maxsplit=1)[1]
            a = r.filter(regex=fr'age_at_diag-{f}')
            return(float(a[0]))
        else:  # no match found
            return(np.nan)


def load_ukbdata(ukbpath, fieldcodes):
    ukbdat_cols = pd.read_csv(RAW_DATA, dtype="str", nrows=1)

    colmap = {}
    cols = pd.Index(['eid'], dtype='object')
    for c in fieldcodes.keys():
        r = ukbdat_cols.filter(regex=fr'^{c}-', axis=1).columns
        if r.empty:
            print(f'{c} not found in columns')
        else:
            cols = cols.union(r)
        for i in r:
            colmap[i] = i.replace(f'{c}', fieldcodes[c])


    ukbdat = pd.read_csv(RAW_DATA, dtype="str", usecols=lambda x: x in cols)
    ukbdat['eid'] = ukbdat['eid'].astype(int)
    ukbdat.set_index('eid', inplace=True)

    # rename columns
    ukbdat.rename(columns=colmap, inplace=True)

    # drop columns with all nan falues
    ukbdat.dropna(axis=1, how='all', inplace=True)
    return(ukbdat)


# UKBDATA

fieldcodes = {
    '41280': 'date_inpat_diag',
    '40008': 'age_at_diag',
    '84': 'yr_age_first_report',
    '40005': 'date_of_diag',
    '20007': 'cancer_interpolated_age',
    '20006': 'interpolated_yr_diag',
    '20001': 'self_report_code',
    '40006': 'icd10_type',
    '40013': 'icd9_type',
    '41203': 'icd9_main',
    '41205': 'icd9_secondary',
    '21000': 'population',
    '31': 'sex',
    '41202': 'icd10_main',
    '41204': 'icd10_secondary',
    '40000': 'date_of_death',
    '40007': 'age_at_death',
    '21022': 'age_at_recruitment'}

ukbdat = load_ukbdata(RAW_DATA, fieldcodes)

# just british white females

pop_series = ukbdat.filter(regex='^population', axis=1).dropna(axis=0, how='all').apply(lambda x: set(i for i in x if not pd.isnull(i)), axis=1).to_frame('pop')

sex_series = ukbdat.filter(regex='^sex', axis=1).dropna(axis=0, how='all')
sex_series.rename(columns={'sex-0.0': 'sex'}, inplace=True)
bwf = sex_series.merge(pop_series, left_index=True, right_index=True)

weth = bwf['pop'].apply(lambda x: True if (x in [{'1001'}, {'1001', '1002'}, {'1001', '1003'}, {'1001', '1002', '1003'}]) else False)
bwf = bwf.loc[(bwf['sex'] == "0") & weth]
print(f'{bwf.shape[0]} british white females')

# remove related indivs
related_df = pd.read_csv(related_file, sep=' ')

unique_exclude = related_df['ID2'][(related_df['Kinship'] > 0.0884)].unique()

unrelated_bwf = bwf[~bwf.index.isin(unique_exclude)]

# breast cancer pheno
breast_cancer = pd.read_csv(PHENOTYPES, sep="\t", usecols=['f.eid', 'breast_cancer'], index_col='f.eid')

bc = breast_cancer.loc[~breast_cancer.index.isin(unrelated_bwf.index), :]

# age at recruitment
aar = ukbdat.filter(regex='^age_at_recruitment', axis=1).copy()
aar.rename(columns={'age_at_recruitment-0.0': 'age_at_recruitment'}, inplace=True)

bc = bc.merge(aar, left_index=True, right_index=True, how='left')

# include BrCa status
brca1 = pd.read_csv('/home/akash/exome/genes/BRCA1_indivs.txt', sep='\t', header=None, squeeze=True)
brca2 = pd.read_csv('/home/akash/exome/genes/BRCA2_indivs.txt', sep='\t', header=None, squeeze=True)

bc['brca1'] = bc.index.isin(brca1)
bc['brca2'] = bc.index.isin(brca2)


# family history

fhfields = {
    '20110': 'illness_mother',
    '20111': 'illness_sibling'
}

fhdat = load_ukbdata(RAW_DATA, fhfields)

# mother
bc_code = '5'
mother = fhdat.filter(regex="^illness_mother", axis=1).apply(lambda x: any(x == bc_code), axis=1).to_frame('bc_mother')

bc = bc.merge(mother, left_index=True, right_index=True, how='left')

# sibling
sib = fhdat.filter(regex="^illness_sibling", axis=1).apply(lambda x: any(x == bc_code), axis=1).to_frame('bc_sib')

bc = bc.merge(sib, left_index=True, right_index=True, how='left')

# res scores

scores = pd.read_csv('/myome/share/ukb/brca_integrated_risk/PGS000008bc_score_resid.txt', sep="\t")

bc = bc.merge(scores, left_index=True, right_on="IID", how='left')

bc['anyfh'] = (bc.bc_mother | bc.bc_sib)


bc.to_csv('bc.csv', index=False)
# brca positive

b12pos = bc.loc[(bc['brca1']) | (bc['brca2'])]

X = b1pos.loc[:, ['bc_mother', 'bc_sib', 'standardized']]

y = b1pos.breast_cancer

model = LogisticRegression(random_state=32)

model.fit(X, y)

print(model.coef_)


X2 = b1pos.loc[:, ['anyfh', 'standardized']]

model2 = LogisticRegression(random_state=32)

model2.fit(X2, y)

print(model2.coef_)


b12pos.to_csv('brca12pos.csv', index=False)
