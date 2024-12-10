#SCRIPT DEFINITIVO - TRATAMENTO DE DADOS DO SENADO
#Discursos em plenário (2011-2023)
#BRUNO CAMPOS
#Webscraping dos discursos extraídos pelo pacote SenateBr

import pandas as pd
import requests
from bs4 import BeautifulSoup
import time
import requests

# Carregar o nosso arquivo já com os links dos pronunciamentos
df = pd.read_csv('df_sen.csv')

# Cria uma lista para armazenar as transcrições
transcriptions = []
start_time = time.time()

# Cria um loop para pegar todos os links dos pronunciamentos
for index, row in df.iterrows():
    link = row['Link_Pronunciamento']
    if link:  
        # Send an HTTP request to the link
        response = requests.get(link)
        # Parse the HTML content using Beautiful Soup
        soup = BeautifulSoup(response.content, 'html.parser')
        # Encontra o trecho do HTML em que está a transcrição, chamaremos de "texto integral" assim como está no site do Senado
        div = soup.find('div', {'class': 'texto-integral'})
        if div:
            # Extrair a transcrição
            transcription = div.get_text()
            transcriptions.append(transcription)
        else:
            transcriptions.append(None)  # Se a transcrição estiver vazia

            # Calculate the estimated time remaining
        current_time = time.time()
        elapsed_time = current_time - start_time
        estimated_time_remaining = (elapsed_time / (index + 1)) * (len(df) - index - 1)

        # Print the progress
        remaining_iterations = len(df) - index - 1
        print(f"Iteration {index+1}/{len(df)} - Remaining iterations: {remaining_iterations} - Estimated time remaining: {estimated_time_remaining:.2f} seconds")


# Colocar todas as transcrições em uma nova coluna no nosso data.frame
df['texto_integral'] = transcriptions

# Salvar o nosso data.frame novo
df.to_csv('df_sen.csv', index=False)
