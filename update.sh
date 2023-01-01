#!/bin/bash

# mamba create -y -n flexdashboard -c conda-forge -c r pandoc r-devtools r-dplyr r-flexdashboard r-fontawesome==0.3.0 r-ggplot2 r-htmltools r-knitr r-lubridate r-markdown r-plotly r-plyr r-reshape2

DATA1 = "token=431A5D970FFD7855F1A5542CC1662EA5&content=report&format=csv&report_id=14363&rawOrLabel=raw&rawOrLabelHeaders=raw&exportCheckboxLabel=false&returnFormat=csv"
CURL = `which curl`
$CURL -s -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/json" -X POST -d $DATA1 https://bdp.bahia.fiocruz.br/api/ > $HOME/PVM_SEQ/BANCO_DE_DADOS/REDCap_DIAGCOVID19_DATA_$(date +'%Y-%m-%d').csv

source activate flexdashboard

Rscript --vanilla -e "rmarkdown::render('../index.Rmd')"

cd /mnt/c/OneDrive/OneDrive\ -\ FIOCRUZ/lpmor22/scripts/ALIENWARE_M15_R2/pvm-igm.github.io/

git add "index.html"
git status
git commit -m "PVM Dashboard $(date +'%Y-%m-%d')"
git remote remove origin
git remote add origin https://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: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@gitlab.com/pvm-igm/pvm-igm.github.io.git
git push https://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@github.com/pvm-igm/pvm-igm.github.io.git main
