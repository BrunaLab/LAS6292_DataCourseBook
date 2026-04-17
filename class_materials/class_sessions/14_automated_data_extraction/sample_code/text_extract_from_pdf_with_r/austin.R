# pdf of labels to text
# library(magick) #convert jpeg to pdf
# library(pdftools) # extract text from pdf

# # read the jpeg
# label_1 <- image_read("./IMG_0074.JPG")
# image_info(label_1)
# # convert to pdf
# label_1_pdf <- image_convert(label_1, "pdf")
# image_info(label_1_pdf)
# # save it to the folder
# image_write(label_1_pdf, "./label_1.pdf")
# # # pdf_file <- "./test.pdf"
# pdf_file <- "./IMG_0074_export.pdf"
# txt <- pdf_text(pdf_file)
# cat(txt[1])
# 
library(tesseract) #do all in one
library(tidyverse)
tesseract_info() # what languages do you have installed?
tesseract_download("por") # install portuguese
path<-"class_materials/class_sessions/14_automated_data_extraction/sample_code/text_extract_from_pdf_with_r/IMG_0074.JPG"
text <- tesseract::ocr(path, engine = "por")
cat(text)
# you can see requires some cleanup 

# (note the \n and \a etc indicate line breaks, etc) but not much
# and can be done via coding)


# files <- list.files(path = "./austin", pattern = "*.JPG", full.names = T)
# austin <- sapply(files, tesseract::ocr, simplify=FALSE) %>% 
#   bind_rows(.id = "id")
# austin <- pivot_longer(austin,cols = starts_with("./austin"),names_to="file")


