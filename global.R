library(shiny)
library(shinyAce)

modes <- getAceModes()
themes <- getAceThemes()

init <- "```{r}
2*3
rnorm(5)
```


```{r}
hist(rnorm(100))
```
"