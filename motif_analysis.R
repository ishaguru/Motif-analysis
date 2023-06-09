#' title: "Motif_analysis"
#' output: html_document
#' date: "2023-04-01"

# Load the necessary libraries
library(MotifDb)
library(TFBSTools)
library(Biostrings)
library(readr)
library(ggplot2)
library(tidyr)
library(magrittr)
library(dplyr)
library(gplots)
library(ggseqlogo)

fimo_apidae <- read_tsv("/Users/isha/Desktop/lab/Results/apidae/Apidae_fimo.tsv", col_types = "ccccddddd")

fimo_apidae <- fimo_apidae[head(seq_len(nrow(fimo_apidae)), -3),] #removed last three rows
fimo_seqs <- DNAStringSet(fimo_apidae$matched_sequence) 
fimo_apidae$motif_alt_id <- ifelse(is.na(fimo_apidae$motif_alt_id), fimo_apidae$motif_id, fimo_apidae$motif_alt_id)
head(fimo_apidae)

#A matrix where each row represents a DNA sequence and each column represents a motif, with the value in each cell representing the number of occurrences of that motif in that sequence
apidae_matrix <- fimo_apidae %>%
  select(motif_alt_id, sequence_name) %>%
  group_by(motif_alt_id, sequence_name) %>%summarize(count = n()) %>%
  pivot_wider(names_from = motif_alt_id, values_from = count, values_fill = 0)
apidae_mat <- apidae_matrix[,-1]
row.names(apidae_mat) <- apidae_matrix$sequence_name

#Occurrence of each motif in each DNA sequence, allowing to easily identify patterns and relationships between motifs and sequences.
apidae_plot <- heatmap.2(as.matrix(apidae_mat), col = colorRampPalette(c("white", "red"))(100), 
          key = TRUE, keysize = 1.5, cexCol = 0.7, cexRow = 0.7, 
          trace = "none", margins = c(10,10), dendrogram = "both",main = "Apidae Motif analysis",xlab = "Motifs",ylab =           "Sequences")

#Top represented /Over-represented motifs
class(fimo_apidae)  # check class of fimo
str(fimo_apidae)  # check structure of fimo
motif_count <- aggregate(motif_alt_id ~ matched_sequence, data = fimo_apidae, FUN = length) #aggregate() function to count         the occurrences of each unique "motif_id" within each unique "matched_sequence" in the "fimo_apidae" dataset.
colnames(motif_count) <- c("matched_sequence_name", "motif_count")
motif_count <- motif_count[order(-motif_count$motif_count), ]
top_sequences <- head(motif_count$matched_sequence_name, n = 10)
top_fimo <- subset(fimo_apidae, fimo_apidae$matched_sequence %in% top_sequences)

#Checking no of motifs present in 60% of the sequences
num_sequences <- fimo_apidae %>% distinct(sequence_name) %>% nrow()
fimo_grouped <- fimo_apidae %>% group_by(motif_alt_id)
motif_counts <- fimo_grouped %>% distinct(sequence_name) %>% nrow()
common_motifs <- fimo_grouped %>% 
  summarise(n = n_distinct(sequence_name)) %>% 
  filter(n >= 0.6*num_sequences) %>% 
  pull(motif_alt_id)
fimo_subset <- fimo_apidae %>% filter(motif_alt_id %in% common_motifs)

#analyse motifs in all sequence
# Get unique motif_alt_id values
fimo_results <- fimo_apidae
motif_ids <- unique(fimo_results$motif_alt_id)

# Initialize a list to store motif_alt_id values present in all sequences
motifs_present_in_all <- list()

# Loop through each input sequence in the FIMO result file
for (seq_name in unique(fimo_results$sequence_name)) {
  # Get motif_alt_id values for this sequence
  seq_motifs <- unique(subset(fimo_results, sequence_name == seq_name)$motif_alt_id)
  # If this is the first sequence, add all its motifs to the vector
  if (length(motifs_present_in_all) == 0) {
    motifs_present_in_all <- seq_motifs
  } else {
    # Otherwise, keep only motifs that are present in both the current sequence and the vector so far
    motifs_present_in_all <- intersect(motifs_present_in_all, seq_motifs)
  }
}

# Print the list of motif_alt_id values that are present in all input sequences
print(motifs_present_in_all)

