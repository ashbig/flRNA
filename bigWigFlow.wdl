version 1.0

import "tasks/samtools-tasks.wdl" as samTasks
import "tasks/picard-tasks.wdl" as picardTasks
import "tasks/other-tasks.wdl" as otherTasks
import "tasks/custom-tasks.wdl" as customTasks

# WORKFLOW DEFINITION
workflow bigWigFlow {
    input{
        File bam

        String chromChr
        String chromGTF
        String chromSize

        String outDir
        String sampleName
    }
    call otherTasks.readCount {
        input:
            bam = bam
    }
    call customTasks.factor {
        input:
            rc = readCount.rc,
    }
    call customTasks.bedGraph {
        input:
            f = factor.f,
            chromSize = chromSize,
            bedGraphOut = outDir + sampleName + ".bg.bed"
    }
    call customTasks.bedGraph {
        input:
            f = factor.f,
            chromSize = chromSize,
            bedGraphOut = outDir + sampleName + ".bg.bed"
    }
    call otherTasks.generateBigWig {
        input:
            bedGraph = bedGraph.bg,
            chromSize = chromSize,
            bigWigOut = outDir + sampleName + ".bw"
    }
    output{
        File bigWig = generateBigWig.bigWig
    }
}