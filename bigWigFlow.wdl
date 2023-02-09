version 1.0

import "tasks/samtools-tasks.wdl" as samTasks
import "tasks/other-tasks.wdl" as otherTasks
import "tasks/custom-tasks.wdl" as customTasks

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
    call customTasks.bedGraph {
        input:
            f = factor.f,
            bam = bam,
            chromSize = chromSize,
            bedGraphOut = outDir + sampleName + ".bg.bed"
    }
    call otherTasks.generateBigWig {
        input:
            bg = bedGraph.bg,
            chromSize = chromSize,
            bigWigOut = outDir + sampleName + ".bw"
    }
    output{
        File bigWig = generateBigWig.bigWig
    }
}
