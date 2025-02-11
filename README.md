# transcricao_disc_senado 

## 📖: Autor
Bruno Campos

Master's student, International Relations, University of São Paulo

## About the project

This is an updated project to extract transcripts of speeches by senators in R. Using the output extracted from the '{senatebR}' package, a web scraping script in Python was created to visit and extract the transcripts of the speeches.

## Replication Description

Follow the scripts in the order described below:

list_sen: Modifies the function '{extrair_pronunciamentos_multi}' from the '{senatebR}' package to extract all pages of speeches from the Brazilian Senate's Open Data, in addition to generating a list of senators with their respective identification codes (R Script).

webscrap_sen: Using a database of speech links in an XLSX file, extracts the Senate speech transcripts via HTML scraping (Python Script).

A brief sample of the dataset after web scraping can be found at this [LINK](https://drive.google.com/drive/folders/1Kg5inGi0Ogvqu_7b4d2Ko1U7_pQHOyN8?usp=sharing) 
