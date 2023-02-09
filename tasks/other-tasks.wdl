version 1.0

task getCounts {
    input {
        String cpu
        String chromGTF
        String featureCountOut
        File bam
    }
    command {
        set -euo pipefail
        featureCounts -p -t exon -g gene_id -s 1 -O \
        -T ${cpu} \
        -a ${chromGTF} \
        -o ${featureCountOut} ${bam}
    }
    output {
        File counts = featureCountOut
    }
    runtime {
        docker: "dsaha0295/featurecounts"
    }
}
task generateBigWig {
    input {
        File bg
        String chromSize
        String bigWigOut
    }
    command {
        bedGraphToBigWig ${bg} ${chromSize} ${bigWigOut}
    }
    output {
        File bigWig = bigWigOut
    }
    runtime{
        docker: "zavolab/bedgraphtobigwig"
    }
}
