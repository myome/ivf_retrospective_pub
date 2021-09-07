#!/usr/bin/env python
import argparse
import os

"""
This script writes the triofile variants with at least one heterozygous parent into an
annotated vcf called "hetvcf."
Inputs: triofile, hetvcf
"""

def main(trio, hetvcf):
    load_trio(trio, hetvcf)

def load_trio(trio, hetvcf):

    dir = os.path.dirname(trio)

    with open(trio, 'r') as p, open(hetvcf, 'w+') as h:
        lines = p.readlines(1)
        while True:
            lines = p.readlines(1000000)
            if not lines:
                break
            for line in lines:
                line = line.strip().strip("\n")
                if not line.startswith("#"):
                    data = line.split()
                    if len(data) == 0:
                        a.write("A line in {} is blank.".format(file))
                        sys.exit(1)
                    chrom = data[0]
                    pos = str(int(float(data[1])))
                    gt_kid = data[9].split(':')[0]
                    gt_dad = data[10].split(':')[0]
                    gt_mom = data[11].split(':')[0]

                    if is_heterozygous(gt_dad) and is_heterozygous(gt_mom):
                        info="DAD_HET=TRUE;MOM_HET=TRUE"
                    elif is_heterozygous(gt_dad):
                        info="DAD_HET=TRUE"
                    elif is_heterozygous(gt_mom):
                        info="MOM_HET=TRUE"
                    else:
                        info=""

                    h.write('\t'.join([chrom, pos]+ data[2:5]+ [".", ".",info,"GT", gt_kid, "\n"]))


def is_heterozygous(alleles):
    """
    Determine if a call is homozygous
    ---------------------
    inputs
        alleles: list of 2 allele calls
    outputs
        True if homozygous else False
    """
    if not alleles:
        return False
    if '/' in alleles:
        a1, a2 = alleles.split('/')
    elif '|' in alleles:
        a1, a2 = alleles.split('|')
    else:
        return False
    return a1 != a2


if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--triofile', type=str, help='filepath to genome for embryo')
    parser.add_argument('--hetvcf', type=str, help='filepath to hetvcf results')
    args = parser.parse_args()
    main(args.triofile, args.hetvcf)
