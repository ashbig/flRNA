task Sort {
    input{
        String samtools
        String bam
        String sortedBamName
    }
    command {
        set -euo pipefail
        ${samtools} sort -m 32000000000 ${bam} -o ${sortedBamName}
    }
    output {
        File sortedBam = "${sortedBamName}"
    }
}
task Index {
    input{
        String samtools
        String bam
    }
    command {
        set -euo pipefail
        ${samtools} index ${bam}
    }
    output {
        File bamIndex = "${bam}.bai"
    }
}
task Scaffold {
    input{
        String samtools
        String chromChr
        String bam
        String noScaffoldBamName 
    }
    command {
        set -euo pipefail
        ${samtools} sort -view -h -L ${chromChr} ${bam} -o ${noScaffoldBamName}
    }
    output {
        File noScaffoldBam = "${noScaffoldBamName}"
    }
}