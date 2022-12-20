import "sample.wdl" as processSample

workflow rnaSeq {
    input{
        String sampleList
        String projectDir
        String star
        String starDB
        String fastqDir
        String trim
        String cpu
        String mem
        String? adapter1
        String? adapter2
    }

    Array[Array[String]] inputSamples = read_tsv(sampleList)
    scatter (sample in inputSamples) {
        call processSample.SampleWorkFlow{
            input:
                outDir = projectDir + "/" + sample[0] + "/",
                sampleName = sample[0],
                trim = trim,
                star = star,
                starDB = starDB,
                cpu = cpu,
                mem = mem,
                adapter1 = adapter1,
                adapter2 = adapter2
        }
    }

}