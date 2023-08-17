# Graph Exploratory Search Queries

## K0. How "country oficial name" is shaped (spatial) **today** ? 

K0 -> ?v1, alias, "country oficial name". ?v1, P3896, ?v2

?v1 -> QNode of interest   

## K1. **Geo-political** changes of "country oficial name" **over time** 

K1 => ?v1, p1365*, ?vy

K1 => ?vy, p1366*, ?v1

?vy -> QNodes list, agregated entity identified by "country short name"

## K2. When "country oficial name" was established?

K2 -> ?v1, p571, ?v2

K2 -> ?vy, p576, ?v3

## K3. Capital cities of "country short name"?

K3 -> ?v1, p36, ?v2

K3 -> ?vy, p36, ?v3

## K4. What position does the main administrative leader occupy in "country short name" and who were these leaders? 

## K5. What is the government regime in "country short name"? 

## K6. What languages ​​are spoken in "country short name"?

More queries: 

K7. Capital cities of "country short name" **during** "selected historical" period

K8. **Current** Capital cities of "country short name" 

# KGTK files descriptions

| File pattern | Description                                          |
|--------------|------------------------------------------------------|
| context_mappings.tsv | Context Layer                                 |
| CKG-POC-K[n]-mK-p[yyy].tsv | Context Qualifiers of Predicate P[yyy]  |
| countries-claims.tsv | Claims about QNodes of types (P31): "Q3024240", "Q6256", "Q512187", "Q859563", "Q3624078", "Q48349", "Q48349", "Q133156" |
| countries-quals.tsv | Qualifications of Claims about selected QNodes |
| countries-root.tsv | Seed QNodes of types (P31): "Q3024240", "Q6256", "Q512187", "Q859563" |
| countries-P1365.tsv | Reachable nodes from seed QNodes based on P1365 replaces |
| countries-P1366.tsv | Reachable nodes from seed QNodes based on P1366 replaced by |
| countries-all.tsv | Final list of selected QNodes | 
| node-types-counted.tsv | Counting selected QNodes by type | 
| country-types-counted.tsv | Counting selected QNodes by types (P31): "Q3024240", "Q6256", "Q512187", "Q859563", "Q3624078", "Q48349", "Q48349", "Q133156" |
| countries-pred-label-counted.tsv | Counting Claims by predicate |
| countries-node1-count-sorted.tsv | Counting Claims by subject QNode | 
| countries-pred-datatype-counted.tsv | Counting Claims by object QNode datatype | 
| countries-pred-node2type-counted.tsv | Counting Claims by object QNode type| 
| countries-qual-count-sorted.tsv | Counting Qualifications by qualifier |
| countries-pred-qual-count-sorted.tsv | Counting Qualifications by predicate and qualifier |
| countries-quali-datatype-counted.tsv | Counting Qualifications by object QNode datatype | 
| countries-quali-node2type-counted.tsv | Counting Qualifications by object QNode type|  
