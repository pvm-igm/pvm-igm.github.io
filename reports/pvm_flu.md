# Plataforma de Vigilância Molecular

## Análises do sequenciamento de genoma completo de Influenza

- [Requisitos do sistema][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#requisitos-m%C3%ADnimos-do-sistema]
- [Programas necessários][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]
- [Configuração do Linux para as análises de montagem dos genomas][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#configura%C3%A7%C3%A3o-do-linux-para-as-an%C3%A1lises-de-montagem-dos-genomas]
- [Download dos dados da corrida de sequenciamento][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#download-dos-dados-da-corrida-de-sequenciamento]
- [Avaliação da qualidade da corrida de sequenciamento][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#avalia%C3%A7%C3%A3o-da-qualidade-da-corrida-de-sequenciamento]
- [Montagem do genomas de Influenza][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#montagem-do-genomas-de-influenza]
- [Definição de cepa e resistência à antivirais]()
- [Submissão GISAID][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#submiss%C3%A3o-gisaid]
- [Backup dos dados][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#backup-dos-dados]

### Requisitos mínimos do sistema

|     |                                                |
| --- | ---------------------------------------------- |
| CPU | Ryzen 5 3ª  geração / Intel Core i5 8ª geração |
| RAM | 8 GB                                           |
| SO  | Windows 10 (64-bit)                            |
| WSL | versão 2                                       |

### Programas necessários

- [Illumina BaseSpace Sequence Hub CLI][https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview]
- [Illumina Sequencing Analysis Viewer (SAV)][https://support.illumina.com/sequencing/sequencing_software/sequencing_analysis_viewer_sav/downloads.html]
- [Microsoft Office 365 Educação][https://www.microsoft.com/pt-br/education/products/office]
- [Microsoft OneDrive][https://www.microsoft.com/pt-br/microsoft-365/onedrive/download]
- [Microsoft Teams][https://www.microsoft.com/pt-br/microsoft-teams/download-app]
- [Notepadd++][https://notepad-plus-plus.org/downloads]
- [rnapenr][https://github.com/khourious/rnapenr]
- [Windows Subsystem for Linux 2 (WSL2)][https://learn.microsoft.com/pt-br/windows/wsl/install]

### Configuração do Linux para as análises de montagem dos genomas

- No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# criar diretório para armazenar os dados baixados do BaseSpace
[ ! -d /mnt/c/BaseSpace/ ] && mkdir /mnt/c/BaseSpace/

# criar atalho de acesso do diretório BaseSpace no $HOME do usuário do Linux
ln -s /mnt/c/BaseSpace/ BaseSpace

# clonar o repositório do pipeline de montagem dos genomas
git clone --recursive https://github.com/khourious/rnapenr.git

# entrar no diretório rnapenr
cd rnapenr

# dar permissões de leitura e gravação ao arquivo de instalação das dependências do vigeas
chmod u+x flu.sh rnapenr.sh

# rodar a instalação do vigeas
bash INSTALL

# baixar o arquivo de instalação do BaseSpace CLI
wget "https://launch.basespace.illumina.com/CLI/latest/amd64-linux/bs" -O $HOME/bin/bs

# dar permissões de leitura e gravação ao BaseSpace
chmod u+x $HOME/bin/bs

# recarregar o perfil de configuração do shell
source $HOME/.$(ps -p $$ -ocomm=)rc

# gerar autorização de login do BaseSpace
bs auth
```

### Download dos dados da corrida de sequenciamento

Informar para o prompt de comando o nome da corrida de sequenciamento 

- No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# criar array com o nome da biblioteca de sequenciamento
LIBRARY=IGM_PVM_MISEQ_RNAPENR_LIBRARYyyyymmdd
```

Baixar os arquivos de qualidade da corrida

- No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# baixar os arquivos de qualidade da corrida
bs download run --no-metadata --summary -o $HOME/BaseSpace/"$LIBRARY"_SAV -n "$LIBRARY"
```

### Avaliação da qualidade da corrida de sequenciamento

Abrir o [Illumina Sequencing Analysis Viewer (SAV)][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios] e carregar o diretório da corrida para análise da qualidade:

```bash
Browse -> This PC -> WINDOWS (C:) -> BaseSpace -> IGM_PVM_MISEQ_DNAP_LIBRARYyyyymmdd_SAV -> OK
```

Avaliar os seguintes critérios:

- Aba **Analysis**
  - `Data By Cycle -> Intensity`: o plot apresenta a intensidade de sinal de cada nucleotídeo em relação aos ciclos. O esperado é o aumento gradual da intensidade no R1 e R4.
  - `Data By Cycle -> FWHM`: full width half max -- o plot apresenta a massa e tamanho das leituras para cada nucleotídeo em relação aos ciclos. O esperado são valores entre 2.0 - 3.5.
  - `Data By Cycle -> %>=Q30`: o plot apresenta a porcentagem de leituras com índice de qualidade PHRED maior ou igual a 30 em relação aos ciclos. A escala PHRED estima a probabilidade de erro na identificação das bases. PHRED 30 quer dizer 1 erro a cada 1000 bases, ou seja, acurácia de 99.90%. O esperado é uma perda de no máximo 10% no R1 e R4.
  - `Qscore Distribution -> Lane:All`: o plot apresenta a quantidade de leituras em milhões em relação ao índice de qualidade PHRED. O esperado são valores acima de 80% para cartuchos 300-V2, acima de 85% para 150-V3 e acima de 70% para 600-V3.
  - `Data By Lane -> Density`: o plot apresenta a densidade total dos clusters detectados (azul) e dos clusters que passaram no filtro de qualidade de intensidade (verde) em relação à lane. O esperado é uma sobreposição dos boxplots, além de valores de densidade total dos clusters entre 600-1200 para cartuchos V2 e 1200-1400 para cartuchos V3.
  - `QScore Heatmap -> Lane:All`: o plot apresenta a avaliação do índice de qualidade PHRED em valor (eixo Y1), porcentagem das leituras (eixo Y2) em relação relação aos ciclos. O esperado é um heatmap com densidade mais próxima da cor vermelha por toda a construção das leituras no R1 e R4.

- Aba **Analysis**
  - As imagens podem ser utilizadas no caso de alterações nos parâmetros de qualidade para auxiliar no entendimento do problema.

- Aba **Summary**
  - `Run Summary -> Aligned (%)`: taxa de leituras alinhadas ao genoma PhiX. O esperado são valores próximos de 1%.
  - `Run Summary -> Error Rate (%)`: taxa de erro da corrida de sequenciamento calculada com base nas leituras alinhadas ao PhiX. O esperado são valores próximos de 0.10.
  - `Read 1 / Read 4 -> Density (K/mm2)`: taxa de densidade dos clusters detectados pela análise das imagens. O esperado são valores de densidade total dos clusters entre 600-1200 para cartuchos V2 e 1200-1400 para cartuchos V3.
  - `Read 1 / Read 4 -> Cluster PF (%)`: taxa dos clusters que passam no critério de qualidade de brilho obtido dos clusters na formação das imagens. O esperado são valores próximos de 100%, com desvio-padrão próximo de 0.10.
  - `Read 1 / Read 4 -> Legacy Phasing/Prephasing Rate`: taxa das moléculas em um cluster com perda de sincronismo no momento da detecção de fluorescência. *Phasing* é quando o sequenciamento *fica para trás* e *Prephasing*, quando *avança demais*. O esperado são valores iguais ou abaixo de 0.25 para R1 e R4.
  - `Read 1 / Read 4 -> %>=Q30`: taxa de bases geradas com um índice de qualidade PHRED igual ou maior que 30. A escala PHRED estima a probabilidade de erro na identificação das bases. PHRED 30 quer dizer 1 erro a cada 1000 bases, ou seja, acurácia de 99.90%. O esperado são valores acima de 80% para cartuchos 300-V2, acima de 85% para 150-V3 e acima de 70% para 600-V3.
  - `Read 1 / Read 4 -> Intensity Cycle 1`: média da intensidade da corrida mensurada após o ciclo 1. O esperado são valores acima de 90.

### Montagem do genomas de Influenza

Identificar o nome da biblioteca de sequenciamento para utilizar no Linux, editando o array `LIBRARY`:

- No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# converter quebras de linha do formato DOS para UNIX
dos2unix $HOME/PVM_SEQ/SAMPLE_SHEETS/"$LIBRARY".csv

# editar samplesheet da biblioteca de sequenciamento
nano $HOME/PVM_SEQ/SAMPLE_SHEETS/"$LIBRARY".csv
```

Avaliar a samplesheet do sequenciamento de acordo com os seguintes critérios:

- As amostras devem ser identificadas pelo tracking ID biobanco
- A coluna descrição deve conter a informação do painel de enriquecimento utilizado (*i.e.* RVOP).

No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# atualizar lista de pacotes do linux
sudo apt-get -y update

# atualizar o linux e dependências instaladas
sudo apt-get -y full-upgrade

# remover dependências que não são mais necessárias
sudo apt-get autoremove

# remover arquivos de instalações de dependências
sudo apt-get auto-clean

# remover arquivos de instalações de dependências que o auto-clean não consegue resolver
sudo apt-get -y purge $(dpkg -l | awk '/^rc/ {print $2}')

# checar se há dependências quebradas
sudo apt-get check

# limpar o cachê do conda
conda clean -ay

# atualizar as dependências utililizadas pelos ambientes do rnapenr
mamba update -y -n rnapenr -c conda-forge -c anaconda -c bioconda -c defaults --all
```

No [WSL2][https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]

```bash
# rodar o vigeas para realizar a montagem dos genomas de SARS-CoV-2
bash rnapenr.sh -s $HOME/PVM_SEQ/SAMPLE_SHEETS/"$LIBRARY".csv
```

A montagem dos genoma demora cerca de *XX* minutos por referência em um computador com *hardware* de 9ª geração Intel Core i7 com 16 GB de memória RAM.

XXX

### XXX

### Submissão GISAID

XXX

#### Submissão via web

XXX

#### Submissão via GISAID CLI

XXX

### Backup dos dados

XXX

[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#requisitos-m%C3%ADnimos-do-sistema]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#requisitos-m%C3%ADnimos-do-sistema
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#configura%C3%A7%C3%A3o-do-linux-para-as-an%C3%A1lises-de-montagem-dos-genomas]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#configura%C3%A7%C3%A3o-do-linux-para-as-an%C3%A1lises-de-montagem-dos-genomas
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#download-dos-dados-da-corrida-de-sequenciamento]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#download-dos-dados-da-corrida-de-sequenciamento
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#avalia%C3%A7%C3%A3o-da-qualidade-da-corrida-de-sequenciamento]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#avalia%C3%A7%C3%A3o-da-qualidade-da-corrida-de-sequenciamento
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#montagem-do-genomas-de-influenza]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#montagem-do-genomas-de-influenza
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#submiss%C3%A3o-gisaid]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#submiss%C3%A3o-gisaid
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#backup-dos-dados]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#backup-dos-dados
[https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview]: https://developer.basespace.illumina.com/docs/content/documentation/cli/cli-overview
[https://support.illumina.com/sequencing/sequencing_software/sequencing_analysis_viewer_sav/downloads.html]: https://support.illumina.com/sequencing/sequencing_software/sequencing_analysis_viewer_sav/downloads.html
[https://www.microsoft.com/pt-br/education/products/office]: https://www.microsoft.com/pt-br/education/products/office
[https://www.microsoft.com/pt-br/microsoft-365/onedrive/download]: https://www.microsoft.com/pt-br/microsoft-365/onedrive/download
[https://www.microsoft.com/pt-br/microsoft-teams/download-app]: https://www.microsoft.com/pt-br/microsoft-teams/download-app
[https://notepad-plus-plus.org/downloads]: https://notepad-plus-plus.org/downloads
[https://github.com/khourious/rnapenr]: https://github.com/khourious/rnapenr
[https://learn.microsoft.com/pt-br/windows/wsl/install]: https://learn.microsoft.com/pt-br/windows/wsl/install
[https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios]: https://github.com/pvm-igm/pvm-igm.github.io/blob/main/reports/pvm_flu.md#programas-necess%C3%A1rios
