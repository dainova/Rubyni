#----- load packs and styles
source("code/0_start.R")

#----- create agregated data table
#source("code/2_filtering_data.R")


## Loads filtered agregated flat data for businesses
business_data <- readRDS("data/business_data.RData")

## Loads filtered data for reviews
review_short <- readRDS("data/review_short2.RData")

## Loads filtered agregated flat data for businesses
workdata <- readRDS("data/workdata.RData")

# Show inconsistency in the dataset: number of reviews is different 
# in business and review tables. 
x <- business_data %>%
  select(review_count, r_count) %>%
  mutate(diff = (review_count - r_count)) %>%
  arrange(diff)
ggplot(data = x, aes(x = diff)) +
  geom_histogram() +
  scale_x_continuous(limits = c(-5, 20)) +
  theme_custom() + 
  theme(panel.margin=element_blank()) +
  labs(title=paste("Difference in # of Reviews in BUSINESS and REVIEWS tables"), x="business$review_count - reviews$review_count", y="Count")

ggsave("images/difference_in_review_number.png", dpi = 300, height = 2, width = 5)
summary(x$diff)


### Number of Yelp Reviews by Month
review_monthly_stars <- review_short %>%
  group_by(date=substr(date,1,7), stars) %>%
  summarize(count=n())

# Time Series Stacked
ggplot(data=review_monthly_stars, aes(x=as.POSIXct(paste(date,"-01",sep="")), y=count, fill=as.factor(stars))) +
  geom_area(position = "stack") +
  scale_x_datetime(breaks = date_breaks("1 year"), labels = date_format("%Y")) +
  scale_y_continuous(label = comma) +
  theme_custom() + 
  theme(legend.title = element_blank(), legend.position="top", legend.direction="horizontal",
        legend.key.width=unit(0.25, "cm"), legend.key.height=unit(0.25, "cm"), legend.margin=unit(-0.5, "cm"),
        panel.margin=element_blank()) +
  labs(title=paste("# of Yelp Reviews by Month for", format(nrow(review_short),big.mark=","),"Reviews"), x="Date of Review Submission", y="Total # of Reviews (by Month)") +
  scale_fill_manual(values=rank_colors, labels = c("1 Star", "2 Stars", "3 Stars", "4 Stars", "5 Stars"))

ggsave("images/yelp_review_time_series.png", dpi=300, height=3, width=5)


### Number of Yelp Reviews by text_length and stars
ggplot(data=review_short, aes(x=text_length)) +
  geom_histogram(aes(fill=as.factor(stars)), position = "stack", binwidth=25) +
  scale_y_continuous(label = comma) +
  scale_x_continuous(limits = c(0, 3000), breaks = seq(0,3000,by = 200) )+
  theme_custom() + 
  theme(legend.title = element_blank(), legend.position="top", legend.direction="horizontal",
        legend.key.width=unit(0.25, "cm"), legend.key.height=unit(0.25, "cm"), legend.margin=unit(-0.5, "cm"),
        panel.margin=element_blank()) +
  labs(title=paste("# of Yelp Reviews by Text Length for", format(nrow(review_short),big.mark=","),"Reviews"), x="The Length of the Review Text", y="Total # of Reviews") +
  scale_fill_manual(values=rank_colors, labels = c("1 Star", "2 Stars", "3 Stars", "4 Stars", "5 Stars"))

ggsave("images/yelp_review_text_length.png", dpi=300, height=3, width=5)

### Proportion of Yelp Reviews by text_length and stars
ggplot(data=review_short, aes(x=text_length)) +
  geom_histogram(aes(fill=as.factor(stars)), position = "fill", binwidth=100) +
  scale_y_continuous(label = comma) +
  scale_x_continuous(limits = c(0, 5000), breaks = c(seq(0,1000,by = 250),seq(1500,5000,by = 500)) )+
  theme_custom() + 
  theme(legend.title = element_blank(), legend.position="top", legend.direction="horizontal",
        legend.key.width=unit(0.25, "cm"), legend.key.height=unit(0.25, "cm"), legend.margin=unit(-0.5, "cm"),
        panel.margin=element_blank()) +
  labs(title=paste("Proportion of Rating Stars by Text Length for", format(nrow(review_short),big.mark=","),"Reviews"), x="The Length of the Review Text") +
  scale_fill_manual(values=rank_colors, labels = c("1 Star", "2 Stars", "3 Stars", "4 Stars", "5 Stars"))

ggsave("images/yelp_review_text_length_stars.png", dpi=300, height=3, width=5)


### Histogram stars ~ number of reviews

# Count proportion of stars for reviews devided into 3 groups:
#   x1 - subset of reviews for businesses with r_count >=10
#   x2 - subset of reviews for businesses with r_count <10
#   x3 - subset of reviews for all businesses

x1 <- review_short %>%
  select(business_id, stars) %>%
  subset(business_id %in% 
           (business_data %>%
              select(business_id, r_count) %>%
              filter(r_count >=10) %>%
              unlist() %>%  unname()
           )
  ) %>%
  group_by(stars) %>%
  summarize(n = n()) %>%
  mutate(fraction = n/sum(n))%>%
  mutate(cat = 1)

x2 <- review_short %>%
  select(business_id, stars) %>%
  subset(business_id %in% 
           (business_data %>%
              select(business_id, r_count) %>%
              filter(r_count < 10) %>%
              unlist() %>%  unname()
           )
  ) %>%
  group_by(stars) %>%
  summarize(n = n()) %>%
  mutate(fraction = n/sum(n))%>%
  mutate(cat = 2) 

x3 <- review_short %>%
  #  slice(1:1000) %>%
  select(stars) %>%
  group_by(stars) %>%
  summarize(n = n()) %>%
  mutate(fraction = n/sum(n))%>%
  mutate(cat = 3)

ggplot(data=rbind(x1,x2,x3), aes(x=factor(stars), y=fraction, fill=factor(cat))) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_custom() + 
  theme(legend.title = element_blank(), legend.position="top", legend.direction="horizontal",
        legend.key.width=unit(0.25, "cm"), legend.key.height=unit(0.25, "cm"), legend.margin=unit(-0.5, "cm"),
        panel.margin=element_blank()) +
  labs(title="Distribution of Rating Stars within the Dataset", x="Rating Star") +
  scale_fill_manual(values = c("orange","darkgreen","blue"), labels = c("businesses with >= 10 reviews", "businesses with < 10 reviews", "All businesses"))

ggsave("images/yelp_review_stars_density.png", dpi=300, height=3, width=5)



## Histogram or plots of any_factor from workdata vs. group
## (examples of data exploring)

#ggplot(data = workdata, aes(x=r_time_1_avg)) +
#  geom_density(aes(fill = as.factor(group)), position="fill") +
#scale_x_continuous(limits = c(0, 500))

#ggplot(data = workdata, aes(y=r_time_1_avg,x=r_stars_avg)) +
#  geom_point(aes(color = as.factor(group)), alpha = 1/2)
