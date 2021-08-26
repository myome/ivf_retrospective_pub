#!/usr/bin/env python
import argparse
import os


def main(accounting, trio):
    check_file(accounting, trio)

def check_file(file, trio):
    correct = set()
    wrong = set()
    other = set()
    nonhet = set()
    het = set()
    unphased = set()
    transmission_missing = set()
    multiallelic = set()
    switch_error = set()
    no_sparse_overlap = set()
    unknown = set()
    prs = set()

    all = set()
    predicted = set()

    dir = os.path.dirname(file)
    accuracy = os.path.join(dir, 'accuracy.txt')

    # put variants of triofile into sets of all, het, and prs
    with open(trio, 'r') as t:
        lines = t.readlines(1)
        while True:
            lines = t.readlines(1000000)
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
                    info = data[7]
                    gt = data[9]

                    all.add((chrom,pos))
                    if "HET" in info:
                        het.add((chrom,pos))
                    else:
                        nonhet.add((chrom,pos))

                    if "PRS" in info:
                        prs.add((chrom,pos))
    t.close()

    # put variants of predicted file into respective sets
    with open(file, 'r') as p:
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
                    info = data[7]
                    gt = data[9]

                    if "." not in gt:
                        predicted.add((chrom,pos))
                        
                    if "PRED_WRONG" in info:
                        wrong.add((chrom,pos))
                    elif "." in gt:
                        other.add((chrom,pos))
                        if "MULTIALLELIC" in info:
                            multiallelic.add((chrom,pos))
                        elif "SWITCH_ERROR" in info:
                            switch_error.add((chrom,pos))
                        elif "NO_SPARSE_OVERLAP" in info:
                            no_sparse_overlap.add((chrom,pos))
                        elif "UNPHASED" in info:
                            unphased.add((chrom,pos))
                        elif "TRANSMISSION_MISSING" in info:
                            transmission_missing.add((chrom,pos))
                        else:
                            unknown.add((chrom,pos))
                    else:
                        correct.add((chrom,pos))
    p.close()

    # intersect sets of predicted variants with set of variants from triofile
    predicted = predicted.intersection(all)
    correct = correct.intersection(all)
    wrong = wrong.intersection(all)
    other = other.intersection(all)

    # use the sets to calculate coverage and accuracy and write into accuracy file
    with open(accuracy, 'w+') as a:

        # write whole genome stats
        total = len(all)
        if total > 0:
            overlapped = len(predicted)
            percent_coverage = overlapped/total
            percent_correct = len(correct)/overlapped
            percent_wrong = len(wrong)/overlapped

            total_het = len(het)
            correct_het = len(correct.intersection(het))
            wrong_het = len(wrong.intersection(het))
            overlapped_het = correct_het + wrong_het

            percent_coverage_het = overlapped_het/total_het
            percent_correct_het = correct_het/overlapped_het
            percent_wrong_het = wrong_het/overlapped_het

            a.write("-----------------------------------"+ "\n")
            a.write("Whole Genome Stats ("+str(total)+")" + "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Predicted Embryo Variant Stats"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Embryo Genome Coverage: " + str(percent_coverage) + " ("+str(overlapped)+")"+ "\n")
            a.write("Embryo Correct Predictions (from those that overlapped): " + str(percent_correct) + " ("+str(len(correct))+")"+ "\n")
            a.write("Embryo Incorrect Predictions (from those that overlapped): " + str(percent_wrong) + " ("+str(len(wrong))+")"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Predicted Embryo Het Variant Stats ("+str(total_het)+")"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Embryo Genome Coverage: " + str(percent_coverage_het) + " ("+str(overlapped_het)+")"+ "\n")
            a.write("Embryo Correct Predictions (from those that overlapped): " + str(percent_correct_het) + " ("+str(correct_het)+")"+ "\n")
            a.write("Embryo Incorrect Predictions (from those that overlapped): " + str(percent_wrong_het) + " ("+str(wrong_het)+")"+ "\n\n\n")

        # write prs stats
        total_prs = len(prs)
        if total_prs > 0:
            correct_prs = len(correct.intersection(prs))
            wrong_prs = len(wrong.intersection(prs))
            overlapped_prs = correct_prs + wrong_prs

            percent_coverage_prs = overlapped_prs/total_prs
            percent_correct_prs = correct_prs/overlapped_prs
            percent_wrong_prs = wrong_prs/overlapped_prs

            total_het_prs = len(het.intersection(prs))
            correct_het_prs = len(correct.intersection(het,prs))
            wrong_het_prs = len(wrong.intersection(het,prs))
            overlapped_het_prs = correct_het_prs + wrong_het_prs

            percent_coverage_het_prs = overlapped_het_prs/total_het_prs
            percent_correct_het_prs = correct_het_prs/overlapped_het_prs
            percent_wrong_het_prs = wrong_het_prs/overlapped_het_prs

            a.write("-----------------------------------"+ "\n")
            a.write("PRS Genome Stats ("+str(total_prs)+")"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Predicted Embryo PRS Variant Stats"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Embryo Genome Coverage: " + str(percent_coverage_prs) + " ("+str(overlapped_prs)+")"+ "\n")
            a.write("Embryo Correct Predictions (from those that overlapped): " + str(percent_correct_prs) + " ("+str(correct_prs)+")"+ "\n")
            a.write("Embryo Incorrect Predictions (from those that overlapped): " + str(percent_wrong_prs) + " ("+str(wrong_prs)+")"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Predicted Embryo Het PRS Variant Stats ("+str(total_het_prs)+")"+ "\n")
            a.write("-----------------------------------"+ "\n")
            a.write("Embryo Genome Coverage: " + str(percent_coverage_het_prs) + " ("+str(overlapped_het_prs)+")"+ "\n")
            a.write("Embryo Correct Predictions (from those that overlapped): " + str(percent_correct_het_prs) + " ("+str(correct_het_prs)+")"+ "\n")
            a.write("Embryo Incorrect Predictions (from those that overlapped): " + str(percent_wrong_het_prs) + " ("+str(wrong_het_prs)+")"+ "\n")


if __name__=='__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--accounting', type=str, help='filepath to genome for embryo')
    parser.add_argument('--trio', type=str, help='filepath to trio')
    args = parser.parse_args()
    main(args.accounting, args.trio)
