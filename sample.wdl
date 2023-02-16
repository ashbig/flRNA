version 1.0

import "tasks/trim_galore-tasks.wdl" as trimTasks
import "tasks/star-tasks.wdl" as starTasks
import "tasks/samtools-tasks.wdl" as samTasks
import "tasks/picard-tasks.wdl" as picardTasks
import "tasks/other-tasks.wdl" as otherTasks
import "bigWigFlow.wdl" as bwfSub

# WORKFLOW DEFINITION
workflow SampleWorkflow {
    input{
        String starDB

        String fastqDir
        String outDir
        String sampleName
        String? adapter1
        String? adapter2

        String chromChr
        String chromGTF
        String chromSize

        String cpu
        String mem
    }
    call trimTasks.trimGalore {
        input:
            fq1 = fastqDir + sampleName + "_R1.fastq.gz",
            fq2 = fastqDir + sampleName + "_R2.fastq.gz",
            outDir = outDir,
            sampleName = sampleName,
            adapter1 = adapter1,
            adapter2 = adapter2
    }
    call starTasks.starAlign {
        input:
            starDB = starDB,
            cpu = cpu,
            fq1 = trimGalore.outFwdPaired,
            fq2 = trimGalore.outRevPaired,
            sampleName = outDir + sampleName
    }
    call samTasks.scaffold {
        input:
            chromChr = chromChr,
            bam = starAlign.alignedBam,
            noScaffoldBamPath = outDir + sampleName + ".bam"
    }
    call picardTasks.deDuplicate {
        input:
            bam = scaffold.noScaffoldBam,
            outputBamPath = outDir + sampleName + ".unsort.dm.bam",
            outputMetricsPath = outDir + sampleName + ".dupmetric.bam"
    }
    call samTasks.sort as deDupSort {
        input:
            mem = mem + "G",
            bam = deDuplicate.outputBam,
            sortedBamPath = outDir + sampleName + ".dm.bam",
    }
    call samTasks.filter {
        input:
            bam = deDupSort.sortedBam,
            filteredBamPath = outDir + sampleName + ".f.unsort.bam"
    }
    call samTasks.sort as filterSort {
        input:
            mem = mem + "G",
            bam = filter.filteredBam,
            sortedBamPath = outDir + sampleName + ".f.bam",
    }
    call samTasks.index as indexFiltered {
        input:
            bam = filterSort.sortedBam,
            indexedBamPath = outDir + sampleName + ".df.bai"
    }
    call otherTasks.getCounts {
        input:
            cpu = cpu,
            chromGTF = chromGTF,
            bam = filterSort.sortedBam,
            featureCountOut = outDir + sampleName + ".counts"
    }
    call bwfSub.bigWigFlow { 
        input: 
            bam = filterSort.sortedBam,
            chromSize = chromSize,
            outDir = outDir,
            sampleName = sampleName
    }
    output{
        File finalBam = filterSort.sortedBam
        File finalBamIndex = indexFiltered.bamIndex

        File countTable = getCounts.counts
        File bigWig = bigWigFlow.bigWig
    }
}
