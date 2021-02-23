
process split_fasta {
	input:
		path(fastq_input_raw)
	output:
		path("split_fasta/*.fasta")
	script:
	"""
	mkdir -p split_fasta
    split_fasta.py ${fastq_input_raw}
	"""
}