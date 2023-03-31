# @lpmor22 | https://lpmor22.github.io/

if (!require("pacman")) install.packages("pacman", dependencies = TRUE)
pacman::p_load("rmarkdown", "rstudioapi")

path <- rstudioapi::getActiveDocumentContext()$path
Encoding(path) <- "UTF-8"
setwd(dirname(path))

rmarkdown::render('index.Rmd', params = list(
  token_redcap_sars2diag_igm = "",
  report_redcap_sars2diag_igm = "",
  token_redcap_sars2diag_gal = "",
  report_redcap_sars2diag_gal = "",
  token_redcap_sars2seq = "",
  report_redcap_sars2seq = "",
  gisaid_username = "",
  gisaid_password = "!"))

file.remove(c("redcap_sars2diag_igm.csv", "redcap_sars2diag_gal.csv", "redcap_sars2seq.csv"))