version 1.0

task sort {
    input{
        File bam
        String sortedBamPath

        String mem
    }
    command {
        set -euo pipefail
        samtools sort -m ${mem} ${bam} -o ${sortedBamPath}
    }
    output {
        File sortedBam = sortedBamPath
    }
    runtime {
        docker: "staphb/samtools"
    }
}
task index {
    input{
        File bam
        String indexedBamPath
    }
    command {
        set -euo pipefail
        samtools index ${bam} -o ${indexedBamPath}
    }
    output {
        File bamIndex = indexedBamPath
    }
    runtime {
        docker: "staphb/samtools"
    }
}
task scaffold {
    input{
        String chromChr
        File bam
        String noScaffoldBamPath
    }
    command {
        set -euo pipefail
        samtools view -h -L ${chromChr} ${bam} -o ${noScaffoldBamPath}
    }
    output {
        File noScaffoldBam = noScaffoldBamPath
    }
    runtime {
        docker: "staphb/samtools"
    }
}
task filter {
    input{
        File bam
        String filteredBamPath
    }
    command {
        set -euo pipefail
        samtools view -b -F 1540 ${bam} -o ${filteredBamPath}
    }
    output {
        File filteredBam = filteredBamPath
    }
    runtime {
        docker: "staphb/samtools"
    }
}
task readCount {
    input {
        File bam
    }
    command {
        set -euo pipefail
        samtools view -c ${bam}
    }
    output {
        Int rc = read_int(stdout())    
    }
    runtime {
        docker: "staphb/samtools"
    }
}
