version 1.0

task sort {
    input{
        String samtools
        File bam
        String sortedBamPath
    }
    command {
        set -euo pipefail
        ${samtools} sort -m 15000000000 ${bam} -o ${sortedBamPath}
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
        ${samtools} view -h -L ${chromChr} ${bam} -o ${noScaffoldBamPath}
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
        Int dupFilter = 1540
    }
    command {
        set -euo pipefail
        ${samtools} view -b -F dupFilter ${bam} -o ${filteredBamPath}
    }
    output {
        File filteredBam = filteredBamPath
    }
}
