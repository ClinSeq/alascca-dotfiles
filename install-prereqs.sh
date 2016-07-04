#!/bin/bash

# conda
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b -p /nfs/ALASCCA/miniconda2

conda config --add channels r
conda config --add channels bioconda

wget -O /tmp/autoseq-conda-list.txt https://raw.githubusercontent.com/dakl/autoseq/master/conda-list.txt
conda install -y --file /tmp/autoseq-conda-list.txt
rm /tmp/autoseq-conda-list.txt

conda install -y cryptography psycopg2

pip install --upgrade pydotplus
pip install --upgrade vcf_parser
pip install --upgrade supervisor

mkdir -p /nfs/ALASCCA/logs

# pip install from github/clinseq
pip install --upgrade git+https://github.com/ClinSeq/referral-manager.git
pip install --upgrade git+https://github.com/dakl/localq.git
pip install --upgrade git+https://github.com/clinseq/multiqc-alascca.git
pip install --upgrade git+https://github.com/clinseq/pypedream.git

function git_clone_or_pull {
    if cd $2 ; then
      git pull
      cd ..
    else
      git clone $1 $2;
    fi
}

git_clone_or_pull https://github.com/dakl/autoseq-scripts /nfs/ALASCCA/autoseq-scripts
git_clone_or_pull https://github.com/dakl/autoseq.git /nfs/ALASCCA/autoseq
conda install --file /nfs/ALASCCA/autoseq/conda-list.txt
pip install /nfs/ALASCCA/autoseq 

# needs pwd
git_clone_or_pull https://bitbucket.org/clinseq/aurora.git /nfs/ALASCCA/aurora
git_clone_or_pull https://bitbucket.org/clinseq/genome-resources /nfs/ALASCCA/genome-resources
pip --upgrade /nfs/ALASCCA/aurora

DBCONF=/nfs/ALASCCA/clinseq-referraldb-config.json
if [ ! -e $DBCONF ]; then
  echo "Copying dbconfig"
  cp /nfs/ALASCCA/alascca-dotfiles/clinseq-referraldb-config.json $DBCONF
fi

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

echo
echo "you should now run "
echo generate-ref --genome-resources /nfs/ALASCCA/genome-resources --outdir /nfs/ALASCCA/autoseq-genome
echo "to generate reference files required by autoseq"

"
echo
