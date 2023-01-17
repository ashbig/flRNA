version 1.0

import "tasks/trim_galore-tasks.wdl" as trimTasks
import "tasks/star-tasks.wdl" as starTasks
import "tasks/samtools-tasks.wdl" as samTasks
import "tasks/picard-tasks.wdl" as picardTasks
import "tasks/other-tasks.wdl" as otherTasks
import "tasks/custom-tasks.wdl" as customTasks

# WORKFLOW DEFINITION
workflow SampleWorkflow {
    input{
        String star
        String starDB
        String trim
        String samtools
        String java
        String picard
        String featureCounts
        String make_bw

        String fastqDir
        String outDir
        String sampleName
        String? adapter1
        String? adapter2

        String chromChr
        String chromGTF
        String chromSize

        String mem
        String cpu
    }
    call trimTasks.trimGalore {
        input:
            trim = trim,
            fq1 = fastqDir + sampleName + "_R1.fastq.gz",
            fq2 = fastqDir + sampleName + "_R2.fastq.gz",
            outDir = outDir,
            sampleName = sampleName,
            adapter1 = adapter1,
            adapter2 = adapter2
    }
    call starTasks.starAlign {
        input:
            star = star,
            starDB = starDB,
            cpu = cpu,
            fq1 = trimGalore.outFwdPaired,
            fq2 = trimGalore.outRevPaired,
            sampleName = outDir + sampleName
    }
    call samTasks.scaffold {
        input:
            samtools = samtools,
            chromChr = chromChr,
            bam = starAlign.alignedBam,
            noScaffoldBamPath = outDir + sampleName + ".bam"
    }
    call picardTasks.deDuplicate {
        input:
            java = java,
            picard = picard,
            mem = mem, 
            bam = scaffold.noScaffoldBam,
            outputBamPath = outDir + sampleName + ".unsort.dm.bam",
            outputMetricsPath = outDir + sampleName + ".dupmetric.bam"
    }
    call samTasks.sort as deDupSort {
        input:
            samtools = samtools,
            mem = mem + "G",
            bam = deDuplicate.outputBam,
            sortedBamPath = outDir + sampleName + ".dm.bam",
    }
    call samTasks.filter {
        input:
            samtools = samtools,
            bam = deDupSort.sortedBam,
            filteredBamPath = outDir + sampleName + ".f.unsort.bam"
    }
    call samTasks.sort as filterSort {
        input:
            samtools = samtools,
            mem = mem + "G",
            bam = filter.filteredBam,
            sortedBamPath = outDir + sampleName + ".f.bam",
    }
    call samTasks.index as indexFiltered {
        input:
            samtools = samtools,
            bam = filterSort.sortedBam,
            indexedBamPath = outDir + sampleName + ".df.bai"
    }
    call otherTasks.getCounts {
        input:
            featureCounts = featureCounts,
            cpu = cpu,
            chromGTF = chromGTF,
            bam = filterSort.sortedBam,
            featureCountOut = outDir + sampleName + ".counts"
    }
    call customTasks.generateBigWig {
        input:
            make_bw = make_bw,
            bam = filterSort.sortedBam,
            chromSize = chromSize,
            bgOutPath = outDir + sampleName + ".bg.bed",
            bigWigOutPath = outDir + sampleName + ".bw",
    }
    output{
        File finalBam = filterSort.sortedBam
        File finalBamIndex = indexFiltered.bamIndex

        File countTable = getCounts.counts
        File bigWig = generateBigWig.bigWig
    }
}
