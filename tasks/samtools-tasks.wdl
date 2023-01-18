version 1.0

task sort {
    input{
        File bam
        String sortedBamPath
        String mem

        String dockerImage = "docker.io/staphb/samtools:latest"
    }
    command {
        set -euo pipefail
        samtools sort -m ${mem} ${bam} -o ${sortedBamPath}
    }
    output {
        File sortedBam = sortedBamPath
    }
    runtime {
        memory: mem
        docker: dockerImage
    }
}

task index {
    input{
        File bam
        String indexedBamPath

        String mem = "2G"
        String dockerImage = "docker.io/staphb/samtools:latest"
    }
    command {
        set -euo pipefail
        samtools index ${bam} -o ${indexedBamPath}
    }
    output {
        File bamIndex = indexedBamPath
    }
    runtime {
        memory: mem
        docker: dockerImage
    }
}
task scaffold {
    input{
        String chromChr
        File bam
        String noScaffoldBamPath

        String mem = "2G"
        String dockerImage = "docker.io/staphb/samtools:latest"
    }
    command {
        set -euo pipefail
        samtools view -h -L ${chromChr} ${bam} -o ${noScaffoldBamPath}
    }
    output {
        File noScaffoldBam = noScaffoldBamPath
    }
    runtime {
        memory: mem
        docker: dockerImage
    }
}
task filter {
    input{
        File bam
        String filteredBamPath

        String mem = "2G"
        String dockerImage = "docker.io/staphb/samtools:latest"
    }
    command {
        set -euo pipefail
        samtools view -b -F 1540 ${bam} -o ${filteredBamPath}
    }
    output {
        File filteredBam = filteredBamPath
    }
    runtime {
        memory: mem
        docker: dockerImage
    }
}
