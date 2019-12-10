#############

#An example of Text Mining a Corpus of Documents

#taken from: http://www.r-bloggers.com/text-mining-the-complete-works-of-william-shakespeare/
  
#############

# TEXTFILE = "data/pg100.txt"
# if (!file.exists(TEXTFILE)) {
#   download.file("http://www.gutenberg.org/cache/epub/100/pg100.txt", destfile = TEXTFILE)
# }

TEXTFILE <- "Documents/Work_ERI/Remote_2015/DOL_2015/shakespearepg100.txt"
shakespeare = readLines(TEXTFILE)
length(shakespeare)

head(shakespeare)
tail(shakespeare)

#get rid of header and footer text
shakespeare = shakespeare[-(1:173)]
shakespeare = shakespeare[-(124195:length(shakespeare))]

shakespeare = paste(shakespeare, collapse = " ")
nchar(shakespeare)

#divide long string into separate documents
shakespeare = strsplit(shakespeare, "<<[^>]*>>")[[1]]
length(shakespeare)   #turns out to be 218 plays

#mremove the dramatis personae for the plays
(dramatis.personae <- grep("Dramatis Personae", shakespeare, ignore.case = TRUE))
length(shakespeare)
shakespeare <- shakespeare[-dramatis.personae]
length(shakespeare)   #down to 182 documents

#####
#Convert documents into a corpus
install.packages('tm')
library(tm)

doc.vec <- VectorSource(shakespeare)
doc.corpus <- Corpus(doc.vec)
summary(doc.corpus)

#clean up items (convert to lowercase, remove punctuation, numbers and common English stopwords)
# doc.corpus <- tm_map(doc.corpus, tolower)
# corpus <- tm_map(corpus, PlainTextDocument)
doc.corpus <- tm_map(doc.corpus, content_transformer(tolower))
doc.corpus <- tm_map(doc.corpus, removePunctuation)
doc.corpus <- tm_map(doc.corpus, removeNumbers)
doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))

#perform stemming (removes affixes from words)
install.packages('SnowballC')
library(SnowballC)

doc.corpus <- tm_map(doc.corpus, stemDocument)

#remove whitespace
doc.corpus <- tm_map(doc.corpus, stripWhitespace)

#inspect
inspect(doc.corpus[8])

##################
## Create a Term Document Matrix

TDM <- TermDocumentMatrix(doc.corpus)
TDM
inspect(TDM[1:10,1:10])

DTM <- DocumentTermMatrix(doc.corpus)
DTM
inspect(DTM[1:10,1:10])

###################

# what are the most frequently occuring terms?
findFreqTerms(TDM, 2000)

findAssocs(TDM, "love", 0.8)

