# MyGenome
Sg337 genome of Pyricularia oryzae

1) Assess quality with FASTQC: fastqc path/to/Genome_1.fq.gz  path/to/Genome_2.fq.gz -o outputDirectory
2) Look at html files to see report summaries.
3) Ensure genome size is large enough and adapter contamination is not too bad.
4) Create a biosample project and upload raw reads at NCBI. 5) Use trimomatic to remove adaptors and poor quality sequence.
5) Generate an optimized genome assembly by trying out different softwares such as Velvet (different kmers) and Spades.
6) Find # of contigs, N50 values, genome size and other datapoints about your data.
7) Post process your data to format for NCBI and ensure no contigs are shorter than 200 nt.
8) Acess genome quality using BUSCO.
9) Genome interrogation using BLAST to look at contig length and split contigs.
10) Perform Gene predictions
11) Visualize genes using genome browser
12) record methods and process for future work
13) submit completed genome and information to NBCI.
