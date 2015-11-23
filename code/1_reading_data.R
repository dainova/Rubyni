## This file is intended for reading JSON data and saving 
## in .RData format. 


##----- load packs and styles
source("code/0_start.R")

##--download and unzip data-------------------------------------------
#download.file('https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/yelp_dataset_challenge_academic_dataset.zip', destfile=paste0(getwd(),'/yelp.zip'))
# unzip(paste0(getwd(),'/yelp.zip'))
#file.remove(paste0(getwd(),'/yelp.zip'))

##--convert data into R format----------------------------------------
# First time only  (time-consuming operation)

fnames <- c('business', 'checkin', 'tip', 'user', 'review')

l_ply(fnames, function(fname) {
  gc()
  full_path <- str_c("yelp_dataset_challenge_academic_dataset/yelp_academic_dataset_", fname, ".json")
  dat <- stream_in(file(full_path), pagesize = 35000)
  saveRDS(dat, str_c("data/", fname, ".RData"))
})

# Saves shortened version of 'review' (text replaced by text length)
review_short <- review %>% select(-text)
review_short$text_length <- str_length(review$text)
saveRDS(review_short, "data/review_short.RData")
