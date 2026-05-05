# MyGenome
Sg337 genome of Pyricularia oryzae

<details> 
   <summary>
    1) Assess quality with FASTQC:
   </summary>
     
      ```
      fastqc path/to/Genome_1.fq.gz  path/to/Genome_2.fq.gz -o outputDirectory
      ```
</details>

<details> 
   <summary>
   2) Look at html files to see report summaries.
   </summary>
   ![FastQ Image]([fastq adapter check.png](https://github.com/Chandler82626/MyGenome/blob/main/fastq%20adapter%20check.png))
</details>

<details> 
   <summary>
   3) Ensure genome size is large enough and adapter contamination is not too bad.
   </summary>
   Total Bases	1.4 Gbp 
   
   Adapter Content: < 34%
</details>

<details> 
   <summary>
   4) Create a biosample project and upload raw reads at NCBI.
   </summary>
   BioProject: PRJNA926786
   
   SRA: SAMN55299609	
</details>

<details> 
   <summary>
   5) Use trimomatic to remove adaptors and poor quality sequence.
   </summary>
   BioProject: PRJNA926786
   
   SRA: SAMN55299609	
   ```
   java -jar trimmomatic-0.38.jar PE -threads 2 -phred33 -trimlog Sg337_errorlog.txt path/to/Sg337_1.fq.gz path/to/Sg337_2.fq.gz Sg337_1_paired.fastq Sg337_1_unpaired.fastq Sg337_2_paired.fastq Sg337_2_unpaired.fastq ILLUMINACLIP:adaptors.fa:2:30:10 SLIDINGWINDOW:20:20 MINLEN:125
   ```
</details>

<details> 
   <summary>
   6) Generate an optimized genome assembly by trying out different softwares such as Velvet (different kmers) and SPAdes.
   </summary>
   
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
   
</details>

<details> 
   <summary>
      7)Find # of contigs, N50 values, genome size and other datapoints about your data.
   </summary>
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
       
       contigs 4241
       
       N50 94,346
       
    SPAdes (paired only) was chosen as the best assembly
    
</details>

<details>
  <summary>
    8) Post process your data to format for NCBI and ensure no contigs are shorter than 200 nt.
  </summary>

    perl SimpleFastaHeaders.pl path/to/MyGenomeID.fasta MyGenomeID
    sbatch path/to/GenomePostProcess.sh path/to/MyGenomeID_newheader.fasta

</details>

<details>
  <summary>
    9)Acess genome quality using BUSCO.
  </summary>
   
   results can be viewed in the short_summary file inside the BUSCO output directory (MyGenomeID_final_busco)
   ```
      sbatch BuscoSingularity.sh path/to/MyGenome.fasta
   ```
</details>


<details>
  <summary>
    10) Genome interrogation using BLAST to look at contig length and split contigs.
  </summary>
   
   details on each code
   ```
    blastn -query MoMitochondrion.fasta -subject MyGenome_final.fasta -evalue 1e-50 -max_target_seqs 20000 -outfmt '6 qseqid sseqid slen length qstart qend sstart send btop' -out MoMitochondrion.MyGenome.BLAST
    singularity run --app blast2120 /share/singularity/images/ccs/conda/amd-conda1-centos8.sinf blastn...
    awk '$4/$3 >= 0.9 {print $2 ",mitochondrion"}' MoMitochondrion.MyGenome.BLAST > MyGenome_mitochondrion.csv
    awk '$4/$3 <= 0.9' MoMitochrondrion.MyGenomeID.BLAST > MyGenomeID_short_mitochrondial_hits.txt
    awk '{sum[$2]+=$4; len[$2]=$3} END {for (c in sum) if (sum[c]/len[c] > 0.9) print c "," sum[c] "," len[c] "," sum[c]/len[c]}' MyGenomeID_short_mitochondrial_hits.txt > MyGenomeID_split_mito_contigs.csv
   ```
</details>

<details>
  <summary>
    11) Submit Genome to NCBI
  </summary>
   insert photo
</details>

