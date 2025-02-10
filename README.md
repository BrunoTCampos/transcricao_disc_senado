# transcricao_disc_senado 

## 📖: Autor
Bruno Campos

Master's student, International Relations, University of São Paulo

## About the project

Este é um projeto atualizado para extrair as transcrições dos pronunciamentos de senadores e senadoras em R. Utilizando a saída extraída do pacote `{senatebR}`, foi criado um webscraping em Phyton para a visita e extração das transcrições dos pronunciamentos. 

## Descrição para replicação abaixo

Seguir os scripts na ordem descrita:

list_sen: Modifica a função extrair_pronunciamentos_multi, do pacote `{senatebR}` para extrair todas as páginas de pronunciamentos do Dados Abertos do Senado, além de gerar anteriormente a lista de senadores com seus respectivos códigos de identificação (R Script)

webscrap_sen: Com o banco de links de pronunciamentos em um XLSX, extrai via scraping a transcrição dos pronunciamentos do Senado via HTML (Phyton Script)

Uma breve amostra da base após o webscraping pode ser identificada neste [LINK](https://drive.google.com/drive/folders/1Kg5inGi0Ogvqu_7b4d2Ko1U7_pQHOyN8?usp=sharing) 
