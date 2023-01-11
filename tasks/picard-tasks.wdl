version 1.0

task deDuplicate{
    input{
        String java
        String picard
        String mem
        File bam
        String outputBamPath
        String outputMetricsPath
    }
    command {
        set -euo pipefail
        set -e
        ${java} -Xmx${mem}g -jar ${picard} MarkDuplicates \
        AS=true \
        M=${outputMetricsPath} \
        O=${outputBamPath} \
        I=${bam}
        REMOVE_DUPLICATES=true \
        CREATE_INDEX=true \
        VALIDATION_STRINGENCY=SILENT
    }
    output {
        File outputBam= outputBamPath
        File outputBamIndex = sub(outputBamPath, "\bam$", "bai")
        File outputMetics = outputMetricsPath
    }
}