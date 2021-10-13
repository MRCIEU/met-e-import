library(jsonlite)
library(dplyr)
library(ieugwasr)
library(glue)
library(readr)

datadir <- read_json("config.json")$datadir
dat <- read_csv("input_NMRagetertiles.csv") %>%
	select(-X1) %>%
	mutate(
		id = gsub("med-d", "met-e", id),
		note = gsub("agetert", "age tertile ", subcategory),
		subcategory = "NA",
		unit = "SD"
	)

stopifnot(all(file.exists(file.path(datadir, "ready", dat$filename))))

write.csv(dat, file="input.csv")
write.csv(dat, file=file.path(datadir, "ready", "input.csv"))
