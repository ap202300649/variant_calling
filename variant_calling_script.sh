#!/bin/bash
set -euo pipefail

# Variables
SAMPLE="ERR13482692"
REF="/home/abhi/ref/ref_genome.fa"
THREADS=8

# Download SRA Data
echo "Downloading SRA data..."

prefetch ${SAMPLE}

fasterq-dump ${SAMPLE}  --split-files  --threads ${THREADS}

# Quality Control
echo "Running FastQC"

mkdir -p fastqc_results

fastqc  ${SAMPLE}_1.fastq ${SAMPLE}_2.fastq -o fastqc_results

# Adapter Trimming
echo "Running Fastp"

fastp -i ${SAMPLE}_1.fastq -I ${SAMPLE}_2.fastq -o trimmed_1.fastq -O trimmed_2.fastq -h fastp_report.html -j fastp_report.json

# Reference Index
echo "Indexing reference"

bwa index ${REF}

# Alignment
echo "Running BWA-MEM"

bwa mem -t ${THREADS} ${REF} ${SAMPLE}.trimmed_1.fastq ${SAMPLE}.trimmed_2.fastq > ${SAMPLE}.sam

# Alignment QC
echo "Alignment statistics"

samtools flagstat ${SAMPLE}.sam > ${SAMPLE}.alignment_stats.txt

# SAM -> BAM
echo "Converting SAM to BAM"

samtools view -@ ${THREADS} -bS align.sam  > ${SAMPLE}.align.bam

# Sort BAM
echo "Sorting BAM"

samtools sort -@ ${THREADS} -o ${SAMPLE}.sorted.bam ${SAMPLE}.align.bam

# Index BAM
echo "Indexing BAM"

samtools index ${SAMPLE}.sorted.bam

# Variant Calling
echo "Calling variants"

bcftools mpileup -Ou -f ${REF} ${SAMPLE}.sorted.bam | \
bcftools call -mv -Oz -o ${SAMPLE}.variants.vcf.gz

# Index VCF
echo "Indexing VCF"

bcftools index ${SAMPLE}.variants.vcf.gz

# Variant Filtering
echo "Filtering variants"

bcftools filter -e 'QUAL<30 || DP<15' ${SAMPLE}.variants.vcf.gz -Oz -o ${SAMPLE}.filtered_variants.vcf.gz

bcftools index ${SAMPLE}.filtered_variants.vcf.gz

# Variant Annotation
echo "Running SnpEff"

java -Xmx4g -jar snpEff.jar GRCh38.99 filtered_variants.vcf.gz     > snpeff_annotated_variants.vcf

echo "Pipeline completed successfully!"
