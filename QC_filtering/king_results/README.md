# Target KING results

KING flagged 4,217 of 19,503 pairs at kinship ≥ 0.0442. For the primary PCA, we used 183 pairs supported by Rajiv or published evidence. We kept the largest possible cohort, using sequencing coverage to break ties. This gives 42 proposed exclusions and 156 people for the primary PCA. All 198 remain in the shared genotype VCF pending client approval.

| File | Contents |
| --- | --- |
| [KING table](qc_kinship.kin0) | All pairwise estimates |
| [Supporting pairs](supporting_pairs.tsv) | Evidence for each of the 183 pairs |
| [Decisions](decisions.tsv) | Proposed decision, sequencing coverage and retained relatives for each target |
| [Sample IDs](sample_ids.tsv) | Short sample name and exact VCF ID |
| [Exclusion list](exclude_target_ids.txt) | 42 target IDs, one per line |

The marker VCF came from the shared step 01 INFO-filtered target VCF. We kept transversions with at most 10% missing genotypes and at least 5% minor allele frequency, then LD-pruned with PLINK (`--indep-pairwise 50 10 0.1`). The selected records retain the original phased genotypes. [Run KING](../../README.md)

In the decisions table, `coverage_x` is average nuclear sequencing depth. For an excluded person, `retained_relatives` names the people kept from their supported pairs. We left that field blank for retained people.

## How we assembled the supporting pairs

We matched published sample aliases and Rajiv’s IDs to the 198 target IDs, then looked up each pair in the KING table in either order. We kept pairs with KING ≥ 0.0442 and client or published documentation of first- through third-degree kinship. Our rule was to count a pair as supported by Mattila’s Table S12 only when both READv2 and KIN classified the two people as third-degree relatives or closer. We counted each pair once and recorded all matching sources.

Seersholm Table S9 supplied 168 pairs. Figure S2 and the AADR annotation supported one more (FRA042 and FRA022). Mattila supplied eight pairs, Fraser supplied three further pairs and corroborated two of Mattila’s, and Rajiv supplied three. These sum to 183 unique pairs. Both tables use short sample names. [Sample IDs](sample_ids.tsv) maps each name to its full VCF ID. For example, Mattila S12 row 5 identifies ajv23a and ajv23b as parent and child, and their KING estimate is 0.220252.

## Papers and supplementary materials

| Study | Material used in the review |
| --- | --- |
| [Seersholm et al. (2024)](https://doi.org/10.1038/s41586-024-07651-2) | [Tables S1, S4 and S9](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-024-07651-2/MediaObjects/41586_2024_7651_MOESM4_ESM.xlsx) for IDs, dates and pair calls. [Figure S2](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-024-07651-2/MediaObjects/41586_2024_7651_MOESM1_ESM.docx) for pedigrees. |
| [Mattila et al. (2026)](https://pubmed.ncbi.nlm.nih.gov/41705298/) | [Table S12 in the S1–S14 workbook](https://doi.org/10.6084/m9.figshare.30741637.v1) for READv2 and KIN calls. |
| [Fraser et al. (2026)](https://doi.org/10.1038/s42003-026-10498-0) | [Supplementary Data 6, ancIBD worksheet](https://static-content.springer.com/esm/art%3A10.1038%2Fs42003-026-10498-0/MediaObjects/42003_2026_10498_MOESM4_ESM.xlsx) for Gotland pairs. |
| [Allentoft et al. (2024)](https://doi.org/10.1038/s41586-023-06865-0) | [Data VI](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-023-06865-0/MediaObjects/41586_2023_6865_MOESM5_ESM.xlsx) lists preliminary calls. [Note 3c, Tables S3c.1–2](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-023-06865-0/MediaObjects/41586_2023_6865_MOESM1_ESM.pdf) explains why NEO745 calls were withdrawn. [Data II](https://static-content.springer.com/esm/art%3A10.1038%2Fs41586-023-06865-0/MediaObjects/41586_2023_6865_MOESM4_ESM.xlsx) gives dates. |

For FRA042 and FRA022, we also checked the family annotation and sample alias in the [AADR v66.p1 data file](https://dataverse.harvard.edu/api/access/datafile/13994515) ([dataset record](https://doi.org/10.7910/DVN/FFIDCW)).
