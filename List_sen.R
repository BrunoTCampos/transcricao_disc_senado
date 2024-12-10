#SCRIPT DEFINITIVO - TRATAMENTO DE DADOS DO SENADO
#Discursos em plenário (2011-2023)
#BRUNO CAMPOS
#Modificado a partir do pacote SenateBr, criado por Vinicius Santos
#

##############################################

#' Extrai dados de pronunciamentos de múltiplos parlamentares em diferentes anos
#'
#' Esta função extrai dados de pronunciamentos de múltiplos parlamentares para os anos fornecidos.
#'
#' @param codigos_parlamentares Vetor de códigos dos parlamentares.
#' @param anos Vetor de anos para os quais os pronunciamentos serão extraídos.
#'
#' @return Um dataframe contendo os dados de pronunciamentos de múltiplos parlamentares.
#' Se nenhum dado estiver disponível, retorna NULL.
#'
#' @examples
#' codigo <- c(5672, 5386)
#' ano <- c(2023, 2024)
#' dados_multi <- extrair_pronunciamentos_multi(codigos_parlamentares = codigo, anos = ano)
#'
#' @import rvest
#' @import dplyr
#' @export

library(dplyr)
library(rvest)

extrair_pronunciamentos_multi_ALT <- function(codigos_parlamentares, anos) {
  # Verificação e carregamento dos pacotes necessários
  if (!requireNamespace("rvest", quietly = TRUE)) {
    stop("Pacote 'rvest' não está instalado. Por favor, instale-o usando install.packages('rvest').")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Pacote 'dplyr' não está instalado. Por favor, instale-o usando install.packages('dplyr').")
  }
  
  # Lista para armazenar os dataframes de pronunciamentos de cada parlamentar
  lista_dados <- list()
  
  # Itera sobre cada código de parlamentar
  for (codigo in codigos_parlamentares) {
    # Lista para armazenar os dataframes de pronunciamentos do parlamentar atual
    dados_parlamentar <- list()
    
    # Itera sobre cada ano
    for (ano in anos) {
      # URL da página com a tabela
      url <- paste0("https://www25.senado.leg.br/web/atividade/pronunciamentos/-/p/parlamentar/",
                    codigo, "/", ano)
      #ALT: Cria uma lista vazia antes para todas as páginas
      dados_parlamentar <- list()
      
      #ALT: Cria o loop de todas as páginas de resultados, com um limite inicial de 100
      page <- 1
      max_pages <- 100 
      while (page <= max_pages) {
        #ALT: O URL + a página atual após o último "/"
        url_page <- paste0(url, "/", page)
        
      # Ler o HTML da página
      pagina <- rvest::read_html(url_page)
      
      # Extrair os dados individualmente usando seletores CSS
      data_pronunciamento <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(1) a") %>%
        rvest::html_text()
      
      tipo_pronunciamento <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(2)") %>%
        rvest::html_text()
      
      casa <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(3)") %>%
        rvest::html_text()
      
      partido_uf <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(4)") %>%
        rvest::html_text()
      
      resumo_pronunciamento <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(5)") %>%
        rvest::html_text()
      
      # Extrair os links dos pronunciamentos
      links_pronunciamento <- pagina %>%
        rvest::html_nodes("table.table.table-striped tbody tr td:nth-child(1) a") %>%
        rvest::html_attr("href")
      
      # Verifica se há dados disponíveis antes de criar o dataframe
      if (length(data_pronunciamento) > 0) {
        # Combina os dados extraídos em um dataframe
        dados <- data.frame(Codigo_Parlamentar = rep(codigo, length(data_pronunciamento)),
                            Ano = rep(ano, length(data_pronunciamento)),
                            Data_Pronunciamento = data_pronunciamento,
                            Tipo_Pronunciamento = tipo_pronunciamento,
                            Casa = casa,
                            Partido_UF = partido_uf,
                            Resumo_Pronunciamento = resumo_pronunciamento,
                            Link_Pronunciamento = links_pronunciamento,
                            stringsAsFactors = FALSE)
        
        # Adiciona o dataframe de pronunciamentos do ano atual à lista
        dados_parlamentar[[as.character(page)]] <- dados
      } else {
        # Se não houver discursos do senador na determinada página
        break
      }
      
      # Aumentar o número de páginas de 1 em 1
      page <- page + 1
      }
    
      # Combinar os dataframes de pronunciamentos de diferentes anos em um único dataframe para o parlamentar atual
      if (length(dados_parlamentar) > 0) {
        dados_completos_parlamentar <- dplyr::bind_rows(dados_parlamentar)
        
        # Adiciona o dataframe completo do parlamentar à lista
        lista_dados[[as.character(codigo)]] <- dados_completos_parlamentar
      }
    }
  }
  
  # Verifica se há dados disponíveis antes de combinar os dataframes
  if (length(lista_dados) > 0) {
    # Combinar os dataframes de todos os parlamentares em um único dataframe
    dados_completos <- dplyr::bind_rows(lista_dados)
    
    # Retorna o dataframe completo
    return(dados_completos)
  } else {
    # Retorna NULL se nenhum dado estiver disponível
    return(NULL)
  }
}

