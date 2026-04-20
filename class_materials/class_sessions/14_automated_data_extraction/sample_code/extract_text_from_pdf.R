
# library(magick) # if you have a jpeg, can convert jpeg to pdf with this
# library(pdftools) # extract text from pdf

library(tesseract) #do all in one
library(tidyverse)
tesseract_info() # what languages do you have installed?

# You can find the code for the language you need here: 
# https://tesseract-ocr.github.io/tessdoc/Data-Files-in-different-versions.html
tesseract_download("por") # install portuguese
tesseract_download("rus") # install russian
# Point to the file from which you want to extract text
path<-"class_materials/class_sessions/14_automated_data_extraction/sample_code/text_extract_from_pdf_with_r/IMG_0074.JPG"
# extract
text <- tesseract::ocr(path, engine = "por")
text<-as.data.frame(text)


# YOU CAN ALSO TRANSLATE THE TEXT
# install.packages("polyglotr")
library(polyglotr)
# What languages are supported?
langs<-google_get_supported_languages()
# pick the code you need
# ru = russian

# Translate using Google Translate
hindi <- text %>% mutate(
  english_translation=google_translate(text, target_language = "en", source_language = "ru")
) 


# NOW YOU CAN DO TEXT ANALYSIS ON ORIGINAL OR TRANSLATED TEXT
# YOU CAN ALSO SEARCH FOR SPECIFIC WORDS with str_detect()