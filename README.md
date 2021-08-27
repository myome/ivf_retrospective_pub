# Whole genome prediction in pre-implantation embryos captures both monogenic and polygenic risk

This repository contains code for Kumar, et al. *"Whole genome prediction in pre-implantation embryos captures both monogenic and polygenic risk"*

Preimplantation Genetic Testing (PGT) of in vitro fertilized (IVF) embryos has been proposed as a method to reduce transmission of common disease, although comprehensive genetic assessment remains unavailable. Here we use a combination of molecular and statistical techniques to reliably and accurately infer inherited genome sequence in 110 embryos and combine polygenic risk scores (PRS) and rare variation to model susceptibility across 12 common conditions. Combining the effects of rare variants and PRS magnifies differences across sibling embryos: in a couple with BRCA1 we predict a 15-fold difference in risk across siblings when combining vs. a 4.5-fold or 3-fold difference in BRCA1 or PRS alone. We also observe within-family variability in disease risk, illustrating a substantial reduction in susceptibility achievable by screening embryos in certain families. We anticipate that genome-based PGT which incorporates polygenic assessment has the potential to inform couples more fully about their family disease risks.

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

bash ./scripts/reconstruction/get_prediction_accuracy.sh predicted_embryo.vcf \
							 triofile.vcf  \
							 sites_of_interest.vcf \
							 mother.vcf \
							 dad.vcf
```

Output files will be in
- predicted_embryo.correct
- predicted_embryo.wrong 
- predicted_embryo.other

These files contain the sites that are correct, wrong, or other (e.g. multiallelic or discarded). 
Accuracy and coverage con be calculated from these files.

### Run the Example
Example data is provided for NA12878 chr1.

```
cd data/accuracy
gunzip *.gz # uncompress the vcf files. The script accepts .vcf, not .vcf.gz files
cd ../..  # go back to the repo directory
bash ./scripts/get_prediction_accuracy.sh <ivf_retrospective_pub path>/data/accuracy/predicted_embryo.vcf \
 					  <ivf_retrospective_pub path>/data/accuracy/triofile.chr1.vcf \
					  <ivf_retrospective_pub path>/data/accuracy/retro.prs.sorted.vcf \
					  <ivf_retrospective_pub path>/data/accuracy/mom.chr1.vcf \
					  <ivf_retrospective_pub>/data/accuracy/dad.chr1.vcf
```
where *<ivf_retrospective_pub>* is the path to this repository.

# Generating Figures
Code for generating figures in the paper is provided in the figures directory

```Rscript figures/Fig1C.R
 Rscript figures/Fig2.R
 Rscript figures/Fig2b.R
 Rscript figures/SuppFigure4.R 
```
