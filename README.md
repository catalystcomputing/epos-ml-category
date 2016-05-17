# Data Science Worked Example

As part of a Data Science course for IoT.

## Problem hypothesis

Although data science can use very complex Mathematical formula to achieve results. A non-mathematically trained IT professional can be given enough background to use existing libraries to solve data science problems.

## Sample problem

An EPOS (Electronic Point Of Sale) company operate a SaaS (Software as a service) model that includes price file/product file updates and maintenance for independent shops in the convenience sector.

One of the features of the system is that if a product is not recognised by the system it can be quickly added and sold as part of a transaction. This information is then processed centrally so other customers don't have the same issue. This processing is currently manual. The manual process has three purposes, to set the following pieces of information of the new product:

- VAT rating 
- Categorisation into a predefined categorisation scheme
- Tidy up the product description

The goal of this project to automatically categorise the products. To limit the scope of the exercise the leisure magazine group of products have been selected because the categorisation hierarchy is already in the public domain.

Below are descriptions of the data files.

## Possible approach 

There are three pieces of information in the `AllInputData.dat` file. Barcode, description and UnitRRP, see below for details on these terms. There are multiple entries for a given barcode. These multiple entries will have the same barcode, different text in the description and possibly different prices. (In the case of magazines the price should not vary but it will for other products.) The different text will be because of typing errors and differing abbreviations.

Some background on barcodes. In this sample all barcode are all 13 digits, the last one being a check digit. As barcodes are sold to product distributors in blocks it is likely a barcode with the first part of the barcode the same as another would be from the same product distributors and therefore has a higher chance of being in the group of categories that product distributors currently services. 

The approach I have thought about is this.

- Correct the spelling of the descriptions using something like [this](http://norvig.com/spell-correct.html 'How to Write a Spelling Corrector'). Priming the spell checker with only the words in the combination of the leisure and non leisure magazine data.
- Segment the barcodes in the training data to see if there are category patterns when partial barcodes are compared

With these results have features of

- product description
- product price, my expectation is that products are likely to be of a similar on a given category 
- barcode segment, possibly a few different sizes of segments

If there are multiple entries for a given barcode the larger number of them that are categorised into the same category should increase the confidence value.

The solution needs to give a confidence value of the recommendations. If they are not high a fall back to manual would be required.


## Data

The data files associated with this project are my first attempt at gathering data for such a project. As such I am not sure I have the right balance between the sample input data and the manual results. 

### Terms used for columns in the data

- Barcode: https://en.wikipedia.org/wiki/Barcode
- Description: product description
- UnitRRP: Products recommended retail price/selling price
- Category: Human readable product categorisation
- CategoryID: Surrogate key for Category https://en.wikipedia.org/wiki/Surrogate_key
- CategoryFullNodeList: Human readable Category hierarchy
- ParentCategoryID: CategoryID of Category above in the hierarchy
- TreeLeft: Internal id used to improve SQL requiring sections of the hierarchy 
- TreeRight: ditto 
- AncestorLevel: Depth / Level of an entry in the hierarchy

### Magazine Categories - part of a much larger product hierarchy categorisation 

- LeisureCategories.dat

### Training data

4734 rows of data split between the various leisure categories and the unclassified category.

- TrainingData.dat

### Test data

- TestData.dat - 2142 rows of categorised data with duplicate rows that have variations in the text description
- TestDataNoDups.dat - 1305 rows of categorised data with no duplicate rows the text description has been picked at random

