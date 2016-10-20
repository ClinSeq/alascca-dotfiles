#!/bin/bash

# conda
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
bash Miniconda-latest-Linux-x86_64.sh -b -p /nfs/ALASCCA/miniconda2

conda config --add channels dakl
conda config --add channels r
conda config --add channels bioconda

conda install -y -c dakl autoseq-scripts

pip install --upgrade pydotplus
pip install --upgrade vcf_parser
pip install --upgrade supervisor

mkdir -p /nfs/ALASCCA/logs

# pip install from github/clinseq
pip install --upgrade git+https://github.com/ClinSeq/referral-manager.git
pip install --upgrade git+https://github.com/clinseq/localq.git
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

git_clone_or_pull https://github.com/clinseq/autoseq.git /nfs/ALASCCA/autoseq

conda install -y --file /nfs/ALASCCA/autoseq/conda-list.txt
conda install -y --file /nfs/ALASCCA/autoseq/conda-list-tests.txt
pip install  /nfs/ALASCCA/autoseq

# needs pwd
git_clone_or_pull https://bitbucket.org/clinseq/aurora.git /nfs/ALASCCA/aurora
git_clone_or_pull https://bitbucket.org/clinseq/autoseqapi.git /nfs/ALASCCA/autoseq-api
git_clone_or_pull https://bitbucket.org/clinseq/clinseq-info /nfs/ALASCCA/clinseq-info
git_clone_or_pull https://bitbucket.org/clinseq/genome-resources /nfs/ALASCCA/genome-resources


pip install -r /nfs/ALASCCA/autoseq-api/requirements.txt
pip install -e /nfs/ALASCCA/autoseq-api

pip install -r /nfs/ALASCCA/aurora/requirements.txt
pip install -e /nfs/ALASCCA/aurora

pip install --upgrade git+https://bitbucket.org/clinseq/reportgen.git

# install R packages

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
