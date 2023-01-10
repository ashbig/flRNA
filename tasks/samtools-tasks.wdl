version 1.0

task sort {
    input{
        String samtools
        File bam
        String sortedBamPath
        String mem
    }
    command {
        set -euo pipefail
        ${samtools} sort -m ${mem} ${bam} -o ${sortedBamPath}
    }
    output {
        File sortedBam = sortedBamPath
    }
}
task index {
    input{
        String samtools
        File bam
        String indexedBamPath
    }
    command {
        set -euo pipefail
        ${samtools} index ${bam} -o ${indexedBamPath}
    }
    output {
        File bamIndex = indexedBamPath
    }
}
task scaffold {
    input{
        String samtools
        String chromChr
        File bam
        String noScaffoldBamPath
    }
    command {
        set -euo pipefail
        ${samtools} sort -view -h -L ${chromChr} ${bam} -o ${noScaffoldBamPath}
    }
    output {
        File noScaffoldBam = noScaffoldBamPath
    }
}
task filter {
    input{
        String samtools
        File bam
        String filteredBamPath
    }
    command {
        set -euo pipefail
        ${samtools} sort -view -b -F ${bam} -o ${filteredBamPath}
    }
    output {
        File filteredBam = filteredBamPath
    }
}