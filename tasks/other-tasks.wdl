version 1.0

task getCounts {
    input {
        String featureCounts
        String cpu
        String chromGTF
        String featureCountOut
        File bam
    }
    command {
        set -euo pipefail
        ${featureCounts} -p -t exon -g gene_id -s 1 -O \
        -T ${cpu} \
        -a ${chromGTF} \
        -o ${featureCountOut} ${bam}
    }
    output {
        File counts = featureCountOut
    }
}