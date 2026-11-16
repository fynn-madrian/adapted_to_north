library(ggplot2)

fam  <- read.table("/gorilla/proj/northadapt/private/fynn/target/data.fam")
meta <- read.csv("/gorilla/proj/northadapt/meta_export_2026-11-11.csv")

fam_names  <- fam$V2
meta_names <- meta$Name

matched   <- character(length(fam_names))
n_matches <- integer(length(fam_names))

for (i in seq_along(fam_names)) {
  found <- c()
  for (m in meta_names) {
    if (grepl(tolower(m), tolower(fam_names[i]), fixed = TRUE)) {
      found <- c(found, m)
    }
  }
  n_matches[i] <- length(found)
  matched[i]   <- paste(found, collapse = ";")
}

id_map <- data.frame(fam_name = fam_names, meta_name = matched, n_matches = n_matches)

table(id_map$n_matches)
id_map[id_map$n_matches != 1, ]

write.csv(id_map, "/gorilla/proj/northadapt/private/fynn/target/id_map.csv", row.names = FALSE)


dir <- "/gorilla/proj/northadapt/private/fynn/target"

# PCA results from PLINK (no header): FID, IID, PC1 ... PC10
pca <- read.table(file.path(dir, "pca.eigenvec"), header = FALSE)
colnames(pca) <- c("FID", "IID", paste0("PC", 1:(ncol(pca) - 2)))

# Variance per PC, as a percentage of the computed PCs
eigenval <- scan(file.path(dir, "pca.eigenval"))
var_explained <- round(100 * eigenval / sum(eigenval), 1)

# Metadata, joined through the ID table
id_map <- read.csv(file.path(dir, "id_map.csv"))
meta   <- read.csv("/gorilla/proj/northadapt/meta_export_2026-11-11.csv")

pca <- merge(pca, id_map, by.x = "IID", by.y = "fam_name", all.x = TRUE)
pca <- merge(pca, meta, by.x = "meta_name", by.y = "Name", all.x = TRUE)

# PC1 vs PC2
p <- ggplot(pca, aes(x = PC1, y = PC2, colour = Country)) +
  geom_point(size = 2) +
  labs(x = paste0("PC1 (", var_explained[1], "%)"),
       y = paste0("PC2 (", var_explained[2], "%)")) +
  theme_bw()

ggsave(file.path(dir, "pca_pc1_pc2.png"), p, width = 8, height = 6)

# Scree plot
scree <- data.frame(PC = seq_along(var_explained), variance = var_explained)

s <- ggplot(scree, aes(x = PC, y = variance)) +
  geom_col() +
  labs(x = "Principal component", y = "Variance explained (%)") +
  theme_bw()

ggsave(file.path(dir, "pca_scree.png"), s, width = 6, height = 4)

# Samples furthest out on PC1 and on PC2
head(pca[order(-abs(pca$PC1)), c("IID", "PC1", "PC2")], 5)
head(pca[order(-abs(pca$PC2)), c("IID", "PC1", "PC2")], 5)