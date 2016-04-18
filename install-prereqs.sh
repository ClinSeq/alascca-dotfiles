#!/bin/bash

# conda
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b -p /nfs/ALASCCA/miniconda2

conda config --add channels r
conda config --add channels bioconda
conda install -y  pip cython

ALIGNERS="bwa=0.7.12 star=2.4.2a"
TOOLSETS="picard=1.141 samtools=1.2 bcftools=1.2 samblaster=0.1.22 sambamba=0.5.9 vt=2015.11.10 vcflib=1.0.0_rc0 fastqc=0.11.4 bedtools=2.25.0"
VARIANTCALLERS="freebayes=1.0.1 scalpel=0.5.1 pindel=0.2.5a7 lofreq=2.1.2 vardict-java=1.4.3 vardict=2016.02.19 cnvkit=0.7.9" 
PACKAGES="pysam=0.8.4 pyvcf=0.6.8.dev0"

# this upgrades ncurses to 5.9.4 which samtools needs
conda install -y -c r ncurses 

# install matplotlib from conda since it fails when installing from source from pypi using pip
conda install -y matplotlib

conda install -y -c r r=3.2.2 r-devtools 
conda install -y -c bioconda r-pscbs
conda install -y -c bioconda skewer=0.1.126
conda install -y -c bioconda $ALIGNERS
conda install -y -c bioconda $TOOLSETS
conda install -y -c bioconda $VARIANTCALLERS
conda install -y -c bioconda $PACKAGES
conda install -y pyodbc

pip install --upgrade jsonschema
pip install --upgrade click
pip install --upgrade pydotplus
pip install --upgrade pymongo
pip install --upgrade vcf_parser
pip install --upgrade git+https://github.com/ewels/MultiQC.git
pip install --upgrade git+https://github.com/dakl/localq.git

# pip install from github/clinseq
pip install --upgrade git+https://github.com/clinseq/multiqc-alascca.git
pip install --upgrade git+https://github.com/clinseq/pypedream.git

# pip install from bitbucket/clinseq
pip uninstall reportgen || pip install git+https://bitbucket.org/clinseq/reportgen.git
pip install --upgrade git+https://bitbucket.org/clinseq/pyautoseq.git
git clone https://bitbucket.org/clinseq/pipeline-tools /nfs/ALASCCA/pipeline-tools

## linuxbrew
git clone https://github.com/Linuxbrew/linuxbrew.git /nfs/ALASCCA/linuxbrew
brew install ack tree 

# install R packages
Rscript install-r-packages.R                                                                                                              

## TexLive 2015
cd /tmp
wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -zxvf install-tl-unx.tar.gz
cd install-tl-*
./install-tl -profile /nfs/ALASCCA/alascca-dotfiles/texlive.profile
