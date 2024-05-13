library(shiny)
library(shinyAce)
modes <- getAceModes()
#themes <- getAceThemes()



foo <- function() {
  pb <- progress_bar$new(
    format = " [:bar] :current/:total (:percent) eta: :eta",
    total = 5, clear = FALSE)
  for(i in 1:5) {
    pb$tick()
    Sys.sleep(1)
  }
}
init <- "
## Seccion 1 
Abrir Help menu = F1
# 
Usted puede incluir chunks con operaciones, abajo un ejemplo.
```{r}
2*3
```
```{r}
x <- rnorm(n=50)
head(x)
mean(x)
```
## Seccion 2
you can load datasets and libraries
```{r}
library(magrittr)
library(datasets)
data(iris)
```
```{r}
knitr::kable(head(iris))
```
```{r}
iris %>%
  group_by(Species) %>%
  summarise(mean = mean(Sepal.Length), sd = sd(Sepal.Length))
```
## Seccion 3
you also can make graphics
```{r}
plot(iris$Sepal.Length, iris$Sepal.Width)
```
```{r}
library(ggplot2)
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point()
```
## Sección 4
Ahora es su turno, construya un chunk sencillo.
```{r}
# Escriba aqui algo
```
"

