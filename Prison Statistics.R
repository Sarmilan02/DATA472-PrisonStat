library(tidyverse)
library(readxl)

dataframe <- read_excel("Quarterly_Prison_Statistics_-_March_2024.xlsx")

# Identify the date columns
date_columns <- colnames(dataframe)[3:27] # Assuming date columns start from column 3 to column 27

# Convert numeric values representing dates into actual date objects for column names only
new_column_names <- format(as.Date(as.numeric(date_columns), origin = "1899-12-30"), "%Y-%m-%d") # Format date as "YYYY-MM-DD"
colnames(dataframe)[3:27] <- new_column_names

# Select the total prisioner count information
total_prisoner <- dataframe[2:8, ]

# Transpose the selected table
total_prisoner <- t(total_prisoner)
total_prisoner <- total_prisoner[-1,]
# Select the total male prisioner count information
total_male_prisoner <- dataframe[11:17, ]

# Transpose the selected table
total_male_prisoner <- t(total_male_prisoner)
total_male_prisoner <- total_male_prisoner[-1,]







create_male_tables <- function(dataframe) {
  start_row <- 18
  end_row <- 137
  all_tables <- list()  # Initialize an empty list to store tables
  
  for (i in seq(start_row, end_row, by = 8)) {
    end_table_row <- min(i + 7, end_row)
    table_data <- dataframe[i:end_table_row, ]
    if (nrow(table_data) >= 2) {
    }
    table_name <- as.character(table_data[2, 1])  # Get the table name from column 1, row 2
    assign(table_name, table_data[-1, ], envir = .GlobalEnv)  # Assign the table to a variable with the table name
    all_tables[[table_name]] <- table_data[-1, ]  # Store the table data in the list
  }
  
  return(all_tables)
}

# Call the function with your dataframe
all_tables <- create_male_tables(dataframe)

# Combine all tables into a single dataframe 
combined_dataframe <- do.call(rbind, all_tables)

# Save each table as a separate dataframe
for (table_name in names(all_tables)) {
  assign(paste0(table_name, "_df"), all_tables[[table_name]], envir = .GlobalEnv)
}

rownames(combined_dataframe) <- NULL


create_female_tables <- function(dataframe) {
  start_row <- 139
  end_row <- 170
  all_tables <- list()  # Initialize an empty list to store tables
  
  for (i in seq(start_row, end_row, by = 8)) {
    end_table_row <- min(i + 7, end_row)
    table_data <- dataframe[i:end_table_row, ]
    if (nrow(table_data) >= 2) {
    }
    table_name <- as.character(table_data[2, 1])  # Get the table name from column 1, row 2
    assign(table_name, table_data[-1, ], envir = .GlobalEnv)  # Assign the table to a variable with the table name
    all_tables[[table_name]] <- table_data[-1, ]  # Store the table data in the list
  }
  
  return(all_tables)
}

# Call the function with your dataframe
all_tables <- create_female_tables(dataframe)

# Combine all tables into a single dataframe 
combined_female_dataframe <- do.call(rbind, all_tables)

# Save each table as a separate dataframe
for (table_name in names(all_tables)) {
  assign(paste0(table_name, "_df"), all_tables[[table_name]], envir = .GlobalEnv)
}

rownames(combined_female_dataframe) <- NULL


colnames(combined_dataframe)[1] <- "Prison Location"
colnames(combined_dataframe)[2] <- "Case Type"
colnames(combined_female_dataframe)[1] <- "Location"
colnames(combined_female_dataframe)[2] <- "Case Type"



new_combined_df <- t(combined_dataframe)
view(new_combined_df)
