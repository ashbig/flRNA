version 1.0

import "sample.wdl" as processSample

workflow rnaSeq {
    input{
        File sampleList
        String projectDir
        String star
        String starDB
        String fastqDir
        String trim
        String cpu
        String? adapter1
        String? adapter2
    }
    Array[Array[String]] inputSamples = read_tsv(sampleList)
    scatter (sample in inputSamples) {
        call processSample.SampleWorkflow{
            input:
                outDir = projectDir + "/" + sample[0] + "/",
                fastqDir = fastqDir,
                sampleName = sample[0],
                trim = trim,
                star = star,
                starDB = starDB,
                cpu = cpu,
                adapter1 = adapter1,
                adapter2 = adapter2
        }
    }
}