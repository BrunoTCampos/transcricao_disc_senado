# transcricao_disc_senado

Este é um projeto atualizado para extrair os pronunciamentos de senadores e senadoras em R utilizando o pacote senateBr, e o scraping da transcrição via Phyton.

#Descrição para replicação abaixo

Seguir os scripts na ordem descrita:

list_sen: Modifica a função extrair_pronunciamentos_multi, do pacoteSenateBr para extrair todas as páginas de pronunciamentos do Dados Abertos do Senado, além de gerar anteriormente a lista de senadores com seus respectivos códigos (Rodar no R)

webscrap_sen: Com o banco de links de pronunciamentos, extrai via scraping a transcrição dos pronunciamentos do Senado via HTML (Rodar no Phyton, cerca de 5horas estimadas para conclusão

Uma breve amostra da base após o webscraping pode ser identificada neste [LINK](https://docs.google.com/spreadsheets/d/1niSbrcqGPrELGrbkw_gLZUUTLSDUPQC3/edit?usp=drive_link&ouid=110920979253900523385&rtpof=true&sd=true) ou em [CSV](https://drive.google.com/file/d/1LKc6RlFqEd72SyzOYyBqLvN364S4y_6O/view?usp=drive_link)
