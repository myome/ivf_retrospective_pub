#!/bin/bash

set -e

# change working dir to script location so python calls work from anywhere
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

pred=$1
trio=$2
prs=$3
p1_phase=$4
p2_phase=$5

if [ $# -ne 5 ]
  then
    echo "
        Incorrect usage.
        Expected: ./get_prediction_accuracy.sh predicted_genome trio prs_variants momvcf dadvcf
        "
    exit 1
fi

for f in $pred $trio $prs $p1_phase $p2_phase
do
    if [ -s "$f" ]; then
        :
    else
        echo "$f is empty." && exit 1
    fi
done

path=$(dirname $pred)
path="${path}/"

res_name=$(basename $pred)
res_name="${res_name%.*}"

cp $pred "${path}pred.vcf"
pred="${path}pred.vcf"

# reformat prediction and trio files
awk 'BEGIN {FS="\t"; OFS="\t"} {print $1, $2, $4, $5, $10}' $pred > "${pred}.formatted"
awk -F'\t' '$3 !~ "," && $4 !~ ","' <(awk 'BEGIN {FS="\t"; OFS="\t"} {print $1, $2, $4, $5, substr($10, 1, 3)}' $trio) | grep -v '^#' > "${path}genome_from_trio.txt"

# sort predictions into wrong, correct, and no call files
./get_prediction_accuracy.py --accounting $pred \
                             --trio "${path}genome_from_trio.txt" \
                             --correct "${path}${res_name}.correct" \
                             --wrong "${path}${res_name}.wrong" \
                             --other "${path}${res_name}.other" || exit 1

# add wrong predictions to pred file
cat "vcf_headers/pred_wrong.hdr" "${path}${res_name}.vcf.wrong" > "${path}${res_name}.wrong.vcf"
rm "${path}${res_name}.vcf.wrong"
bgzip -f "${path}${res_name}.wrong.vcf" > "${path}${res_name}.wrong.vcf.gz"
bgzip -f "${path}accounting.vcf" > "${path}accounting.vcf.gz"
bcftools index -f "${path}${res_name}.wrong.vcf.gz" > "${path}${res_name}.wrong.vcf.gz.csi"
bcftools index -f "${path}accounting.vcf.gz" > "${pred}.gz.csi"
bcftools annotate -a "${path}${res_name}.wrong.vcf.gz" -c CHROM,POS,REF,ALT,INFO/PRED_WRONG "${path}accounting.vcf.gz" > "${path}accounting.vcf"
rm "${path}accounting.vcf.gz"
rm "${path}accounting.vcf.gz.csi"

# annotate PRS sites
awk '/^[^#]/' $prs > "${path}prs.body.vcf"
awk -F'\t' -v OFS='\t' '{ $8 = "PRS=TRUE" }1' < "${path}prs.body.vcf" > "${path}prs.body.annotated.vcf"
cat "vcf_headers/prs.hdr" "${path}prs.body.annotated.vcf" > "${path}prs.unsorted.vcf"
bcftools sort "${path}prs.unsorted.vcf" > "${path}prs.vcf"
bgzip -f "${path}prs.vcf" > "${path}prs.vcf.gz"
bcftools index -f "${path}prs.vcf.gz" > "${path}prs.vcf.gz.csi"
cp $trio "${path}trio.vcf"
trio="${path}trio.vcf"
bgzip -f $trio > "${trio}.gz"
bcftools index -f "${trio}.gz" > "${trio}.gz.csi"
bcftools annotate -a "${path}prs.vcf.gz" -c CHROM,POS,REF,ALT,INFO/PRS "${trio}.gz" > "${trio}"

# annotate het sites
hets="${path}het.vcf"
./get_hets.py --triofile $trio --hetvcf $hets
cat "vcf_headers/het.hdr" $hets > "${path}het.copy.vcf" && rm $hets && mv "${path}het.copy.vcf" $hets
bgzip -f $hets > "${hets}.gz"
bcftools index -f "${hets}.gz" > "${hets}.gz.csi"
bgzip -f $trio > "${trio}.gz"
bcftools index -f "${trio}.gz" > "${trio}.gz.csi"
bcftools annotate -a "${hets}.gz" -c CHROM,POS,REF,ALT,INFO/DAD_HET,INFO/MOM_HET "${trio}.gz" > "${trio}"

# calculate accuracy and coverage
./get_accuracy_stats.py --accounting "${path}accounting.vcf" --trio $trio

# append parental genome stats to accuracy.txt
echo "-----------------------------------" >> "${path}accuracy.txt"
echo "Parental Genome Stats" >> "${path}accuracy.txt"
echo "-----------------------------------" >> "${path}accuracy.txt"
cat "${path}${res_name}.vcf.QC" >> "${path}accuracy.txt"
