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
task factor {
    input {
        Int rc
    }
    command {
        echo scale=10; 1000000 / ${rc}" | bc -l
    }
    output {
        Float f = read_float(stdout())
    }
}
task bedGraph {
    input {
        Float f
        File bam
        String chromSize
        String bedGraphOut
    }
    command {
        bamToBed -i ${bam} -bed12 | bed12ToBed6 -i stdin | genomeCoverageBed -bg -i - -g ${chromSize} -scale ${f} | sort -k1,1 -k2,2n > ${bedGraphOut}
    }
    output {
        File bg = bedGraphOut
    }
    runtime {
        docker: "staphb/bedtools" 
    }
}