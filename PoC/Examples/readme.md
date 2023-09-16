# Graph Exploratory Search Queries

## K0. How "country oficial name" is shaped (spatial) **today** ? 

K0 -> ?v1, alias, "country oficial name". ?v1, P3896, ?v2

?v1 -> QNode of interest   

### Query K0 - Congo Q971 and Q974

Files Congo-K0-Q974-all.tsv and Congo-K0-Q971-all.tsv

### Query K0 - Luxemburg Q32

File Luxemburg-K0-all.tsv

## K1. **Geo-political** changes of "country oficial name" **over time** 

K1 => ?v1, p1365*, ?vy

K1 => ?vy, p1366*, ?v1

?vy -> QNodes list, abstract entity identified by "country short name", every Qnode is a geo-political entity

### Query K1 - Brazil Q155

Files Brazil-K1-all.tsv, Brazil-p1365-K1-Q217230.tsv, Brazil-p1365-K1-Q5848654.tsv and Brazil-p1365-path-p30-all.tsv

## K2. When "country oficial name" was established?

K2 -> ?v1, p571, ?v2

K2 -> ?vy, p576, ?v3

### Query K2 - Mexico Q96

Files Mexico-K2-p571[a-e].tsv

## K3. Capital cities of "country oficial name"? Capital cities of "country short name"?

K3 -> ?v1, p36, ?v2

K3 -> ?vy, p36, ?v3

?vy -> QNodes list, abstract entity identified by "country short name", every Qnode is a geo-political entity

### Query K3 - Capitals

Files [Country]_Capitals-K3-p35-all.tsv

## K4. What position does the main administrative leader occupy in "country short name" and who were these leaders? 

K4 -> ?p1 (?v1, ?pred1, ?v2). ?p2 (?v1, ?pred2, ?v3).

pred1 (P1313 'office held by head of government'@en  , P1906 'office held by head of state'@en )

pred2 (P6 'head of government'@en ,  P35 'head of state'@en ) 

### Query K4 - Leadership

Files [Country]_Leaders-K4-all.tsv

## K5. What is the government regime in "country short name"? 

## K6. What languages ​​are spoken in "country short name"?

More queries: 

K7. Capital cities of "country short name" **during** "selected historical" period

K8. **Current** Capital cities of "country short name"

