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

# Some datasets only have p_bolt_lmm and not p_bolt_lmm_inf

fp <- file.path(datadir, "ready", dat$filename)

pvalcol <- sapply(fp, function(i)
{
	s <- scan(i, nlines=1, what=character())
	ifelse("P_BOLT_LMM" %in% s, 15, 13)
})

dat$pval_col <- pvalcol

write.csv(dat, file="input.csv")
write.csv(dat, file=file.path(datadir, "ready", "input.csv"))