obter_dados_senadores_legislatura <- function(legislatura_inicio, legislatura_fim) {
  requireNamespace("httr", quietly = TRUE)
  requireNamespace("jsonlite", quietly = TRUE)
  
  # Construa a URL com base nas legislaturas fornecidas
  url <- paste0("https://legis.senado.leg.br/dadosabertos/senador/lista/legislatura/", legislatura_inicio, "/", legislatura_fim)
  
  # Faça a requisição GET
  response <- httr::GET(url, httr::add_headers(accept = "application/json"))
  
  # Verifique se a requisição foi bem-sucedida (código de status na faixa 2xx)
  if (httr::status_code(response) >= 200 && httr::status_code(response) < 300) {
    # Leia os dados JSON da resposta
    json_data <- jsonlite::fromJSON(httr::content(response, "text"), flatten = TRUE)
    
    # Acesse os dados dos parlamentares
    df_parlamentares <- json_data$ListaParlamentarLegislatura$Parlamentares$Parlamentar
    
    # Verifique se há dados disponíveis
    if (length(df_parlamentares) > 0) {
      # Crie um dataframe com as informações dos senadores
      df_senadores <- data.frame(df_parlamentares, stringsAsFactors = FALSE)
    } else {
      # Se não há dados, crie um dataframe vazio
      df_senadores <- data.frame()
      warning("Não há dados de senadores disponíveis para as legislaturas fornecidas.")
    }
  } else {
    # Se a requisição falhar, imprima uma mensagem de erro
    stop("Falha na requisição. Código de status: ", httr::status_code(response))
  }
  
  # Retorne o dataframe com os dados dos senadores
  return(df_senadores)
}

df_senadores_54 <- obter_dados_senadores_legislatura(54)
df_senadores_55 <- obter_dados_senadores_legislatura(54)
df_senadores_56 <- obter_dados_senadores_legislatura(54)
df_senadores_57 <- obter_dados_senadores_legislatura(54)

codigos_54 <- unique(df_senadores_54$IdentificacaoParlamentar.CodigoParlamentar)
codigos_55 <- unique(df_senadores_55$IdentificacaoParlamentar.CodigoParlamentar)
codigos_56 <- unique(df_senadores_56$IdentificacaoParlamentar.CodigoParlamentar)
codigos_57 <- unique(df_senadores_57$IdentificacaoParlamentar.CodigoParlamentar)

anos <- (2011: 2023)

df_sen2011 <- extrair_pronunciamentos_multi(codigos_54, 2011)
df_sen2012 <- extrair_pronunciamentos_multi(codigos_54, 2012)
df_sen2013 <- extrair_pronunciamentos_multi(codigos_54, 2013)
df_sen2014 <- extrair_pronunciamentos_multi(codigos_54, 2014)
df_sen2015 <- extrair_pronunciamentos_multi(codigos_55, 2015)
df_sen2016 <- extrair_pronunciamentos_multi(codigos_55, 2016)
df_sen2017 <- extrair_pronunciamentos_multi(codigos_55, 2017)
df_sen2018 <- extrair_pronunciamentos_multi(codigos_55, 2018)
df_sen2019 <- extrair_pronunciamentos_multi(codigos_56, 2019)
df_sen2020 <- extrair_pronunciamentos_multi(codigos_56, 2020)
df_sen2021 <- extrair_pronunciamentos_multi(codigos_56, 2021)
df_sen2022 <- extrair_pronunciamentos_multi(codigos_56, 2022)
df_sen2023 <- extrair_pronunciamentos_multi(codigos_57, 2023)

#Unir dos dfs
dfs <- list(df_sen2011, df_sen2012, df_sen2013, df_sen2014, df_sen2015, df_sen2016, df_sen2017, df_sen2018, df_sen2019, df_sen2020, df_sen2021, df_sen2022, df_sen2023)
df_sen <- do.call(rbind, dfs)
write.csv(df_sen, "df_sen.csv", row.names = FALSE)