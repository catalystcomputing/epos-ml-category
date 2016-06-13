creatdescdict <- function(eposdata){
  ## Function to Create dictionary list with all description available for
  ## each category.
  
  # Find unique category & coerce in to format needed.
  uc <- unique(eposdata$Category)
  uc <- paste(uc, collapse=",")
  uc <- str_split(uc , ",")
  uc <- unlist(uc)
  # Create empty list of length to unique category
  d <- vector("list",length(uc))
  names(d) <- uc
  for (i in 1:length(uc)){
    desc <- paste(subset.data.frame(eposdata, eposdata$Category == uc[i])$Description, collapse = ",")
    desc <- unique(unlist(str_split(desc,",")))
    d[[uc[i]]] <- desc
  }
  d
}

# Main Steps
# Read the data from training set
eposdata <- read.csv("F:/Raj/Futuretext/PythonScripts/epos-ml-category-master/data/TrainingData.dat",sep="\t")
# Convert description as Characters.
eposdata$Description = as.character(eposdata$Description)
# Remove last digit from barcode as its check bit
eposdata$Barcode1less = floor(eposdata$Barcode/10)
# Only select Barcode, Description and category. Dropped Unit Price.
eposdata <- eposdata[,c(2,4,7)]
library(quanteda)
# Create dictionary for the 38 unique categories.
descdict <- dictionary(creatdescdict(eposdata))
#Create feature vectors
desc_dfm <- dfm(eposdata$Description, stem = FALSE, igonoredFeatures = stopwords("english"), dictionary = descdict)
desc_vector<-as.data.frame(as.matrix(desc_dfm))
# Create dataset to train. Remove Description and add feature vectors
transdata <- cbind(eposdata, desc_vector)
transdata <- transdata[,-1]

#Split data in to train and test
library(caret)
set.seed(1976)
trainIndex <- createDataPartition(transdata$Category, p=0.7,list = FALSE)
traindata <- transdata[trainIndex,]
testdata <- transdata[-trainIndex,]

# http://topepo.github.io/caret/similarity.html
#[1] "Support Vector Machines with Radial Basis Function Kernel (svmRadial)"
# Training model takes time. Reload the trained model using load.
#modelsvmredial <- train(Category ~.,data=traindata, method = "svmRadial" )
#save(modelsvmredial, file = "modelsvm.RDATA")
load("modelsvm.RDATA")
# Predict the categories for test set.
predsvm <- predict(modelsvmredial, testdata[,-1])
resultsvm <- confusionMatrix(predsvm, testdata[,1])
print(resultsvm$overall)

# Random Forest Method
#modelrf <- train(Category ~.,data=traindata, method = "rf" )
#save(modelrf, file = "modelrf.RDATA")
load("modelrf.RDATA")
predrf <- predict(modelrf, testdata[,-1])
resultrf <- confusionMatrix(predrf, testdata[,1])
print(resultrf$overall)
