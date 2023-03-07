# @mariabsantana | https://github.com/mariabsantana

if (!require("pacman")) install.packages("pacman", dependencies = TRUE)
pacman::p_load("rmarkdown", "rstudioapi")

path <- rstudioapi::getActiveDocumentContext()$path
Encoding(path) <- "UTF-8"
setwd(dirname(path))

rmarkdown::render('index.Rmd', params = list(
  token_redcap_sars2diag_igm = "E85A29833EAC67FCF7B3808C39AD0EED",
  report_redcap_sars2diag_igm = "14365",
  token_redcap_sars2diag_gal = "9A76419E81D44C9D8CF43F30AF8DA53B",
  report_redcap_sars2diag_gal = "14362",
  token_redcap_sars2seq = "9B9B95185552C9D2811F4E04A0E92E68",
  report_redcap_sars2seq = "14828",
  gisaid_username = "RKhour0",
  gisaid_password = "pjtWGX7!"))

file.remove(c("redcap_sars2diag_igm.csv", "redcap_sars2diag_gal.csv", "redcap_sars2seq.csv"))
