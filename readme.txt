Order of processing:
1. Run '1_reading_data.R ' once to convert JSON files and save into RData format. (time consuming)
2. Run '2_filtering_data.R' to clean the data and create working data in short format.
3. Run '3_exploring_data.R' to make plots and save the corresponding .png images.
4. Run '4_modelling.R' to train predictive models and to save corresponding performance parameters.
5. Knit 'YELP_report.Rmd' to create the report in pdf.
Note: an installation of relevant packages can be required during the first run of the above files.

Files structure:

/code/...                   ## code files
     /0_start.R             # loads packs and themes
     /1_reading_data.R      # reads JSON data and saves in .RData format in /data/ folder 
     /2_filtering_data.R    # filters and selects relevant data
     /3_exploring_data.R    # creates plots and histograms and saves in /images/ folder
     /4_modelling.R         # develops predictive models
/data/...                   ## empty at the beginning. To be filled with intermediate data after R-files executed
     /business.RData        # raw data converted from JSON files. Created by '1_reading_data.R'
     /checkin.RData         # --
     /review.RData          # --
     /review_short.RData    # --
     /tip.RData             # --
     /user.RData            # --
     /review_short2.RData   # filtered data on reviews. Created by '2_filtering_data.R'
     /business_data.RData   # aggregated data on businesses. Created by '2_filtering_data.R'
     /workdata.RData        # aggregated data to be used in modelling. Created by '2_filtering_data.R'
     /performance_table.RData # models performance comparison. Created by '2_filtering_data.R'
     /resamps.RData         # models performance comparison. Created by '2_filtering_data.R'
/docs/...                   ## docs provided by Yelp and tasks
/images/...                 ## empty at the beginning. To be filled with .png images by '3_exploring_data.R'
     /difference_in_review_number.png
     /yelp_review_stars_density.png
     /yelp_review_text_length.png
     /yelp_review_text_length_stars.png
     /yelp_review_time_series.png
/rmd/...                    ## R-markdown reports
     /YELP_report.Rmd       # YELP_report
     /YELP_report.html      # The final report. To be created from 'YELP_report.Rmd'
/yelp_dataset_challenge_academic_dataset/...   ## Initial downloaded YELP dataset
     /yelp_academic_dataset_business.json
     /yelp_academic_dataset_checkin.json
     /yelp_academic_dataset_review.json
     /yelp_academic_dataset_tip.json
     /yelp_academic_dataset_user.json
     /Dataset_Challenge_Academic_Dataset_Agreement.pdf
     /Yelp_Dataset_Challenge_Terms_round_5.pdf
	 
	 
	 
