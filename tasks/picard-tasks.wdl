version 1.0

task deDuplicate{
    input{
        File bam
        String outputBamPath
        String outputMetricsPath
    }
    command {
        set -euo pipefail
        java -jar /usr/picard/picard.jar MarkDuplicates \
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
    runtime {
        docker: "docker.io/mgibio/picard-cwl"
    }
}
