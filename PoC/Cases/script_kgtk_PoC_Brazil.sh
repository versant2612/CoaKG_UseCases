#!/bin/bash

export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label})  ' \
--where 'v1 = "Q155" ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-claims.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
--where 'v1 = "Q155" ' \
--return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-qualifications.tsv

printf "K1 "
## K1. Quais unidades geo-políticas / nações o atual Brasil substituiu? 
## K1a => q155, p1365, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root Q155 --prop P1365 --breadth-first \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path.tsv

export GRAPH_Q155_PATH=/app/kgtk/data/WD_PoC/Brazil-p1365-path.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-base.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (:Q155 {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-K1-entity2-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND v1 = "Q155" ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-K1-entity1-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (:Q155 {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (pred {label: pred_label})-[pc1:ckgr4]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr8" as label, "ckg:Determines" as `label;label`, "ckgId" as node2, "Entity Identifier" as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-K1-entity2-identifiers.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (v1 {label: v1_label})-[:P1365]->(), (v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (pred {label: pred_label})-[pc1:ckgr4]->(v2) ' \
--where 'p3.label = pred AND v1 = "Q155" ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr8" as label, "ckg:Determines" as `label;label`, "ckgId" as node2, "Entity Identifier" as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-K1-entity1-identifiers.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 --force \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label}) ' \
--where 'q1.label = c1 AND C_label = "Generic" ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-generic-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1365) where q1.label = c1} ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'cc: (:Q155 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} ' \
--return 'p1 as id, "Q155" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-K1-unknown-context.tsv

## K1. Quais unidades geo-políticas / nações o atual Brasil substituiu indiretamente? 
## K1b => q155, p1365*, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-entity2-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (pred {label: pred_label})-[pc1:ckgr4]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr8" as label, "ckg:Determines" as `label;label`, "ckgId" as node2, "Entity Identifier" as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-path-entity2-identifiers.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1365) where q1.label = c1} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-unknown-context.tsv

## K1. Quais unidades geo-políticas / nações, localizadas na América do Sul, o atual Brasil substituiu indiretamente? 
## K1c => q155, p1365*, ?v1. ?v1, P30, Q18

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), (v1)-[:P30]->(:Q18), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-p30-entity2-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), (v1)-[:P30]->(:Q18), ckg: (pred {label: pred_label})-[pc1:ckgr4]->(v2) ' \
--where 'p3.label = pred ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr8" as label, "ckg:Determines" as `label;label`, "ckgId" as node2, "Entity Identifier" as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-path-entity2-p30-identifiers.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), (v1)-[:P30]->(:Q18), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-p30-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[:P1365]->(v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), (v1)-[:P30]->(:Q18), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-P31types-p1365-path-p30-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), (v1)-[:P30]->(:Q18), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-p30-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), (v1)-[:P30]->(:Q18), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-p30-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg -- multi 2 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), (v1)-[:P30]->(:Q18), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1365) where q1.label = c1} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-p30-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q155_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), (v1)-[:P30]->(:Q18), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Brazil-p1365-path-p30-unknown-context.tsv

## K1d => ?v1, p1366, q155

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root Q155 --prop P1366 --breadth-first \
-o /app/kgtk/data/WD_PoC/Brazil-p1366-path.tsv

export GRAPH_Q155_PATH=/app/kgtk/data/WD_PoC/Brazil-p1366-path.tsv

## Não tem resultado então não será considerado ##
