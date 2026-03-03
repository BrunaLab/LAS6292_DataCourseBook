# load the libraries ------------------------------------------------------

library(tidyverse)

# We will use the data in the PalmerPenguins library
library(palmerpenguins)

# assign the data to a datafframe named `las`

las <- penguins

# Basic Summary of the columns in the df

# Base-R
summary(las)


# need to convert species to a factor if they aren't already
# Base-R
# las$species <- as.factor(las$species)
# # Tidyverse
# las <- las %>% mutate(species = as.factor(species))

# Summarize again...can you spot the diffference?
summary(las)

# can summarize individual columns
summary(las$flipper_length_mm)

# can have it provide only the mean
mean(las$flipper_length_mm)
mean(las$flipper_length_mm,na.rm=TRUE)

# ...or median...
median(las$flipper_length_mm,na.rm=TRUE)

# summary of factor gives the sample size of each
summary(las$species)


                    

# That said, the tidy version of getting summaries is really useful and flexible
# It is easier for more complex combinations, so we will use that most of the time
# if we are looking at multiple variables

# "with your dataframe, then summarize the mean of column flipper_len"

las %>%
  summarize(mean = mean(flipper_length_mm,
                        na.rm=TRUE))
# it still works, but has a horrible long default name...so get in the habita of naming

# To clean it up, give the column with the calclulation of mean a new name
# Note: "mean=" is giving this new column the name "mean". you can call it whatever you want.


# Can summarize multiple variables at the same time

las %>% summarise(
  mean_fl=mean(flipper_length_mm, na.rm=TRUE),
  sd_fl=sd(flipper_length_mm, na.rm=TRUE),
  median_fl=median(flipper_length_mm, na.rm=TRUE)
)
  
# but all of these are overall, meaning all species pooled together. 

# to compare the groups by species, use the `group_by` command


las %>% 
  group_by(species) %>% 
  summarise(
    mean_fl=mean(flipper_length_mm, na.rm=TRUE),
    sd_fl=sd(flipper_length_mm, na.rm=TRUE),
    median_fl=median(flipper_length_mm, na.rm=TRUE)        
            )
  
# don't forget to assign these to a dataframe if you want to use them or save the results as a csv

las_avg<-
las %>% 
  group_by(species) %>% 
  summarise(
    mean_fl=mean(flipper_length_mm, na.rm=TRUE),
    sd_fl=sd(flipper_length_mm, na.rm=TRUE),
    median_fl=median(flipper_length_mm, na.rm=TRUE)        
  )

write_csv(las_avg,"las_avg.csv"). 
# where will this save the file? 
# how do you get it to save somewhere else?







# you can assign the value to a new variable
mean_sl <- las %>% summarize(mean = mean(flipper_length_mm,
                                         na.rm=TRUE))
mean_sl

# you can do an operation on multiple columns in the same command.
# For ex, here we are getting the mean of both flipper_len and bill_len
mean_lengths <- las %>%
  summarize(
    mean_sl = mean(flipper_length_mm,
                   na.rm=TRUE),
    mean_pl = mean(body_mass_g,
                   na.rm=TRUE)
  )
mean_lengths

# But recall, there were different species. All the previous measurements
# were pooling the values for the different species to get the average.
# How do you get the mean for each individual species?

# To get the mean for a group, use the group_by command
mean_sl <- las %>%
  group_by(species) %>%
  summarize(mean_sl = mean(flipper_length_mm,na.rm=TRUE))
mean_sl

# incredibly valuable, because this is the start of a table...
# for instance, you can get the mean, sd, and range
mean_sl <- las %>%
  group_by(species) %>%
  summarize(
    mean_fl = mean(flipper_length_mm,na.rm=TRUE),
    sd_fl = sd(flipper_length_mm,na.rm=TRUE),
    min_fl = min(flipper_length_mm,na.rm=TRUE),
    max_fl = max(flipper_length_mm,na.rm=TRUE)
  )
mean_sl
# huh? it adds a row to each group with the min and max.
# this isn't very tidy, is there a better way to do this?

# yes! get the min and the max for each column (range is the diff of these 2)