<details>
  <summary>
    12) Perform Gene predictions
  </summary>

   Append the genome fasta sequence to the end of the gff3 file using the following command:

   ```
   echo '##FASTA' | cat B71Ref2_a0.3.gff3 - B71Ref2.fasta > B71Ref2.gff3
   ```

   Check that the B71Ref2.gff3 file has the correct format:

   ```
   grep '##FASTA' -B 5 -A 5 B71Ref2.gff3
   ```

   Convert the MAKER annotations to ZFF for SNAP:

    ```
   maker2zff B71Ref2.gff3
   ```

   details on code

    ```
   fathom genome.ann genome.dna -gene-stats
   fathom genome.ann genome.dna -categorize 1000
   fathom uni.ann uni.dna -gene-stats
   fathom uni.ann uni.dna -export 1000 -plus
   forge export.ann export.dna
   hmm-assembler.pl Moryzae . > Moryzae.hmm
   ```

   Use SNAP

   ```
    snap-hmm Moryzae.hmm MyGenome.fasta > MyGenome-snap.zff
    fathom MyGenome-snap.zff MyGenome.fasta -gene-stats
    snap-hmm Moryzae.hmm MyGenome.fasta -gff > MyGenome-snap.gff2
   ```

   Use Augustus

   ```
   augustus --species=magnaporthe_grisea --gff3=on \--singlestrand=true --progress=true \MyGenomeID_final.fasta > MyGenomeID-augustus.gff3
   ```

   Use MAKER   

   ```
   singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinfmaker -CTL
    Open maker_opts.ctl with a text editor to change the settings
    genome=/path/to/MyGenomeID_final.fasta
    model_org= must be set to blank
    repeat_protein= must be set to blank
    snaphmm=/path/to/Moryzae.hmm
    augustus_species=magnaporthe_grisea
    keep_preds=1
    protein=/home/yourusername/genes/maker/genbank/ncbi-protein-Magnaporthe_organism.fasta
    sbatch maker.sh path/to/MyGenomeID_final.fasta
    singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf gff3_merge -d Sg337_final.maker.output/Sg337_final_master_datastore_index.log -o Sg337-maker.gff3
   ```

   Use grep/awk to find # of predicted genes in each gff3/gff2 file:

   ```
   awk '$3 == "gene"' Sg337-maker.gff3 | wc -l
   grep "start gene" Sg337-augustus.gff3
   awk '{print $9}' Sg337-snap.gff2 | sort -u | wc -l
   ```
   maker gene count: 12807

   augustus gene count: 17352

   snap gene count: 12424

</details>

<details>
  <summary>
    13)Visualize genes using genome browser
  </summary>
   (https://igv.org/app/)
   upload MyGenomeID_final.fasta, and gff3 for snap, agustus, and MAKER
</details>

<details>
  <summary>
    14)Blast Aginst B71
  </summary>
   filter out contiges from blast, only take ones that dont match contig from our fasta file, list those

   ```
   blastn -query MyGenomeID.fasta -subject B71.fasta -evalue 1e-100 -outfmt 7 > MyGenomeID.B71.BLAST
   grep " 0 hits found" Sg337.B71.BLAST | wc -l
   grep " 0 hits found" -B 2 Sg337.B71.BLAST | grep -o "Sg337_contig[0-9]\{1,4\}"
   convert BLAST > gff3:
   awk 'BEGIN {OFS="\t"} 
   !/^#/ {
   start = ($7 <= $8) ? $7 : $8;
   end   = ($7 <= $8) ? $8 : $7;
   print $1, "awk", "BLAST", start, end, ".", "+", ".", "ID=none"
   }' B71.Sg337.BLAST > output.gff3

   ```

</details>

<details>
  <summary>
    15) Make protien fasta
  </summary>
    ```
    singularity exec /share/singularity/images/ccs/MAKER/amd-maker-debian10.sinf fasta_merge -d MyGenomeID_final.maker.output/MyGenomeID_final_master_datastore_index.log -o MyGenomeID
    ```
  
</details>

<details>
  <summary>
    16)Using RNAseq Data to Confirm Gene Predictions
  </summary>
  Change directory into RNAseq 
   
  Align the first set of reads to your MyGenome assembly - the version you used for gene prediction

  ```
   sbatch hisat2.sh path/to/MyGenomeID_final.fasta FR13_inCulture.fastq.gz

   ```

Look at the resulting alignment summary file to determine the fraction fo reads that aligned to your genome assembly

Align the second set of reads to your MyGenome assembly - the version you used for gene prediction

```
sbatch hisat2.sh path/to/MyGenomeID_final.fasta SSID116_inPlanta.fastq.gz

```

Look at the resulting alignment summary file to determine the fraction fo reads that aligned to your genome assembly

Transfer the alignment and index files (.bam and bam.bai) to the machine that is running IGV

Load your genome assembly into IGV and then load the tracks for your gene predictions and the RNAseq aligment data (make sure the .bai files are in the same directory as the .bam files)

region with no predicted gene and high expression

```
AATAAAGGAAGAGAGAAATCGTGCTAGATACGCCTTTTATAATACAGCGGGACCGGAATCGTTCAACACTCGCTCGGATTAACCCGGACAGACCACGACGTTAAAGTCCGACCCAATCTGACATCGTTACAGGTTTCCCCGACACTGACTCTGATACCCGTAATATAATCCGATTGATGAAACTTGATGCATTTTGCGCCGAGGCAATCGCCAAGGGTCCTGGAAGGTTTGAAGCTCCCGGCAAAAATGCAGACTAGACACCCGTTGATGGTTTGGTCGCTGTCCATATCCGACAAAGGGTACATTTTCTCCTGGTAATGCTCTTCAGGACTCGAGGGGCGGGCTGCTGAGATGGTGGTAGCCAAAGCGCAAAGTATGGGAACGGAAAGAGTTTGTTTGAACTGCATGATGATGTTTTTTGGTGTTGTTTGCTTGGCT
```

</details>

</details>

<details>
  <summary>
    17) Record methods and process for future work (This Github!)
</details>

<details>
  <summary>
    18) submit completed genome and information to NBCI.
</details>

