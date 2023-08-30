#!/bin/bash

export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label})  ' \
--where 'v1 = "Q96" ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-claims.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (v1 {label: v1_label})-[p1 {`label;label`: p_label}]->(v2 {label: v2_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
--where 'v1 = "Q96" ' \
--return 'DISTINCT q1 as id, p1 as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-qualifications.tsv

printf "K2"
# K2. Quando o México foi fundado?
## K2a => Mexico, p571, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v2 {label: v2_label}) ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P571. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --muliti 3 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P571"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-K2-mK-p571.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND v1 = "Q96" ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-P31types-p571-K2-entity1-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --multi 3 \
--match 'cc: (v1 {label: v1_label})-[:P1365]->(), (v1 {label: v1_label})-[p1:P31 {`label;label`: type_label}]->(v2 {label: v2_label}), (v1)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (pred {label: pred_label})-[pc1:ckgr4]->(v2) ' \
--where 'p3.label = pred AND v1 = "Q96" ' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, v1 as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr8" as label, "ckg:Determines" as `label;label`, "ckgId" as node2, "Entity Identifier" as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-P31types-K2-entity1-identifiers.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --force --multi 3 \
--match 'cc: (:Q96 {label: v1_label})-[p1:P31 {`label;label`:type_label}]->(v2 {label: v2_label}), (:Q96)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, "Q96" as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, "Q96" as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-P31types-K2-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_CKG_POC --as ckg --force  --multi 3 \
--match 'cc: (:Q96 {label: v1_label})-[p1:P31 {`label;label`:type_label}]->(v2 {label: v2_label}), (:Q96)-[p3 {`label;label`: p3_label}]->(v4 {label: v4_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(pred {label: pred_label})-[pc1:ckgr2]->(v2) ' \
--where 'p3.label = pred AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'DISTINCT p1 as id, "Q96" as node1, v1_label as `node1;label`, p1.label as label, type_label as `label;label`, v2 as node2, v2_label as `node2;label`, p3 as id, "Q96" as node1, v1_label as `node1;label`, p3.label as label, p3_label as `label;label`, v4 as node2, v4_label as `node2;label`, concat(p3,"-",pred) as id, p3 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-P31types-K2-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 2 \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P571) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force  --multi 3 \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label`, concat(p1,"-",c1,"-",C) as id, concat(p1,"-",c1) as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-unknown-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  --multi 3 --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label}) ' \
--where 'q1.label = c1 AND C_label = "Generic" ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(q1,"-",c1) as id, q1 as node1, "" as `node1;label`, "ckgr9" as label, "ckg:Context Type" as `label;label`, C as node2, C_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/Mexico-p571-K2-generic-context.tsv

