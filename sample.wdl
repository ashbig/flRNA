version 1.0

import "tasks/trim_galore-tasks.wdl" as trimTasks
import "tasks/star-tasks.wdl" as starTasks

# WORKFLOW DEFINITION
workflow SampleWorkflow {
    input{
        String star
        String trim
        String starDB
        String fastqDir
        String outDir
        String sampleName
        String cpu
        String? adapter1
        String? adapter2
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
            outDir = outDir,
            sampleName = sampleName
    }
    output{
        File finalBam = starAlign.alignedBam
    }
}