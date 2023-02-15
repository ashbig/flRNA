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
task bam2Bed {
    input {
        File bam
        String bam2BedOut
    }
    command{
        bamToBed -i ${bam} > bam2BedOut
    }
    output {
        File bamBed = bam2BedOut
    }
    runtime {
        docker: "staphb/bedtools" 
    }
}
task bed12To6 {
    input {
        File bed
        String bed6Out
    }
    command {
        bed12ToBed6 -i ${bed} > bed6Out
    }
    output {
        File bed6 = bed6Out
    }
    runtime {
        docker: "staphb/bedtools" 
    }
}
task coverageBed {
    input {
        File bed
        String chromSize
        Float f
        String covBedOut
    }
    command {
        genomeCoverageBed -bg -i ${bed} -g ${chromSize} -scale ${f} > ${covBedOut}
    }
    output {
        File covBed = covBedOut
    }
    runtime {
        docker: "staphb/bedtools" 
    }
}