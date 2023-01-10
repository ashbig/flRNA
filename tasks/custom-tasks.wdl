version 1.0

task generateBigWig {
    input{
        String make_bw
        File bam
        String chromSize
        String bgOutPath
        String bigWigOutPath
    }
    command {
        set -euo pipefail
        ${make_bw} ${bam} ${chromSize} ${bgOutPath} ${bigWigOutPath}
    }
    output {
        File bigWig = bigWigOutPath
    }
}