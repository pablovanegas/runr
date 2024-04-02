library(shiny)
library(shinyAce)

modes <- getAceModes()
themes <- getAceThemes()

init <- "
Esta es tu editor de codigo

Abrir Help menu = F1

# Puedes añadir titulos!
Y cualquier modificacion usual en un markdown
```{r}
2*3
```

you can load datasets

```{r}
data(iris)
```

and libraries

```{r}
library(dplyr)
iris %>%
  filter(Species == 'setosa') %>% head(5)
```

and load online data

```{r}
library(readr)
url <- 'https://raw.githubusercontent.com/fhernanb/datos/master/medidas_cuerpo2'

# Usa guess_delim() para adivinar el delimitador
delim <- guess_delim(url)

# Luego, usa read_delim() con el delimitador adivinado
df1 <- read_delim(url, delim = delim, skip = 13, quote = '')

print(head(df1), 5)

```
"

#Corregir carga del data frame online