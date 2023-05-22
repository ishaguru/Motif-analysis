#Motif analysis documentation:

This R rmd file contains code to analyze motifs in DNA sequences using the FIMO tool. The following libraries are loaded: MotifDb, TFBSTools, Biostrings, readr, ggplot2, tidyr, magrittr, dplyr, gplots, and ggseqlogo.
The first step is to read the FIMO results into R as a dataframe using the read_tsv function from the readr library. The data is stored in the variable fimo_apidae. The last few rows of the dataframe without any data are removed. The matched sequences are extracted as a DNAStringSet object and the motif_alt_id column is replaced with the motif_id or gene_name in case of blank motif_alt_id using ifelse() function.

The next step is to create a matrix where each row represents a DNA sequence and each column represents a motif, with the value in each cell representing the number of occurrences of that motif in that sequence. This is achieved by using the dplyr package functions: select(), group_by(), summarize(), and pivot_wider(). The resulting matrix is stored in the variable apidae_matrix.

A heatmap is created using the heatmap.2 function from the gplots library to display the occurrence of each motif in each DNA sequence, allowing for easy identification of patterns and relationships between motifs and sequences. The heatmap is stored in the variable apidae_plot.

The top represented/over-represented motifs are identified using the aggregate() function to count the occurrences of each unique "motif_id" within each unique "matched_sequence" in the "fimo_apidae" dataset. The resulting dataframe is sorted by motif_count, and the top 10 matched sequences are stored in the variable top_sequences. The motifs found frequently in these sequences are stored in the variable top_fimo.

The code also checks the number of motifs present in 60% of the sequences using the distinct() function from dplyr package. The motifs commonly found in at least 60% of the sequences are stored in the variable common_motifs. A subset of the FIMO results is created with only the common motifs and stored in the variable fimo_subset.

The code then analyzes the motifs present in all input sequences by looping through each input sequence in the FIMO result file, identifying the motif_alt_id values for each sequence, and keeping only motifs that are present in all input sequences. The motif_alt_id values that are present in all input sequences are stored in the variable motifs_present_in_all and printed.

Overall, this R rmd file provides a comprehensive analysis of motifs in DNA sequences using the FIMO tool, and the resulting data can be used to identify patterns and relationships between motifs and sequences.
