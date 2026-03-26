# MyGenome
Sg337 genome of Pyricularia oryzae

1) Assess quality with FASTQC:
   fastqc path/to/Genome_1.fq.gz  path/to/Genome_2.fq.gz -o outputDirectory
2) Look at html files to see report summaries.
3) Ensure genome size is large enough and adapter contamination is not too bad.
   Total Bases	1.4 Gbp
   Adapter Content: < 34%
4) Create a biosample project and upload raw reads at NCBI.
   BioProject: PRJNA926786
   SRA: SAMN55299609	
5) Use trimomatic to remove adaptors and poor quality sequence.
   java -jar trimmomatic-0.38.jar PE -threads 2 -phred33 -trimlog Sg337_errorlog.txt path/to/Sg337_1.fq.gz         path/to/Sg337_2.fq.gz Sg337_1_paired.fastq Sg337_1_unpaired.fastq Sg337_2_paired.fastq Sg337_2_unpaired.fastq ILLUMINACLIP:adaptors.fa:2:30:10 SLIDINGWINDOW:20:20 MINLEN:125
10) Generate an optimized genome assembly by trying out different softwares such as Velvet (different kmers) and SPAdes.
    This step was done on the UK super computer with jobs.
    Velvet10Step:
      sbatch path/to/velvetoptimiser.sh MyGenomeID lowK[43] highK[123] 10
    Velvet2Step:
      sbatch path/to/velvetoptimiser.sh MyGenomeID lowK[85] highK[101] 2
    SPAdes:
      sbatch path/to/spades.sh .Sg337
    SPAdes (paired only):
      sbatch path/to/spades-paired.sh .Sg337
      .sh attached
12) Find # of contigs, N50 values, genome size and other datapoints about your data.
    Velvet10Step:
      Hash: 93
      Genome size 40,807,998		
      contigs 3,469
      N50 55,501
    Velvet2Step:
       Hash: 97
       Genome size 40,856,719		
       contigs 3,778
       N50 48,606
    SPAdes:
       Genome size 41,097,548
       contigs 8222
       N50 65,946
     SPAdes (paired only):
       Genome size 40,716,038	
       contigs 	4241
       N50 94,346
    SPAdes (paired only) was chosen as the best assembly
14) Post process your data to format for NCBI and ensure no contigs are shorter than 200 nt.
15) Acess genome quality using BUSCO.
16) Genome interrogation using BLAST to look at contig length and split contigs.
17) Perform Gene predictions
18) Visualize genes using genome browser
19) record methods and process for future work
20) submit completed genome and information to NBCI.
