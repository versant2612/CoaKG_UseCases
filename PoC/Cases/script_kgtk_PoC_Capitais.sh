#!/bin/bash

export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (v1 {label: v1_label})-[p1:P36  {`label;label`: p_label}]->(v2 {label: v2_label})  ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia"] ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Capitals-Country-claims.tsv

# \time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq \
# --match 'cc: (v1 {label: v1_label})-[p1:P36  {`label;label`: p_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
# --where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", 
# "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia"] ' \
# --return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
# -o /app/kgtk/data/WD_PoC/Capitals-Country-qualifications.tsv

export GRAPH_QUALS_CAPITALS=/app/kgtk/data/WD_PoC/Capitals-Country-qualifications.tsv

printf "K3 "
## K3. Qual a atual capital dos paises e como foi definida esta relação? 
## K3a => ?p1 (?v1, p36, ?v2). ?q1 (?p1, ?qp36, ?v3). ?c1 ("Provenance", ckgr1, ?qp36). ?i1 ("Temporal", ckgr3, ckgl1)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS_CAPITALS --as cqc \
--match 'cc: (v1 {label: v1_label})-[p1:P36 {`label;label`: type_label}]->(v2 {label: v2_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia"] AND 
( ( EXISTS {cqc: (p1)-[:P580]->()} AND NOT EXISTS {cqc: (p1)-[:P582]->()} ) OR ( NOT EXISTS {cqc: (p1)-[:P580]->()} AND NOT EXISTS {cqc: (p1)-[:P582]->()} ) ) ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-completed.tsv

export GRAPH_CURR_CAPITALS=/app/kgtk/data/WD_PoC/Capitals-p36-K3-completed.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CURR_CAPITALS --as ct -i $GRAPH_CKG_POC --as ckg --force --multi 2 \
--match 'ct: ()-[p1]->(), ckg: (C {label: C_label})-[pc2:ckgr3]->(:ckgl1)  ' \
--return 'DISTINCT concat(p1,"-ckgr3") as id, p1 as node1, "" as `node1;label`, "ckgr3" as label, "ckg:Inferred Context" as `label;label`, "ckgl1" as node2, "Corrente |Atual |Hoje" as `node2;label`, concat(p1,"-ckgr3-", C) as id, concat(p1,"-ckgr3") as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-inferred-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CURR_CAPITALS --as ct -i $GRAPH_QUALS_CAPITALS --as cqc -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'ct: (item {label: item_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cqc: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'q1.label = c1 ' \
--return 'p1 as id, item as node1, item_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-predicate-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CURR_CAPITALS --as ct -i $GRAPH_QUALS_CAPITALS --as cqc -i $GRAPH_CKG_POC --as ckg  --multi 3 --force \
--match 'ct: (item {label: item_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cqc: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label}) ' \
--where 'q1.label = c1  AND C_label = "Generic" AND NOT EXISTS {ckg: (c1)-[pc1:ckgr2]->(:P36)} ' \
--return 'p1 as id, item as node1, item_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-generic-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CURR_CAPITALS --as ct -i $GRAPH_QUALS_CAPITALS --as cqc -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ct: (item {label: item_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cqc: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P36) where q1.label = c1} AND NOT EXISTS {ckg: (C {label: C_label})-[pc2:ckgr1]->(c1) where q1.label = c1 and C_label = "Generic" }' \
--return 'p1 as id, item as node1, item_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CURR_CAPITALS --as ct -i $GRAPH_QUALS_CAPITALS --as cqc -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'ct: (item {label: item_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cqc: (p1)-[q1]->(v2) where q1.label = c1} ' \
--return 'p1 as id, item as node1, item_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-unknown-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_QUALS_CAPITALS --as cqc -i $GRAPH_CKG_POC --as ckg --multi 3 --force \
--match 'cqc: (p1)-[q1 {`label;label`: q1_label}]->(v2 {label: v2_label}), (q1)-[q2 {`label;label`: q2_label}]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(quali) ' \
--where 'q2.label = c1 AND q1.label = quali AND C_label = "Provenance" ' \
--return 'q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q2 as id, q1 as node1, "" as `node1;label`, q2.label as label, q2_label as `label;label`, v3 as node2, v3_label as `node2;label`, concat(q2,"-",C) as id, q2 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Capitals-p36-K3-additional-provenance.tsv

\time --format='Elapsed time: %e seconds'  kgtk cat -i /app/kgtk/data/WD_PoC/Capitals-p36-K3*.tsv / deduplicate -o /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv

grep Q55 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv  > /app/kgtk/data/WD_PoC/Examples/Netherlands_Capitals-p36-K3-all.tsv
grep Q155 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv > /app/kgtk/data/WD_PoC/Examples/Brazil_Capitals-p36-K3-all.tsv
grep Q258 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv > /app/kgtk/data/WD_PoC/Examples/SouthAfrica_Capitals-p36-K3-all.tsv
grep Q801 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv > /app/kgtk/data/WD_PoC/Examples/Israel_Capitals-p36-K3-all.tsv
grep Q750 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv > /app/kgtk/data/WD_PoC/Examples/Bolivia_Capitals-p36-K3-all.tsv
grep Q142 /app/kgtk/data/WD_PoC/Examples/Capitals-p36-K3-all.tsv > /app/kgtk/data/WD_PoC/Examples/France_Capitals-p36-K3-all.tsv

