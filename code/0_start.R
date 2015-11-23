##----- load packs
library(jsonlite)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)
library(grid)
library(RColorBrewer)
library(caret)


## Theme for plots
theme_custom <- function() {theme_bw(base_size = 8) + 
    theme(panel.background = element_rect(fill="#eaeaea"),
          plot.background = element_rect(fill="white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color="#dddddd"),
          axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.x = element_text(vjust=-0.3),
          axis.title.y = element_text(vjust=1.5),
          panel.border = element_rect(color="#cccccc"),
          text = element_text(color = "#1a1a1a"),
          plot.margin = unit(c(0.25,0.1,0.30,0.35), "cm"),
          plot.title = element_text(vjust=1))                          
}
## Colors for ranking by 'stars' (Red to Green)
rank_colors <- c(brewer.pal(9,"Reds")[c(9,7,5)], brewer.pal(9,"Greens")[c(7,8)])

## Theme for boxplot
theme1 <- trellis.par.get()
theme1$plot.symbol$col = rgb(.2, .2, .2, .4)
theme1$plot.symbol$pch = 16
theme1$plot.line$col = rgb(1, 0, 0, .7)
theme1$plot.line$lwd <- 2