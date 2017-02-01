require(fst)

nrOfRows <- 1e7
x <- data.frame(
    Integers = 1:nrOfRows,  # integer
    Logicals = sample(c(TRUE, FALSE, NA), nrOfRows, replace = TRUE),  # logical
    Text = factor(sample(state.name, nrOfRows, replace = TRUE)),  # text
    Numericals = runif(nrOfRows, 0.0, 100),  # numericals
    stringsAsFactors = FALSE)
head(x)
dim(x)


system.time(saveRDS(x, "test.RDS"))
system.time(write.fst(x, "test.fst"))
x2 <- read.fst("test.fst")
x3 <- readRDS("test.RDS")

require(sparklyr)
require(dplyr)
require(ggplot2)

#spark_install(version = "1.6.2")

#install.packages("nycflights13")
sc <- spark_connect(master = "local")

dim(nycflights13::flights)

flights_tbl <- copy_to(sc, nycflights13::flights, "flights")
src_tbls(sc)

flights_tbl %>% filter(dep_delay == 2)

flights_tbl %>% group_by(tailnum) %>% summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>% filter(count > 20, dist < 2000, !is.na(delay))

flights_tbl %>% group_by(tailnum) %>% summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>% filter(count > 20, dist < 2000, !is.na(delay)) %>% collect()

flights_tbl %>% group_by(tailnum) %>% summarise(count = n(), dist = mean(distance), delay = mean(arr_delay)) %>% filter(count > 20, dist < 2000, !is.na(delay)) %>% collect %>% ggplot(aes(dist, delay)) + geom_point(aes(size = count), alpha = 1/2) + geom_smooth() + scale_size_area(max_size = 2)

## mllib

iris_tbl <- copy_to(sc, iris, "iris", overwrite = TRUE)

kmeans_model <- iris_tbl %>% select(Petal_Width, Petal_Length) %>% ml_kmeans(centers = 3)

predicted <- sdf_predict(kmeans_model, iris_tbl) %>% collect
table(predicted$Species, predicted$prediction)


### This week in r-tips

require(ggplot2)
ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, col = Species)) + geom_point()

require(plotly)
ggplotly()

p <- ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, col = Species)) + geom_point()
ggplotly(p)

