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
13) Post process your data to format for NCBI and ensure no contigs are shorter than 200 nt.
    perl SimpleFastaHeaders.pl path/to/MyGenomeID.fasta MyGenomeID
    sbatch path/to/GenomePostProcess.sh path/to/MyGenomeID_newheader.fasta
14) Acess genome quality using BUSCO.
   sbatch BuscoSingularity.sh path/to/MyGenome.fasta
   results can be viewed in the short_summary file inside the BUSCO output directory (MyGenomeID_final_busco)
15) Genome interrogation using BLAST to look at contig length and split contigs.
    blastn -query MoMitochondrion.fasta -subject MyGenome_final.fasta -evalue 1e-50 -max_target_seqs 20000 -outfmt '6 qseqid sseqid slen length qstart qend sstart send btop' -out MoMitochondrion.MyGenome.BLAST
    singularity run --app blast2120 /share/singularity/images/ccs/conda/amd-conda1-centos8.sinf blastn...
    awk '$4/$3 >= 0.9 {print $2 ",mitochondrion"}' MoMitochondrion.MyGenome.BLAST > MyGenome_mitochondrion.csv
    awk '$4/$3 <= 0.9' MoMitochrondrion.MyGenomeID.BLAST > MyGenomeID_short_mitochrondial_hits.txt
    awk '{sum[$2]+=$4; len[$2]=$3} END {for (c in sum) if (sum[c]/len[c] > 0.9) print c "," sum[c] "," len[c] "," sum[c]/len[c]}' MyGenomeID_short_mitochondrial_hits.txt > MyGenomeID_split_mito_contigs.csv
16) Submit Genome to NCBI
17) Perform Gene predictions
    Append the genome fasta sequence to the end of the gff3 file using the following command:
    echo '##FASTA' | cat B71Ref2_a0.3.gff3 - B71Ref2.fasta > B71Ref2.gff3
    Check that the B71Ref2.gff3 file has the correct format:
    grep '##FASTA' -B 5 -A 5 B71Ref2.gff3
    Convert the MAKER annotations to ZFF for SNAP:
    maker2zff B71Ref2.gff3
    fathom genome.ann genome.dna -gene-stats
    fathom genome.ann genome.dna -categorize 1000
    fathom uni.ann uni.dna -gene-stats
    fathom uni.ann uni.dna -export 1000 -plus
    forge export.ann export.dna
    hmm-assembler.pl Moryzae . > Moryzae.hmm
    Use SNAP
    snap-hmm Moryzae.hmm MyGenome.fasta > MyGenome-snap.zff
    fathom MyGenome-snap.zff MyGenome.fasta -gene-stats
    snap-hmm Moryzae.hmm MyGenome.fasta -gff > MyGenome-snap.gff2
21) Visualize genes using genome browser
22) record methods and process for future work
23) submit completed genome and information to NBCI.
