#### Setting AWS Credentials

### Put in your AWS Credentials to access the S3 bucket.

Sys.setenv(
  "AWS_ACCESS_KEY_ID" = "",
  "AWS_SECRET_ACCESS_KEY" = "",
  "AWS_DEFAULT_REGION" = ""
)

#### Build an index of files

### This assumes there is no directory hierarchy but you can modify it as per your need.

getFilenames <- function(bucket) {
  filenames <- NULL
  bucket.list <- get_bucket(bucket)
  for (file in bucket.list) {
    filenames <- c(filenames, file$Key)
  }
  names(filenames) <- "Filename"
  return(filenames)
}

#### Parse JSON

jsonToDataframe <- function(s3URL) {
  json.string <-
    rawToChar(aws.s3::get_object(s3URL, url_style = "virtual"))
  isvalid <-
    sapply(json.string, jsonlite::validate, USE.NAMES = FALSE)
  if (isvalid) {
    return(fromJSON(json.string))
  }
  else {
    print("Invalid JSON. Please check returned object to debug.")
    return(json.string)
  }
}

#### Parse CSV files

csvToDataframe <- function(s3URL) {
  return(aws.s3::s3read_using(read.csv, object = s3URL))
}

#### Cleanup ZIP files

cleanupZip <- function(f) {
  file.title <- tools::file_path_sans_ext(f)
  zip.name <- paste(file.title, ".zip", sep = "")
  file.name <- paste(file.title, ".csv", sep = "")
  file.remove(c(zip.name, file.name))
}

#### Unzip and Read ZIP files with CSV inside them

zipToCSV <- function(s3URL, filename) {
  aws.s3::save_object(s3URL, file = filename, url_style = "virtual")
  directory <- getwd()
  zip.path <- paste(directory, "//", filename, sep = "")
  unzip(zip.path)
  filename <- tools::file_path_sans_ext(filename)
  filename <- paste(filename, ".csv", sep = "")
  csv.file <- filename
  data <- read.csv(csv.file)
  cleanupZip(filename)
  return(data)
}

#### Unzip and Read ZIP files with JSON inside them.
### This is essentially the same function but only changes the extension used later.

zipToJSON <- function(s3URL, filename) {
  aws.s3::save_object(s3URL, file = filename, url_style = "virtual")
  directory <- getwd()
  zip.path <- paste(directory, "//", filename, sep = "")
  unzip(zip.path)
  filename <- tools::file_path_sans_ext(filename)
  filename <- paste(filename, ".json", sep = "")
  csv.file <- filename
  data <- read.csv(csv.file)
  cleanupZip(filename)
  return(data)
}

#### Get data in a dataframe

getFileData <- function(filename, format, bucket) {
  url <- paste("s3://", bucket, "/", filename, sep = "")
  if (identical(tolower(format), "json")) {
    data <- jsonToDataframe(url)
    return(data)
  }
  else if (identical(tolower(format), "csv")) {
    data <- csvToDataframe(url)
      }))
    return(data)
  }
  else if (identical(tolower(format), "zip")) {
    data <- zipToCSV(url, filename)
    #Use this if .zip has JSON data
    #data <- zipToJSON(url, filename) 
      }))
    return(data)
  }

  #### XML support to be added soon.
}
