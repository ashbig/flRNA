version 1.0

import "tasks/samtools-tasks.wdl" as samTasks
import "tasks/other-tasks.wdl" as otherTasks
import "tasks/custom-tasks.wdl" as customTasks
import "tasks/bedtools-tasks.wdl" as bedTasks

# WORKFLOW DEFINITION
workflow bigWigFlow {
    input{
        File bam
        String chromSize
        String outDir
        String sampleName
    }
    call samTasks.readCount {
        input:
            bam = bam
    }
    call customTasks.factor {
        input:
            rc = readCount.rc,
    }
    call bedTasks.bam2Bed {
        input:
            bam = bam,
            bam2BedOut = outDir + sampleName + ".b2b.bed"

    }
    call bedTasks.bed12To6 {
        input:
            bed = bam2Bed.bamBed,
            bed6Out = outDir + sampleName + ".b6.bed"

    }
    call bedTasks.coverageBed {
        input:
            f = factor.f,
            bed = bed12To6.bed6,
            chromSize = chromSize,
            covBedOut = outDir + sampleName + ".unsorted.bed"
    }
    call customTasks.nixSort {
        input:
            bed = coverageBed.covBed,
            nixSortOut = outDir + sampleName + ".bg.bed"
    }
    call otherTasks.generateBigWig {
        input:
            bg = nixSort.nixSorted,
            chromSize = chromSize,
            bigWigOut = outDir + sampleName + ".bw"
    }
    output{
        File bigWig = generateBigWig.bigWig
    }
}
