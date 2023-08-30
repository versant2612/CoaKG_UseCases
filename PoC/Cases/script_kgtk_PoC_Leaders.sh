#!/bin/bash

export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label})  ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P1906", "P6", "P1313"] ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
--order-by 'v1 ' \
-o /app/kgtk/data/WD_PoC/Leaders-Country-claims.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", 
"Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P1906", "P6", "P1313"] ' \
--return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
--order-by 'v1' \
-o /app/kgtk/data/WD_PoC/Leaders-Country-qualifications.tsv

printf "K4 "
## K4. Qual é a posição do principal líder administrativo no <país ?v1> e quem foram estes lideres? 
## K4a => ?p1 (?v1, ?pred1, ?v2). ?p2 (?v1, ?pred2, ?v3). ?q1 (?p2, P580, ?v4). 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq --multi 2 \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p1_label}]->(v2 {label: v2_label}), (v1 {label: v1_label})-[p2 {`label;label`: p2_label}]->(v3 {label: v3_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND 
( ( p1.label = "P35" and p2.label = "P1906" ) OR ( p1.label = "P6" and p2.label = "P1313"  ) ) ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, p2 as id, v1 as node1, v1_label as `node1;label`, p2.label as label, p2_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-incompleted.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p1_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND q1.label = c1 AND p1.label in ["P35", "P6"] AND pred = p1.label ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-predicate1-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p2 {`label;label`: p2_label}]->(v3 {label: v3_label}), cq: (p2)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND q1.label = c1 AND p2.label in ["P1906", "P1313"] AND pred = p2.label ' \
--return 'p2 as id, v1 as node1, v1_label as `node1;label`, p2.label as label, p2_label as `label;label`, v3 as node2, v3_label as `node2;label`, q1 as id, p2 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-predicate2-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 --force \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p1_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND q1.label = c1 AND p1.label in ["P35", "P6"] AND C_label = "Generic" AND NOT EXISTS {ckg: (c1)-[pc1:ckgr2]->(pred) where pred = p1.label } ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-generic1-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 --force \
--match 'cc: (v1 {label: v1_label})-[p2 {`label;label`: p2_label}]->(v3 {label: v3_label}), cq: (p2)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND q1.label = c1 AND p2.label in ["P1906", "P1313"] AND C_label = "Generic" AND NOT EXISTS {ckg: (c1)-[pc1:ckgr2]->(pred) where pred = p2.label } ' \
--return 'p2 as id, v1 as node1, v1_label as `node1;label`, p2.label as label, p2_label as `label;label`, v3 as node2, v3_label as `node2;label`, q1 as id, p2 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-generic2-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p1_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND NOT EXISTS {ckg: (C {label: C_label})-[pc2:ckgr1]->(c1) where q1.label = c1 } AND p1.label in ["P35", "P6"] ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q1_label as `label;label`, v4 as node2, v4_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-qualified1.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'cc: (v1 {label: v1_label})-[p2 {`label;label`: p2_label}]->(v3 {label: v3_label}), cq: (p2)-[q1 {`label;label`: q1_label}]->(v4 {label: v4_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND NOT EXISTS {ckg: (C {label: C_label})-[pc2:ckgr1]->(c1) where q1.label = c1 } AND p2.label in ["P1906", "P1313"] ' \
--return 'p2 as id, v1 as node1, v1_label as `node1;label`, p2.label as label, p2_label as `label;label`, v3 as node2, v3_label as `node2;label`, q1 as id, p2 as node1, "" as `node1;label`, q1.label as label, q1_label as `label;label`, v4 as node2, v4_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-qualified2.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p1_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P6"] AND pred = p1.label AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->() where q1.label = c1 } ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-unknown1-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p2 {`label;label`: p2_label}]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p2.label in ["P1906", "P1313"] AND pred = p2.label AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p2)-[q1]->() where q1.label = c1 } ' \
--return 'p2 as id, v1 as node1, v1_label as `node1;label`, p2.label as label, p2_label as `label;label`, v3 as node2, v3_label as `node2;label`, concat(p2,"-",c1) as id, p2 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p2,"-",c1,"-",C) as id, concat(p2,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-unknown2-context.tsv

# Interseção dos intervalos de tempo - Algebra Temporal no Conta Domínio

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq --force \
--match 'cc: (v1 {label: v1_label})-[p1]->(v2), cq: (p1)-[q1:P580 {`label;label`: q1_label}]->(v4 {label: v4_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P1906", "P6", "P1313"] ' \
--return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q1_label as `label;label`, v4 as node2, v4_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-p580-interval.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq --force \
--match 'cc: (v1 {label: v1_label})-[p1]->(v2), cq: (p1)-[q1:P582 {`label;label`: q1_label}]->(v4 {label: v4_label}) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P1906", "P6", "P1313"] ' \
--return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q1_label as `label;label`, v4 as node2, v4_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-p582-interval.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (v1 {label: v1_label})-[p1]->(v2), ckg: (c1 {label: c1_label})-[pc1:ckgr2]->()  ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND p1.label in ["P35", "P1906", "P6", "P1313"] AND c1 = "P582" AND NOT EXISTS {cq: (p1)-[q1:P582]->() } AND EXISTS {cq: (p1)-[q1:P580]->() } ' \
--return 'DISTINCT concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "^3000-01-01T00:00:00Z/11" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-p582-max-interval.tsv

rm /app/kgtk/data/WD_PoC/Leaders-interval.tsv

\time --format='Elapsed time: %e seconds'  kgtk cat -i /app/kgtk/data/WD_PoC/Leaders*interval.tsv -o /app/kgtk/data/WD_PoC/Leaders-interval.tsv

export GRAPH_INTERVAL=/app/kgtk/data/WD_PoC/Leaders-interval.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_INTERVAL --as it --multi 2 \
--match 'cc: (v1 {label: v1_label})-[p1]->(v2), (v1)-[p2]->(v3), it: (p1)-[q1:P580]->(v4), (p1)-[q2:P582]->(v5), (p2)-[q3:P580]->(v6), (p2)-[q4:P582]->(v7) ' \
--where 'kgtk_lqstring_text(v1_label) in ["France", "United Kingdom", "Italy", "Spain", "Netherlands", "Portugal", "Belgium", "Germany", "Denmark", "Sweden", "Norway", "Finland", "Russia", "Israel", "South Africa", "Turkey", "Brazil", "Bolivia", "Canada"] AND ( ( p1.label = "P35" and p2.label = "P1906" ) OR ( p1.label = "P6" and p2.label = "P1313"  ) ) AND ((v4 <= v7) and (v5 >= v6)) ' \
--return 'DISTINCT concat(p1,"-",p2) as id, p1 as node1, "" as `node1;label`, "ckgt1" as label, "Temporal Overlaps" as `label;label`, p2 as node2, "" as `node2;label`, concat(p1,"-",p2, "-ckgT1") as id, concat(p1,"-",p2) as node1, "" as `node1;label`, "ckgr3" as label, "ckg:Inferred Context" as `label;label`, "ckgT1" as node2, "Temporal" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Leaders-K4-inferred-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk cat -i /app/kgtk/data/WD_PoC/Leaders-K4*.tsv / deduplicate -o /app/kgtk/data/WD_PoC/Examples/Leaders-K4-all.tsv

grep Q801- /app/kgtk/data/WD_PoC/Examples/Leaders-K4-all.tsv > /app/kgtk/data/WD_PoC/Examples/Israel_Leaders-K4-all.tsv
grep Q16- /app/kgtk/data/WD_PoC/Examples/Leaders-K4-all.tsv > /app/kgtk/data/WD_PoC/Examples/Canada_Leaders-K4-all.tsv
grep Q142- /app/kgtk/data/WD_PoC/Examples/Leaders-K4-all.tsv > /app/kgtk/data/WD_PoC/Examples/France_Leaders-K4-all.tsv

