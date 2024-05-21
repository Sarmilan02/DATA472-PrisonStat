library(readxl)
library(dplyr)

# Enter the excel path
excel_path <- "C:/Users/sarmi/OneDrive/Documents/Sem 2/Data Engineering/Individual project/Quarterly_Prison_Statistics_-_March_2024.xlsx"

sheet_names <- excel_sheets(excel_path)

# Create an empty list to store dataframes
list_of_dfs <- list()

# Read each sheet into a dataframe and store in the list
for (sheet in sheet_names) {
  list_of_dfs[[sheet]] <- read_excel(excel_path, sheet = sheet)
}

# Access dataframe from the first sheet
df1 <- list_of_dfs[[sheet_names[1]]]

# Access dataframe from a sheet named "Sheet1"
df_sheet1 <- list_of_dfs[["Sheet1"]]

Age <- list_of_dfs[[sheet_names[2]]]
df_sheet2 <- list_of_dfs[["Sheet2"]]

Ethnicity <- list_of_dfs[[sheet_names[3]]]
df_sheet3 <- list_of_dfs[["Sheet3"]]

Security_class <- list_of_dfs[[sheet_names[4]]]
df_sheet4 <- list_of_dfs[["Sheet4"]]

Offence_type <- list_of_dfs[[sheet_names[5]]]
df_sheet5 <- list_of_dfs[["Sheet5"]]


# Identify the date columns
date_columns <- colnames(df1)[3:27] # date columns start from column 3 to column 27
date_columns <- colnames(Age)[2:26]

# Convert numeric values representing dates into actual date objects for column names only
new_column_names <- format(as.Date(as.numeric(date_columns), origin = "1899-12-30"), "%Y-%m-%d") # Format date as "YYYY-MM-DD"
colnames(df1)[3:27] <- new_column_names
colnames(Age)[2:26] <- new_column_names
colnames(Ethnicity)[2:26] <- new_column_names
colnames(Security_class)[2:26] <- new_column_names
colnames(Offence_type)[2:26] <- new_column_names

# Select the total prisioner count information
total_prisoner <- df1[2:8, ]

# Transpose the selected table
total_prisoner <- t(total_prisoner)
total_prisoner <- total_prisoner[-1,]
# Select the total male prisioner count information
total_male_prisoner <- df1[11:17, ]

# Transpose the selected table
total_male_prisoner <- t(total_male_prisoner)
total_male_prisoner <- total_male_prisoner[-1,]


create_male_tables <- function(df1) {
  start_row <- 18
  end_row <- 137
  all_tables <- list()  # Initialize an empty list to store tables
  
  for (i in seq(start_row, end_row, by = 8)) {
    end_table_row <- min(i + 7, end_row)
    table_data <- df1[i:end_table_row, ]
    if (nrow(table_data) >= 2) {
      table_name <- as.character(table_data[2, 1])  # Get the table name from column 1, row 2
      assign(table_name, table_data[-1, ], envir = .GlobalEnv)  # Assign the table to a variable with the table name
      all_tables[[table_name]] <- table_data[-1, ]  # Store the table data in the list
    }
  }
  
  return(all_tables)
}

# Call the function with your dataframe
all_tables <- create_male_tables(df1)

# Combine all tables into a single dataframe 
combined_dataframe <- do.call(rbind, all_tables)

# Save each table as a separate dataframe
for (table_name in names(all_tables)) {
  assign(paste0(table_name, "_df"), all_tables[[table_name]], envir = .GlobalEnv)
}

rownames(combined_dataframe) <- NULL

# Rename the columns
colnames(combined_dataframe)[1:2] <- c("Prison Location", "Prison Type")


create_female_tables <- function(df1) {
  start_row <- 147
  end_row <- 170
  all_tables <- list()  # Initialize an empty list to store tables
  
  for (i in seq(start_row, end_row, by = 8)) {
    end_table_row <- min(i + 7, end_row)
    table_data <- df1[i:end_table_row, ]
    if (nrow(table_data) >= 2) {
      table_name <- as.character(table_data[2, 1])  # Get the table name from column 1, row 2
      assign(table_name, table_data[-1, ], envir = .GlobalEnv)  # Assign the table to a variable with the table name
      all_tables[[table_name]] <- table_data[-1, ]  # Store the table data in the list
    }
  }
  
  return(all_tables)
}

# Call the function with your dataframe
all_tables <- create_female_tables(df1)

# Combine all tables into a single dataframe 
combined_female_dataframe <- do.call(rbind, all_tables)

# Save each table as a separate dataframe
for (table_name in names(all_tables)) {
  assign(paste0(table_name, "_df"), all_tables[[table_name]], envir = .GlobalEnv)
}

rownames(combined_female_dataframe) <- NULL

# Rename the column names
colnames(combined_female_dataframe)[1:2] <- c("Prison Location", "Prison Type")

# Add the Gender column
combined_dataframe$Gender <- "Male"
combined_female_dataframe$Gender <- "Female"

# Combine the two dataframes
Population <- rbind(combined_dataframe, combined_female_dataframe)

# Uploading to PostgreSQL
library(RPostgres)
library(DBI)

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "prisonstatistics",
  host = "localhost",   
  port = 5432,         
  user = "sarmilan",
  password = "abc"
)


# List of dataframes to write to the database
all_dfs <- list(Population = Population, Age = Age, Ethnicity = Ethnicity, Offence_type = Offence_type, Security_class = Security_class)
tablenames <- names(all_dfs)  # Names of the tables

for(i in 1:5) {
  dbWriteTable(con, tablenames[i], all_dfs[[i]], overwrite = TRUE, row.names = FALSE)
}


