#!/usr/bin/env python
import argparse
import sys

"""
This script compares the results of the reconstruction engine with the gold
standard triofile.
"""

def main(accounting, trio, correct, wrong, other):
    pred_dict = {}
    gold_dict = {}
    with open(trio, 'r') as gold:
        fill_dict(gold, gold_dict)

    pred_dict = fill_pred_dict(accounting)

    wrong_vcf = wrong[:-5] + "vcf.wrong"

    with open(correct, 'w+') as c, open(wrong, "w+") as w, open(other, "w+") as n, open(wrong_vcf, "w+") as v:
        for chrpos in pred_dict.keys():
            my_gt = pred_dict[chrpos][7]
            gold_gt = gold_dict.get(chrpos, None)
            if gold_gt:
                gold_gt = gold_gt[2]
            if is_same(my_gt, gold_gt):
                c.write('\t'.join([chrpos[0], chrpos[1], my_gt, "\n"]))
            elif gold_gt and '.' not in gold_gt and '.' not in my_gt:
                w.write('\t'.join([chrpos[0], chrpos[1], my_gt, "\n"]))
                w.write('\t'.join([chrpos[0], chrpos[1], str(gold_gt), "\n"]))
                wrong_line = [chrpos[0], chrpos[1]] + pred_dict[chrpos][:5] + ["PRED_WRONG=TRUE"] + pred_dict[chrpos][6:]
                v.write('\t'.join(wrong_line) + "\n")
            else:
                n.write('\t'.join([chrpos[0], chrpos[1], my_gt, "\n"]))

    with open(trio + ".missing", 'w+') as m:
        predictions = set(pred_dict.keys())
        trio = set(gold_dict.keys())
        missing = list(trio.difference(predictions))
        for chrpos in missing:
            gold_gt = gold_dict.get(chrpos, None)
            m.write('\t'.join([chrpos[0], chrpos[1]] + gold_gt + ["\n"]))

def fill_pred_dict(accounting):
    pred_dict = {}
    with open(accounting, 'r') as p:
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
                        print("A line in {} is blank.".format(accounting))
                        sys.exit(1)
                    chrom = data[0]
                    pos = str(int(float(data[1])))
                    pred_dict[(chrom, pos)] = data[2:]
    return pred_dict


def fill_dict(fileobj, target):
    while True:
        lines = fileobj.readlines(1000000)
        if not lines:
            break
        for line in lines:
            line = line.strip().strip("\n")
            try:
                chrom, pos, ref, alt, gt = line.split("\t")[0:5]
            except ValueError as e:
                print(e)
                print("The file {} is not formatted properly.".format(fileobj.name))
                print("This file should have tab-delim chrom, pos, ref, alt genotype at each line.")
                print("There may be extra columns after the above.")
                print(line)
                sys.exit(1)
            target[(chrom.strip("chr"), str(pos))] = [ref, alt, gt]
    return target

def is_same(alleles1, alleles2):
    """
    Determine if two calls have the same genotype
    --------------------
    inputs
        alleles: list of 2 allele calls
    outputs
        True if same else False
    """
    if not alleles1 or not alleles2:
        return False


    a1, a2 = separate_alleles(alleles1)
    b1, b2 = separate_alleles(alleles2)

    if not a1 or not a2 or not b1 or not b2:
        return False

    if ((a1 == b1) and (a2 == b2)) or ((a1 == b2) and (a2 == b1)):
        return True

    return False

def separate_alleles(alleles):
    if '/' in alleles:
        a1, a2 = alleles.split('/')
    elif '|' in alleles:
        a1, a2 = alleles.split('|')
    else:
        a1 = ""
        a2 = ""
    return a1, a2

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
    parser.add_argument('--accounting', type=str, help='filepath to accounting file')
    parser.add_argument('--trio', type=str, help='filepath to trio genomes')
    parser.add_argument('--correct', type=str, help='filepath to save correct positions')
    parser.add_argument('--wrong', type=str, help='filepath to save wrong positions')
    parser.add_argument('--other', type=str, help='filepath to save inconclusive positions')
    args = parser.parse_args()
    main(args.accounting, args.trio, args.correct, args.wrong, args.other)
