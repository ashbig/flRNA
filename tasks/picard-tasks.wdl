task AddOrReplaceReadGroups{
    String java8
    String mem
    String picard_path
    String OutDir
    File dedup_output
    String dedup_fix_out_name
    String SampleName
    String read_index
    command <<<
        set -o pipefail
        set -e
        ${java8} -Xmx${mem}g -jar ${picard_path}/picard.jar AddOrReplaceReadGroups TMP_DIR=${OutDir} I=${dedup_output} O=${dedup_fix_out_name} RGID="halo" RGLB=${SampleName} RGPL=Illumina RGPU=${read_index} RGSM=${SampleName}
    >>>
    output {
        File dedup_fix_out = "${dedup_fix_out_name}"
    }
}

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
        ${java} -Xmx${mem}g -jar ${picard}/picard.jar MarkDuplicates \
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