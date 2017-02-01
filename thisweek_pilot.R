require(fivethirtyeight)

data("bechdel")
bechdel

require(tidyverse)
bechdel %>% filter(between(year, 1990, 2013))

require(tidyquant)
end <- ymd("2017-01-01")
start <- end - weeks(20)
AMZN <- tq_get("AMZN", get = "stock.prices", from = "2007-01-01", to = "2017-01-01")
AMZN %>%
    ggplot(aes(x = date, y = close)) +
    geom_candlestick(aes(open = open, close = close, high = high, low = low)) +
        labs(title = "AMZN: New Candlestick Geom!",
             subtitle = "Visually shows open, high, low, and close information, along with direction",
             x = "", y = "Closing Price") +
        coord_x_date(xlim = c(start, end),
                                            ylim = c(700, 870))

### this week in R-tips
### the tee operator
require(magrittr)

iris %>% write.csv('iris.csv') %>% ggplot(aes(x = Sepal.Length, y = Petal.Length))

iris %T>% write.csv('iris.csv') %>% ggplot(aes(x = Sepal.Length, y = Petal.Length)) + geom_point()
