printf "Claims e Qualifications of WD - Junho 2022\n" > /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "BEGIN Current date %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_QUALS=/app/kgtk/data/wikidata/qualifiers.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_CLAIMS=/app/kgtk/data/wikidata/claims.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_LABEL=/app/kgtk/data/wikidata/labels.en.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.0 Environmet Settings %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_ALIAS --as alias --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_QUALS --as quals --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_CLAIMS --as c --index none --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_LABEL --as lab --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "WD1.1 Filter CLAIMS with the types of interest to generate the subgraph %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none  \
--match 'c: (item)-[:P31]->(type) ' \
--where 'type in ["Q3024240", "Q6256", "Q512187", "Q859563"]' \
--order-by 'item' \
--return 'distinct item as id' \
-o /app/kgtk/data/WD_PoC/countries-root.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root-file /app/kgtk/data/WD_PoC/countries-root.tsv \
--prop P1365 --breadth-first -o /app/kgtk/data/WD_PoC/countries-P1365.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root-file /app/kgtk/data/WD_PoC/countries-root.tsv \
--prop P1366 --inverted --breadth-first -o /app/kgtk/data/WD_PoC/countries-P1366.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug cat -i /app/kgtk/data/WD_PoC/countries-P1365.tsv /app/kgtk/data/WD_PoC/countries-P1366.tsv \
-o /app/kgtk/data/WD_PoC/countries-all.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i /app/kgtk/data/WD_PoC/countries-all.tsv --as all -i $GRAPH_LABEL --as lab \
--match 'c: (item)-[:P31]->(type), all: ()-[]->(item), lab: (type)-[]->(type_label) ' \
--order-by 'count(type) desc' \
--return 'distinct type as node1, type_label as `node2;label`, "count" as label, count(type) as node2' \
-o /app/kgtk/data/WD_PoC/node-types-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab --force \
--match 'c: (item)-[:P31]->(type), (item)-[p1]->(p_val {wikidatatype: p_dt}), lab: (pred)-[]->(pred_label), lab: (item)-[]->(item_label)' \
--where 'p1.label = pred and type in ["Q3024240", "Q6256", "Q512187", "Q859563", "Q3624078", "Q48349", "Q48349", "Q133156"]' \
--optional 'lab: (p_val)-[]->(val_label)' \
--order-by 'item, p1.label, val_label' \
--return 'distinct p1 as id, item as node1, item_label as `node1;label`, pred as label, pred_label as `label;label`, p_val as node2, val_label as `node2;label`, p_dt as `node2;wikidatatype`' \
-o /app/kgtk/data/WD_PoC/countries-claims.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

