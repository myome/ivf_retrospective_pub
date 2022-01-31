# Whole genome risk prediction of common disease in human pre-implantation embryos

This repository contains code for Kumar, et al. *"Whole genome prediction of common disease in human pre-implantation embryos"*

Preimplantation Genetic Testing (PGT) of in-vitro fertilized embryos has been proposed as a methodto reduce transmission of common disease; however, more comprehensive embryo geneticassessment, combining the effects of common variants and rare variants, remains unavailable. Here,we used a combination of molecular and statistical techniques to reliably infer inherited genomesequence in 110 embryos and model susceptibility across 12 common conditions. We observe agenotype accuracy of 99.0-99.4% at sites relevant to polygenic risk scoring in cases from Day-5embryo biopsies and 97.2-99.1% in cases from Day-3 embryo biopsies. Combining rare variants withPRS magnifies predicted differences across sibling embryos. For example, in a couple with apathogenic BRCA1 variant, we predicted a 15-fold difference in odds ratio across siblings whencombining versus a 4.5-fold or 3-fold difference with BRCA1 or PRS alone. Our findings may informthe discussion of utility and implementation of genome-based PGT in clinical practice.

# Installation
Please install
- Python 3
- R 3.6.3

The following R packages
- ggpubr
- ggplot

# Executing Code


## Calculate coverage and accuracy of embryo prediction
```
cd ivf_retrospective_pub

bash ./scripts/get_prediction_accuracy.sh predicted_embryo.vcf \
							 triofile.vcf  \
							 sites_of_interest.vcf \
							 mother.vcf \
							 dad.vcf
```

Output files will be in
- accuracy.txt
- predicted_embryo.correct
- predicted_embryo.wrong 
- predicted_embryo.other

accuracy.txt contains accuracy and coverage stastics genome-wide and for particular sites of interest.
Other files contain the sites that are correct, wrong, or other (e.g. multiallelic or discarded). 


### Run the Example
Example data is provided for NA12878 chr1.

```
cd data/accuracy
gunzip *.gz # uncompress the vcf files. The script accepts .vcf, not .vcf.gz files
cd ../..  # go back to the repo directory
bash ./scripts/get_prediction_accuracy.sh <ivf_retrospective_pub path>/data/accuracy/predicted_embryo.chr1.vcf \
 					  <ivf_retrospective_pub path>/data/accuracy/triofile.chr1.vcf \
					  <ivf_retrospective_pub path>/data/accuracy/retro.prs.sorted.vcf \
					  <ivf_retrospective_pub path>/data/accuracy/mom.chr1.vcf \
					  <ivf_retrospective_pub>/data/accuracy/dad.chr1.vcf
```
where *<ivf_retrospective_pub>* is the path to this repository.

# Generating Figures
Code for generating figures in the paper is provided in the figures directory

```
 Rscript figures/Fig1C.R
 Rscript figures/Fig2.R
 Rscript figures/SuppFig1.R
 Rscript figures/SuppFig2.R
 Rscript figures/SuppFigure3.R 
```
