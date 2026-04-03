
library(tidyverse) # https://www.tidyverse.org/packages/
library(readxl)
library(here)
library(janitor) # https://cran.r-project.org/web/packages/janitor/vignettes/janitor.html
# library(textclean) # lots of cleanup functions for text data



# encoding: "cp1251"
# Windows-1251 is an 8-bit character encoding, designed to cover languages that use the Cyrillic script such as Russian, Ukrainian, Belarusian, Bulgarian, Serbian Cyrillic, Macedonian and other languages.
# https://en.wikipedia.org/wiki/Windows-1251




# read excel files --------------------------------------------------------

path_tiger <- "class_materials/student_help/Rus tiger News_sample.xlsx"

guess_encoding(path_tiger)

# gives the namnes of the sheets in the excel file
sheet_names <- path_tiger %>%
  excel_sheets()

# reads in excel, cleans up
tigers <- read_excel(path=path_tiger,
                   sheet = sheet_names) %>% 
  remove_empty(which = c("rows", "cols")) %>%
  rename(news=News,
         news_date=`News Date`,
         file_name=`File name`,
         source=Source) 


# saves
write_csv(tigers,"./class_materials/student_help/tigers_export.csv")



# translate ---------------------------------------------------------------


# install.packages("polyglotr")
library(polyglotr)

# What languages are supported?
langs<-google_get_supported_languages()
# ru = russian

# Translate using Google Translate
tigers <- tigers %>% mutate(
  news_en=google_translate(news, target_language = "en", source_language = "ru")
  ) %>% 
  relocate(news_en,.after=1) %>% 
  relocate(,.after=1)


# removing emoji unicode from english -------------------------------------

# https://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files

# Trying to remove  emoji from english column (which are now in unicode)  

## iconv is good way to do it, but not sure why not working
# Encoding(tigers$news_en) <- "UTF-8"  # (just to make sure)
# tigers$news_en_noemoji<-iconv(tigers$news_en, from = "utf8", to = "latin2")

# Could also do this but below is better
# replace_non_ascii(tigers$news_en)

tigers$news_en<-gsub("ð","", tigers$news_en) # and then
# tigers$news_en<-gsub("[^\u0001-\u007F]+|<U\\+\\w+>","", tigers$news_en) 
# but note this can connect two words that are separated only by an emoji so better might be:
tigers$news_en<-gsub("[^\u0001-\u007F]+|<U\\+\\w+>"," ", tigers$news_en) # and then
tigers$news_en<-trimws(tigers$news_en)

  write_csv(tigers,"./class_materials/student_help/tigers_export_translation.csv")
  