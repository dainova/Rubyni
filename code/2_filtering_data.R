##----- load packs and styles
source("code/0_start.R")


## Typical data load (second time and further runs)

## Loads data
business <- readRDS("data/business.RData")
review_short <- readRDS("data/review_short.RData")
## Unused objects are commented
#review <- readRDS("data/review.RData")
#checkin <- readRDS("data/checkin.RData")
#tip <- readRDS("data/tip.RData")
#user <- readRDS("data/user.RData")


## Select relevant columns from BUSINESS table
business_short <- business %>%
  select(business_id, stars, review_count)

## Select relevant columns from REVIEW table, and
review_short <- review_short %>%
  select(business_id, stars, text_length, date)

## Convert 'date' into POSIXct class
review_short$date <- as.POSIXct(review_short$date, format="%Y-%m-%d")

## Save businessreview_data into a file
saveRDS(review_short, "data/review_short2.RData")


## Loads filtered data for reviews
review_short <- readRDS("data/review_short2.RData")
## Split review_short into individual groups by business_id and 
## summarise each group by counting the number of reviews and
## computing average text length and average stars
init_number <- 5  # number of reviews considered as initial period reviews

review_grouped <- review_short %>%
  group_by(business_id) %>%
  dplyr::summarise(
    r_count = n(),
    r_stars_avg = round(mean(stars, na.rm = TRUE), digits = 2),
    r_length_avg = round(mean(text_length, na.rm = TRUE)),
## average stars over the 1st period
    r_stars_1_avg = round(mean(stars[1:init_number]), digits = 2),
## coefficient of variation for stars over the 1st period 
## (initial number of reviews)
    r_stars_1_cv = round(
      sd(stars[1:init_number], na.rm = TRUE) / r_stars_1_avg,
      digits = 2),
## average review text length over the 1st period
    r_length_1_avg = round(mean(text_length[1:init_number])),
## average time interval between consequent reviews over the 1st period
    r_time_1_avg = as.numeric(round((date[init_number] - min(date)) / (init_number - 1))),
## differential between 1st period stars and overal stars
    r_stars_diff = r_stars_avg - r_stars_1_avg 
  ) 


## Join business_short and review_grouped together by business_id
business_data <- left_join(business_short, review_grouped, by = "business_id")    
#business_data <- left_join(business_data, tip_grouped, by = "business_id")    

## Save business_data into a file
saveRDS(business_data, "data/business_data.RData")


## Data used for modelling (2 classes)-----------------------------
workdata <- business_data %>%
  select(-stars, -review_count) %>%
## cut off businesses with number of rewiews less than 10
  filter(r_count >= 10) %>%
## Assigning category to a business according to the changes
## of its star rating: dec(reasing), equ(ivalent), inc(reasing)
  mutate(group = cut(r_stars_diff, c(-4,0, 4),labels=c("dec","inc")))

# Save working data into a file
saveRDS(workdata, "data/workdata.RData")
