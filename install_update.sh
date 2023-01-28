#!/bin/bash

REDCAP_TOKEN_1=${1}
REDCAP_REPORT_ID_1=${2}
REDCAP_TOKEN_2=${3}
REDCAP_REPORT_ID_2=${4}
REDCAP_TOKEN_3=${5}
REDCAP_REPORT_ID_3=${6}
GISAID_USERNAME=${7}
GISAID_PASSWORD=${8}
GITHUB_USERNAME=${9}
GITHUB_EMAIL=${10}
GITHUB_TOKEN=${11}

if [[ -z $(dpkg -s | egrep "Package: libcurl4-openssl-dev|Package: libgdal-dev") ]]; then
    sudo apt-get install libcurl4-openssl-dev libgdal-dev
fi

if [[ -z $(conda env list | grep flexdashboard) ]]; then
    mamba create -y -n flexdashboard -c conda-forge -c r r-base r-devtools r-dplyr r-flexdashboard r-fontawesome==0.3.0 r-ggplot2 r-htmltools r-knitr r-lubridate r-markdown r-plotly r-plyr r-reshape2 r-rstudioapi
    source activate flexdashboard
    Rscript -e "install.packages(\"pandoc\", repos=\"http://cran.us.r-project.org\")"
    Rscript -e "install.packages(\"REDCapR\", repos=\"http://cran.us.r-project.org\")"
    Rscript -e "devtools::install_github(\"Wytamma/GISAIDR\")"
fi

rm -rf $HOME/pvm-igm.github.io/REDCap_DIAGCOVID19_DATA_*.csv

DATA="token="$REDCAP_TOKEN_2"&content=report&format=csv&report_id="$REDCAP_REPORT_ID_2"&rawOrLabel=raw&rawOrLabelHeaders=raw&exportCheckboxLabel=false&returnFormat=csv"
CURL=`which curl`
$CURL -s -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/json" -X POST -d $DATA https://bdp.bahia.fiocruz.br/api/ > $HOME/pvm-igm.github.io/REDCap_DIAGCOVID19_DATA_$(date +'%Y-%m-%d').csv

source activate flexdashboard

cd $HOME/pvm-igm.github.io

Rscript --vanilla -e "rmarkdown::render('index.Rmd')" "$REDCAP_TOKEN_1" "$REDCAP_REPORT_ID_1" "$REDCAP_TOKEN_3" "$REDCAP_REPORT_ID_3" "$GISAID_USERNAME" "$GISAID_PASSWORD"

git add "index.html"
git status
git config user.name "$GITHUB_USERNAME"
git config user.email "$GITHUB_EMAIL"
git commit -m "PVM Dashboard $(date +'%Y-%m-%d')"
git remote remove origin
git remote add origin https://"$GITHUB_TOKEN":"$GITHUB_TOKEN"@gitlab.com/pvm-igm/pvm-igm.github.io.git
git push https://"$GITHUB_TOKEN"@github.com/pvm-igm/pvm-igm.github.io.git main
