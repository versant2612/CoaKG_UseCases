## Graph Exploratory Search Queries

See script_kgtk_H4.sh and script_kgtk_H4_geo.sh for Kypher version

K1. Capital cities of State of Brazil

K2. Capital cities of Brazil **while** Republican government 

K3. Capital cities of Brazil **during** Brazil Colony (of Portugal) period

K4. Capital cities of Brazil **before** Rio de Janeiro as capital city

K5. Capital cities of Brazil **after** Salvador as capital city

K6. How Brazil is shaped (spatial) **today**

K7. **Spatial** changes of Brazil **over time**

## KGTK files descriptions


| File pattern | Description                                          |
|--------------|------------------------------------------------------|
| CKG-H4.tsv   | CKG about Brazilian Geographic and Political History |
| CKG-H4-label.tsv | Normalized version of CKG about Brazilian Geographic and Political History |
| CKG-H4-K[n]-base.tsv | Result of Original K[n] |
| CKG-H4-K[n]-mK-[id].tsv | Context mappings from entity type, concept or relationsip [id] of Original K[n] |
| CKG-H4-K[n]-exact.tsv | Result of expanded K[n] with Complete Context |
| CKG-H4-K[n]-possible.tsv | Result of expanded K[n] with as complete as possible Context |
| CKG-H4-K[n]-possible-multi.tsv | Result of expanded K[n] with as complete as possible Context, splited |
| CKG-H4-K[n]-inferred.tsv | Aditional Context inferenced from Result of expanded K[n] |
| CKG-H4-K[n]-possible-final.tsv | All Contextualized Possible Answers of K[n] |

