version 1.0

task trimGalore {
    input{
        String trim
        String fq1
        String fq2
        String sampleName
        String outDir
        String? adapter1
        String? adapter2
    
        String qual = "15"
        String stringency = "5"
        String e = "0.1"
        String length = "20"
    }
    command {
            ${trim} \
            --fastqc \
            -q ${qual} \
            --phred33 \
            --gzip \
            --stringency ${stringency} \
            -e ${e} \
            --length ${length} \
            ${"-a " + adapter1} \
            ${"-a2 " + adapter2} \
            --paired ${fq1} ${fq2} \
            -o ${outDir}
    }
    output {
        File outFwdPaired = "${outDir}${sampleName}_R1_val_1.fq.gz"
        File outRevPaired = "${outDir}${sampleName}_R2_val_2.fq.gz"
    }
}