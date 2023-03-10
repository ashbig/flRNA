version 1.0

task factor {
    input {
        Int rc
    }
    command {
        echo "scale=10; 1000000 / ${rc}" | bc -l
    }
    output {
        Float f = read_float(stdout())
    }
}
task nixSort {
    input {
        File bed
        String nixSortOut
    }
    command {
        sort -k1,1 -k2,2n ${bed} > ${nixSortOut}
    }
    output {
        File nixSorted = nixSortOut
    }
}
