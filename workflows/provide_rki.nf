include { rki_report } from './process/rki_report'
include { rki_report_extended } from './process/rki_report'

workflow rki_report_wf {
    take: 
        president_valid
        president_invalid
        extended_table
    main:
        readme_pdf_ch = Channel
        .fromPath(workflow.projectDir + "/data/rki_report/Readme.pdf")

        if (!params.extended) {
            rki_report(president_valid.filter { it[0] != 'negative' }.map{it -> it[1]}.collect(), readme_pdf_ch)
        }
        else {
            rki_report_extended(president_valid.filter { it[0] != 'negative' }.map{it -> it[1]}.collect(), readme_pdf_ch, extended_table)
        }
        // store valid genomes
        channel_tmp1 = president_valid.filter { it[0] != 'negative' }.map{it -> it[2]}
            .splitText(by:100000000)
            .collectFile(name: 'valid_genomes.fasta', storeDir: params.output + "/" + params.rkidir +"/valid/")

        // store invalid genomes
        channel_tmp2 = president_invalid.filter { it[0] != 'negative' }.map{it -> it[2]}
            .splitText(by:100000000)
            .collectFile(name: 'invalid_genomes.fasta', storeDir: params.output + "/" + params.rkidir +"/invalid/")

} 