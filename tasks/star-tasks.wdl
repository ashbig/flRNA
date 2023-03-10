version 1.0

# STAR aligner tasks
# Ashkan Bigdeli
# 12/12/2022

task starAlign {
    input {
        File fq1
        File? fq2 
        String starDB
        String sampleName
        String cpu

        String outFilterType = "BySJout"
        String readFilesCommand = "zcat"
        String outFilterIntronMotifs = "RemoveNoncanonicalUnannotated"
        String alignIntronMax = "10000"
        String outSAMattributes = "Standard"
        String outSAMstrandField = "intronMotif"
        String outSAMunmapped = "Within"
        String outSAMtype = "BAM SortedByCoordinate"
        String chimSegmentMin = "25"
        String chmJunctionoverhangMin = "25"
    }
    command {
        set -euo pipefail
        STAR \
        --genomeDir ${starDB} \
        --readFilesIn ${fq1} ${fq2} \
        --readFilesCommand ${readFilesCommand} \
        --runThreadN ${cpu} \
        --outSAMattributes ${outSAMattributes} \
        --outFilterIntronMotifs ${outFilterIntronMotifs} \
        --outFilterType ${outFilterType} \
        --alignIntronMax ${alignIntronMax} \
        --outSAMstrandField ${outSAMstrandField} \
        --outFileNamePrefix ${sampleName + "."} \
        --outSAMunmapped ${outSAMunmapped} \
        --chimSegmentMin ${chimSegmentMin} \
        --chimJunctionOverhangMin ${chmJunctionoverhangMin} \
        --outSAMtype ${outSAMtype}
    }
    output {
        File alignedBam = "${sampleName}.Aligned.sortedByCoord.out.bam"
    }
    runtime {
        docker: "docker.io/alexdobin/star:2.7.10a_alpha_220506"
    }
}
