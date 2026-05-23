# -------------------------------
# Subtractive Proteomics Pipeline
# -------------------------------

# Load libraries
library(dplyr)
library(readr)

# Step 1: Load datasets
proteome <- read_csv("data/proteome.csv")
blast <- read_csv("data/blast_results.csv")
essential <- read_csv("data/essential_genes.csv")

# Step 2: Filter proteins by length (>100 aa)
filtered <- proteome %>%
  filter(Length > 100)

# Step 3: Remove human homolog proteins
non_homolog <- filtered %>%
  filter(!(Protein_ID %in% blast$Human_Homolog_ID))

# Step 4: Remove unknown function proteins
classified <- non_homolog %>%
  filter(Function != "Unknown" & !is.na(Function))

# Step 5: Select essential proteins
drug_targets <- classified %>%
  filter(Protein_ID %in% essential$Protein_ID)

# Step 6: Save final output
write_csv(drug_targets, "results/final_drug_targets.csv")

# Step 7: Print summary
cat("Total proteins:", nrow(proteome), "\n")
cat("After filtering:", nrow(filtered), "\n")
cat("Non-homolog proteins:", nrow(non_homolog), "\n")
cat("Candidate proteins:", nrow(classified), "\n")
cat("Final drug targets:", nrow(drug_targets), "\n")