export SUB_GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
\time --format='Elapsed time: %e seconds'  kgtk query -i $SUB_GRAPH_CLAIMS --as f --index none --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f --index none -i $GRAPH_LABEL --as lab --force \
--match 'f: (item)-[:P31]->(type), lab: (type)-[]->(type_label) ' \
--where 'type in ["Q3024240", "Q6256", "Q512187", "Q859563", "Q3624078", "Q48349", "Q48349", "Q133156"]' \
--order-by 'count(type) desc' \
--return 'distinct type as node1, type_label as `node2;label`, "count" as label, count(type) as node2' \
-o /app/kgtk/data/WD_PoC/country-types-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.2 Count Subgraph Predicates %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f --index none -i $GRAPH_LABEL --as lab --force \
--match 'f: ()-[p1]->(), lab: (pred)-[]->(pred_label)' \
--where 'p1.label = pred' \
--return 'distinct pred as node1, pred_label as `node1;label`, "count" as label, count(pred) as node2' \
--order-by 'count(pred) desc' \
-o /app/kgtk/data/WD_PoC/countries-pred-label-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.3 Count subgraph QNodes %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f --index none \
--match 'f: (item {label: item_label})-[]->()' \
--return 'distinct item as node1, item_label as `node1;label`, "count" as label, count(item) as node2' \
--order-by 'count(item) desc' \
-o /app/kgtk/data/WD_PoC/countries-node1-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.4 Count Data Types of Subgraph Predicates %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f --index none -i $GRAPH_LABEL --as lab --force \
--match 'f: ()-[p1]->(p_val {wikidatatype: p_dt}), lab: (pred)-[]->(pred_label)' \
--where 'p1.label = pred' \
--return 'distinct pred as node1, pred_label as `node1;label`, p_dt as `node2;wikidatatype`, "count" as label, count(p_dt) as node2' \
--order-by 'count(p_dt) desc' \
-o /app/kgtk/data/WD_PoC/countries-pred-datatype-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.5 Count types of QNodes associated with subgraph Predicates %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab --force \
--match 'f: ()-[p1]->(p_val), c: (p_val)-[:P31]->(p_type), lab: (pred)-[]->(pred_label), lab: (p_type)-[]->(type_label)' \
--where 'p1.label = pred' \
--return 'distinct pred as node1, pred_label as `node1;label`, p_type as `node1;valuetype`, type_label as `node1;valuetype_label`, "count" as label, count(p_type) as node2' \
--order-by 'count(p_type) desc' \
-o /app/kgtk/data/WD_PoC/countries-pred-node2type-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.6 Get Subgraph CLAIMS Qualifications %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_CLAIMS --as f -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'f: ()-[p1]->(), quals: (p1)-[q1]->(q_val {wikidatatype: q_dt}), lab: (quali)-[]->(quali_label)' \
--where 'q1.label = quali' \
--optional 'lab: (q_val)-[]->(val_label)' \
--order-by 'p1, q1.label, val_label' \
--return 'distinct q1 as id, p1 as node1, "" as `node1;label`, quali as label, quali_label as `label;label`, q_val as node2, val_label as `node2;label`, q_dt as `node2;wikidatatype`' \
-o /app/kgtk/data/WD_PoC/countries-quals.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

export SUB_GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
\time --format='Elapsed time: %e seconds'  kgtk query -i $SUB_GRAPH_QUALS --as q --index none --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "WD1.7 Count Subgraph Qualifiers %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_QUALS --as q --index none -i $SUB_GRAPH_CLAIMS --as f --index none -i $GRAPH_LABEL --as lab --force \
--match 'f: (item)-[p1]->(), q: (p1)-[q1]->(), lab: (quali)-[]->(quali_label), lab: (pred)-[]->(pred_label)' \
--where 'q1.label = quali and p1.label = pred' \
--order-by 'count(q1.label) desc' \
--return 'distinct q1.label as node1, quali_label as `node1;label`, p1.label as `node1;pred`, pred_label as `node1;pred_label`, "count" as label, count(q1.label) as node2' \
-o /app/kgtk/data/WD_PoC/countries-qual-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.8 Count Data Types of Subgraph Qualifiers %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $SUB_GRAPH_QUALS --as q --index none -i $GRAPH_LABEL --as lab --force \
--match 'q: (p1)-[q1]->(q_val {wikidatatype: q_dt}), lab: (quali)-[]->(quali_label)' \
--where 'q1.label = quali' \
--return 'distinct quali as node1, quali_label as `node1;label`, q_dt as `node2;wikidatatype`, "count" as label, count(q_dt) as node2' \
--order-by 'count(q_dt) desc' \
-o /app/kgtk/data/WD_PoC/countries-quali-datatype-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.9 Count types of QNodes associated with subgraph Qualifiers %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $SUB_GRAPH_QUALS --as q --index none -i $GRAPH_LABEL --as lab --force \
--match 'c: (q_val)-[:P31]->(q_type), q: (p1)-[q1]->(q_val), lab: (quali)-[]->(quali_label), lab: (q_type)-[]->(type_label)' \
--where 'q1.label = quali' \
--return 'distinct quali  as node1, quali_label as `node1;label`, q_type as `node1;valuetype`, type_label as `node1;valuetype_label`, "count" as label, count(q_type) as node2' \
--order-by 'count(q_type) desc' \
-o /app/kgtk/data/WD_PoC/countries-quali-node2type-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "END Current date %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