# ALWAYS PLOT THE DATA 

# you can make a hiostogram of flipper length with base-R very quickly  
hist(las$flipper_length_mm)

hist(las$body_mass_g)

# Box plots in base r
boxplot(las$flipper_length_mm)
boxplot(las$bill_length_mm)

# ALL OF THIS IS GREAT, BUT SUMMARY GRAPHS CAN OBSCURE PATTERNS TOO
# ALWAYS PLOT THE RAW DATA
# with correlated data, can do this really well
# VIEW X on Y, and THAT IS INCREDIBLY USEFUL

# scatterpolot in base r:  plot(x,y)
plot(las$body_mass_g, las$flipper_length_mm)


# BUT WE HAVE BEEN LOOKING THE WHOLE TIME WITH ALL species TOGETHER. LETS
# LOOK AT THE PATTERN FOR ALL species SEPERATELY.

# This is much easier to do in ggplot2 (tidyverse)-

# Here is how to do histograms in ggplot2
# https://r-graph-gallery.com/220-basic-ggplot2-histogram.html




plot <- ggplot(
  las,
  aes(x = bill_length_mm)
) +
  geom_histogram(fill="blue",
                 color="black",
                 binwidth = 1)+
  theme_classic()+
  scale_y_continuous(breaks = seq(0, 60, 5))
plot







# easy to customize. Change the background with different "theme"
plot <- ggplot(
  las,
  aes(x = bill_length_mm)
) +
  geom_histogram() +
  theme_classic()
plot

# can change colors
plot <- ggplot(
  las,
  aes(x = bill_length_mm)
) +
  geom_histogram(
    binwidth = 0.5,
    fill = "red",
    color = "black"
  ) +
  theme_classic()
plot


# different plot for different groups
plot <- ggplot(
  las,
  aes(
    x = bill_length_mm,
    fill = species
  )
) +
  geom_histogram() +
  theme_classic()
plot

# BOOM. Finally see why that weird value set at end


# or give them each their own panel
plot <- ggplot(
  las,
  aes(
    x = bill_length_mm,
    fill = species,
  )
) +
  geom_histogram(binwidth = 0.5,color = "black") +
  facet_grid(rows = vars(species)) +
  theme_classic()
plot




# box plots in tidy
# https://r-graph-gallery.com/boxplot.html

las %>%
  ggplot(
    aes(x = species, y = flipper_length_mm, fill = species)
  ) +
  geom_boxplot() +
  theme_bw()


las %>%
  ggplot(aes(x = species, y = flipper_length_mm, fill = species)) +
  geom_boxplot() +
  geom_jitter(color = "black", size = 0.4, alpha = 0.9) +
  theme_bw()


# scatter plots (x,y) in ggplot2
# can also look at the x y values
las %>%
  ggplot(
    aes(x = body_mass_g, y = flipper_length_mm)
  ) +
  geom_point() +
  theme_bw()

# different color points for each species

las %>%
  ggplot(
    aes(x = body_mass_g, y = flipper_length_mm, color = species)
  ) +
  geom_point() +
  theme_bw()

# if you want to remove the "error", uncomment the code below and run it.
# las<-las %>%
#   filter(flipper_length_mm<12)
# you have filtered the data to ONLY allow values of flipper_len less than 12





# ggplot with all the details ---------------------------------------------


#  scatter plot -----------------------------------------------------------


# MAPPING
scatter <- ggplot(data = las, 
                  mapping = aes(x=body_mass_g, y=flipper_length_mm))

scatter

# GEOM
scatter <- scatter + geom_point(color="black", # the stroke color, the circle outline
                                fill="black", #color of the circle inner part
                                shape=20 # shape of the marker
                                # alpha=1, # circle transparency, [0->1], 0 is fully transparent
                                # size=0, # circle size
                                # stroke = 1 # the stroke width
)
scatter

# if you want to add a regression line

scatter <- scatter + 
  # stat_smooth(method = "lm",
  stat_smooth(method = "loess",
              formula = y ~ x,
              geom = "smooth",
              color="red", 
              linetype="dashed", 
              size=1.5)
scatter
# Coordinates and Scales

