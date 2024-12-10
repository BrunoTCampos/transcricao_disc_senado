# transcricao_disc_senado

Este é um projeto atualizado para extrair os pronunciamentos de senadores e senadoras em R utilizando o pacote senateBr, e o scraping da transcrição via Phyton.

#Descrição para replicação abaixo

Seguir os scripts na ordem descrita:

list_sen: Modifica a função extrair_pronunciamentos_multi, do pacoteSenateBr para extrair todas as páginas de pronunciamentos do Dados Abertos do Senado, além de gerar anteriormente a lista de senadores com seus respectivos códigos (Rodar no R)

webscrap_sen: Com o banco de links de pronunciamentos, extrai via scraping a transcrição dos pronunciamentos do Senado via HTML (Rodar no Phyton, cerca de 5horas estimadas para conclusão

Uma breve amostra da base após o webscraping pode ser identificada neste [LINK](https://drive.google.com/drive/folders/1Kg5inGi0Ogvqu_7b4d2Ko1U7_pQHOyN8?usp=sharing) 
