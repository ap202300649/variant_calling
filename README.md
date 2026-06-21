# End-to-end germline variant calling pipeline using FastQC, Fastp, BWA, Samtools, BCFtools and SnpEff.

****Variant calling** Variant calling is a bioinformatics process used to identify genetic variations, such as single nucleotide polymorphisms (SNPs) and insertions or deletions (indels), from sequencing data. It involves aligning raw DNA or RNA sequence reads to a reference genome, analyzing discrepancies between the reference and the sample, and determining the location, type, and frequency of these variations. This process is critical for studying genetic diversity, understanding disease mechanisms, and identifying potential therapeutic targets.

**Data collection** 
- Quality control performed using FastQC to ensure suitability for downstream analysis.
- Most samples showed Phred scores above 30 across the read length, which indicating high-quality bases. Per sequence GC content is 47% . No overrepresented sequences were flagged.
- https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit

**Quality control of data**
- fastp tools used to remove adapter sequences and low-quality reads.
- https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
- https://github.com/OpenGene/fastp

**Alignment to refrence genome**
- BWA tool used to alignment to reference genome. samtools are used to sorting and indexing.
- All reads were successfully aligned to the reference genome.Alignment metrics showed 98.34%. mapping rate for most samples. Sorted BAM files are ready for variant calling.
- https://github.com/lh3/bwa
- https://github.com/lh3/bwa
  
**Variant calling**
- bcftools used to identify single nucleotide polymorphisms (SNPs) and insertions/deletions (indels) in the aligned reads. BAM file used as input and output vcf file using bcftools. 
- bcftools used to identify single nucleotide polymorphisms (SNPs) and insertions/deletions (indels) in the aligned reads. BAM file used as input and output vcf file using bcftools. 
- https://samtools.github.io/bcftools/bcftools.html

**Variant annotation**
- SnpEff is used to annotate and predict the effects of genetic variants, such as SNPs and indels, on genes 
- https://pcingola.github.io/SnpEff/snpeff/introduction/