scatter<-scatter+
  scale_y_continuous(breaks=seq(0,250,5))
scatter
# LABELS AND GUIDES 

scatter <- scatter+
  labs(x="body mass (g)",
       y="flipper length (mm)",
       title="Penguin Body Size relations")

scatter

scatter<-scatter+
  theme_classic()+
  theme(plot.title = element_text(face="bold", size=20,family = "Arial", colour = "black"),  
        # Sets title size, style, location
        # legend.position=c(0.5,0.95),
        axis.line.y = element_line(color="black", size = 0.5, lineend="square"),
        axis.line.x = element_line(color="black", size = 0.5, lineend="square"),
        axis.title.x=element_text(colour="black", size = 20, vjust=-0.5),           #S ets x axis title size, style, distance from axis #add , face = "bold" if you want bold
        axis.title.y=element_text(colour="black", size = 20, vjust=1.5),            #S ets y axis title size, style, distance from axis #add , face = "bold" if you want bold
        axis.text.x=element_text(colour="black", size = 16, angle = 45, vjust =0, hjust=0),                          # Sets size and style of labels on axes
        axis.text.y=element_text(colour="black", size = 16, angle = 0, vjust =0, hjust=0),                          # Sets size and style of labels on axes
        # legend.title = element_blank(),                                             # Removes the Legend title
        # legend.key = element_blank(),                                              #R emoves the boxes around legend colors
        # legend.text = element_text(face="italic", color="black", size=12),
        # legend.position = "top",
        # legend.direction = 'horizontal', 
        # legend.key = element_rect(colour = "black"),                              #s ets size and style of labels on axes
        # plot.margin = unit(c(1,2,1,1), "cm")
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white")
  )    


scatter

# Histogram

# MAPPING
barplot <- ggplot(data = las %>% filter(species=="Adelie"), 
                  mapping = aes(x=body_mass_g))

barplot
# GEOM
barplot <- barplot + geom_bar(
  # stat = "identity", # use this when your df is a summary of the values for each category
   
                              width=30,      # width of the bars
                              color="black", # outline of the bars
                              fill="darkgray") # color of the bars
barplot
# Coordinates and Scales

barplot<-barplot+
  scale_x_continuous(breaks=seq(0,70,5))
barplot
# LABELS AND GUIDES 

barplot <- barplot+
  labs(x="Body Mass",
       y="Count",
       title="Penguin Body Mass (g)")

barplot

# This is the basics but still kinda ugly, so lets choose a "theme"
# https://ggplot2.tidyverse.org/reference/ggtheme.html
# I like theme classic

barplot<-barplot+
  theme_classic()+
  theme(plot.title = element_text(face="bold", size=20,family = "Arial", colour = "black"),  
        # Sets title size, style, location
        # legend.position=c(0.5,0.95),
        axis.line.y = element_line(color="black", size = 0.5, lineend="square"),
        axis.line.x = element_line(color="black", size = 0.5, lineend="square"),
        axis.title.x=element_text(colour="black", size = 20, vjust=-0.5),           #S ets x axis title size, style, distance from axis #add , face = "bold" if you want bold
        axis.title.y=element_text(colour="blue", size = 20, vjust=1.5),            #S ets y axis title size, style, distance from axis #add , face = "bold" if you want bold
        axis.text.x=element_text(colour="black", size = 16, angle = 45, vjust =0, hjust=0),                          # Sets size and style of labels on axes
        axis.text.y=element_text(colour="black", size = 16, angle = 0, vjust =0, hjust=0),                          # Sets size and style of labels on axes
        # legend.title = element_blank(),                                             # Removes the Legend title
        # legend.key = element_blank(),                                              #R emoves the boxes around legend colors
        # legend.text = element_text(face="italic", color="black", size=12),
        # legend.position = "top",
        # legend.direction = 'horizontal', 
        # legend.key = element_rect(colour = "black"),                              #s ets size and style of labels on axes
        # plot.margin = unit(c(1,2,1,1), "cm")
        plot.background = element_rect(fill = "white"),
        panel.background = element_rect(fill = "white")
  )    

barplot











