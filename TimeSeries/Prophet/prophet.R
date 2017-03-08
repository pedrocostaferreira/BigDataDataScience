
## Exercício com o novo pacote para séries temporais lançado pelo FACEBOOK.

# https://facebookincubator.github.io/prophet/docs/quick_start.html - neste site há vários
# exemplos de como otimizar o uso do pacote)

# Nesse exercício iremos replicar o exemplo feito pela equipe do Facebook com dados
# de vizualizações da página da wikepidia do Peyton Manning.

# Para capturar os dados vamos usar o pacote Wikipediatrend. Antes de iniciar nosso exemplo,
# vamos brincar um pouco com o pacote e ver o interesse das pessoas pelo termo "Big Data"
# aqui no Brasil e no Estados Unidos.


install.packages("wikipediatrend")
library(wikipediatrend)

Big_data_US <- wp_trend("Big_data", from = "2015-10-01", to = "2017-03-06",lang = "en")
plot(
  Big_data_US[, c("date","count")], 
  type="b"
)


Big_data_BR <- wp_trend("Big_data", from = "2015-10-01", to = "2017-03-06",lang = "pt")
plot(
  Big_data_BR[, c("date","count")], 
  type="b"
)


layout(1:2)
plot(
  Big_data_US[, c("date","count")], 
  type="b"
)

plot(
  Big_data_BR[, c("date","count")], 
  type="b"
)

# Parece que no Brasil a tendência está crescente nos últimos meses, enquanto nos EUA parece termos
# estabilidade. Contudo, vamos voltar ao nosso exemplo.

# Como disse anteriormente, o pessoal do Facebook "webscraped" os dados diretamente do wikipedia (como
# mostrado abaixo). Contudo, como eu quero replicar o exemplo que eles fizeram, eu carreguei a tabela
# disponibilizada por eles no Github.

#Peyton_Manning
Peyton_Manning <- wp_trend("Peyton_Manning", from = "2015-10-01", to = "2017-03-06",lang = "pt")
plot(
  Peyton_Manning[, c("date","count")], 
  type="b"
)

# Carregando os dados disponibilizados pela equipe do facebook
library(RCurl)
peython_URL <- getURL("https://raw.githubusercontent.com/facebookincubator/prophet/master/examples/example_wp_peyton_manning.csv")


# Transformação çog nas estatísticas de acesso
df <- read.csv(text = peython_URL)
df$logy <- log(df$y)

drops <- c("y")
df <- df[ , !(names(df) %in% drops)]

names(df)[names(df) =="logy"] <- "y"
head(df)


library(prophet)
library(dplyr)


# Resultados
m <- prophet(df)

future <- make_future_dataframe(m, periods = 365)
tail(future)

forecast <- predict(m, future)
tail(forecast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

plot(m, forecast)

prophet_plot_components(m, forecast)



