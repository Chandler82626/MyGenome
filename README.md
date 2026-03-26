# MyGenome
Sg337 genome of Pyricularia oryzae

1) Assess quality with FASTQC: fastqc path/to/Genome_1.fq.gz  path/to/Genome_2.fq.gz -o outputDirectory
2) Look at html files to see report summaries.
3) Ensure genome size is large enough and adapter contamination is not too bad.
4) Create a biosample project and upload raw reads at NCBI.
5) Use trimomatic to remove adaptors and poor quality sequence.
6) Generate an optimized genome assembly by trying out different softwares such as Velvet (different kmers) and Spades.
7) Find # of contigs, N50 values, genome size and other datapoints about your data.
8) Post process your data to format for NCBI and ensure no contigs are shorter than 200 nt.
9) Acess genome quality using BUSCO.
10) Genome interrogation using BLAST to look at contig length and split contigs.
11) Perform Gene predictions
12) Visualize genes using genome browser
13) record methods and process for future work
14) submit completed genome and information to NBCI.
