#!/bin/bash

export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz

printf "K0 "
## K0. Qual é a representação da unidade geo-política atual referente ao "República Federativa do México"? 
## K0 -> ?v1, alias, "United Mexican States". ?v1, P3896, ?v2

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a \
--match 'cc: (v1 {label: c_label})-[p1:P3896 {`label;label`: p_label}]->(v2 {label: v2_label}), a: (v1)-[]->(v1_alias) ' \
--where 'v1_alias = $name ' --para name="'United Mexican States'@en" \
--return 'p1 as id, v1 as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-K0-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1365. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P3896"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K0-mK-p3896.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (v1 {label: v1_label})-[p1:P3896 {`label;label`: p_label}]->(v2 {label: v2_label}), a: (v1)-[]->(v1_alias), cq: (p1)-[q1]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P3896) ' \
--where 'v1_alias = $name AND q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--para name="'United Mexican States'@en" \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v3 as node2, v3_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p3896-K0-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (v1 {label: v1_label})-[p1:P3896 {`label;label`: p_label}]->(v2 {label: v2_label}), a: (v1)-[]->(v1_alias), cq: (p1)-[q1]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P3896) ' \
--where 'v1_alias = $name AND q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--para name="'United Mexican States'@en" \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v3 as node2, v3_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p3896-K0-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (v1 {label: c_label})-[p1:P3896 {`label;label`: p_label}]->(v2 {label: v2_label}), a: (v1)-[]->(v1_alias) ' \
--where 'v1_alias = $name ' --para name="'United Mexican States'@en" \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P3896) where q1.label = c1} ' \
--return 'p1 as id, v1 as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p3896-K0-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_ALIAS --as a -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (v1 {label: c_label})-[p1:P3896 {`label;label`: p_label}]->(v2 {label: v2_label}), a: (v1)-[]->(v1_alias), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} AND v1_alias = $name ' --para name="'United Mexican States'@en"  \
--return 'p1 as id, v1 as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p3896-K0-unknown.tsv

printf "K1 "
## K1. Quais unidades geo-políticas / nações o atual México substituiu? 
## K1a => q96, p1365, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root Q96 --prop P1365 --breadth-first \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1path.tsv

export GRAPH_Q96_PATH=/app/kgtk/data/WD_PoC/q96-p1365-K1path.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1365. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P1365"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K1-mK-p1365.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg  \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1365) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-unknown.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1365) where q1.label = c1} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1path-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1365 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1365) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1path-unknown.tsv

## K1b => ?v1, p1366, q96

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root Q96 --prop P1366 --breadth-first \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1path.tsv

export GRAPH_Q96_PATH=/app/kgtk/data/WD_PoC/q96-p1366-K1path.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P1366]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1366. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P1366"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K1-mK-p1366.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1366) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-unknown.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1366) where q1.label = c1} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1path-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'p: ()-[]->(v1), cc: (country {label: c_label})-[p1:P1366 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1path-unknown.tsv

kgtk cat -i /app/kgtk/data/WD_PoC/q96-p1365-K1path.tsv /app/kgtk/data/WD_PoC/q96-p1366-K1path.tsv / deduplicate -o /app/kgtk/data/WD_PoC/q96-all-K1path.tsv

export GRAPH_Q96_PATH=/app/kgtk/data/WD_PoC/q96-all-K1path.tsv

printf "K2"
# K2. Quando o México foi fundado?
## K2a => q96, p571, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P571]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P571. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P571"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K2-mK-p571.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P571) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P571 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P571) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-unknown.tsv

## K2b => q96, p1365*, ?v1. ?v1, P576, ?v2

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P576]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P576. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P576"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K2-mK-p576.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (v1 {label: v1_label})-[p1:P576 {`label;label`: p1_label}]->(v2 {label: v2_label}), cq: (p1)-[q1]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P576) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v3 as node2, v3_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (v1 {label: v1_label})-[p1:P576 {`label;label`: p1_label}]->(v2 {label: v2_label}), cq: (p1)-[q1]->(v3 {label: v3_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P576) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v3 as node2, v3_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (v1 {label: v1_label})-[p1:P576 {`label;label`: p1_label}]->(v2 {label: v2_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v3 {label: v3_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P576) where q1.label = c1} ' \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v3 as node2, v3_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2path-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(v1), cc: (v1 {label: v1_label})-[p1:P576 {`label;label`: p1_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1366) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, p1_label as `label;label`, v2 as node2, v2_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2path-unknown.tsv

printf "aqui1 "

printf "K3"
# K3. Quais foram as capitais do México?

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P36. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P36"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K3-mK-p36.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P36) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-unknown.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(country), cc: (country {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3path-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(country), cc: (country {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3path-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(country), cc: (country {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P36) where q1.label = c1} ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3path-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_Q96_PATH --as p -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'p: ()-[]->(country), cc: (country {label: c_label})-[p1:P36 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'ckg: (c1 {label: c1_label})-[pc1:ckgr2]->(:P36) ' \
--optional 'ckg: (pc1)-[pc3:ckgp1]->(ckgl2) ' \
--where 'NOT EXISTS {cq: (p1)-[q1]->() where q1.label = c1} ' \
--optional 'ckg: (C)-[pc2:ckgr1]->(c1) ' \
--return 'p1 as id, country as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3path-unknown.tsv

printf "K4"
# K4. Qual é a posição do principal líder administrativo no México e quem foram estes lideres? 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P35]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p35-K4-base.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p2:P1906]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-P1906-K4-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P35. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P35"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p35.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P35 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P35) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p35-K4-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P35 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P35) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p35-K4-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P35 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P35) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p35-K4-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P35 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P35) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p35-K4-unknown.tsv

printf "aqui4 "

## mK(relationship) => "(?c1, ckg:Contextualizes, P1906. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P1906"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p1906.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1906 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1906) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1906-K4-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1906 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1906) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1906-K4-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1906 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1906) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1906-K4-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P1906 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1906) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1906-K4-unknown.tsv

printf "aqui5 "

## mK(relationship) => "(?c1, ckg:Contextualizes, P6. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P6"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p6.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P6 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P6) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p6-K4-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P6 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P6) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p6-K4-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P6 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P6) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p6-K4-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P6 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P6) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p6-K4-unknown.tsv

printf "aqui6 "

## mK(relationship) => "(?c1, ckg:Contextualizes, P1313. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P1313"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p1313.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1313 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1313) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1313-K4-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1313 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1313) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1313-K4-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P1313 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P1313) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p1313-K4-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P1313 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P1313) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p1313-K4-unknown.tsv

printf "aqui7 "

printf "K5"
# K5. Qual é o regime de governo no México? 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1:P122]->(v1 {label: v1_label})' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P122. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P122"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K5-mK-p122.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P122 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P122) ' \
--where 'q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P122 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P122) ' \
--where 'q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1:P122 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(:P122) where q1.label = c1} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1:P122 {`label;label`: p_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(:P122) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} '  \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-unknown.tsv

printf "aqui8 "

#K6. Quais idiomas são falados no México?

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc \
--match 'cc: (:Q96 {label: c_label})-[p1]->(v1 {label: v1_label})' \
--where 'p1.label in ["P2936", "P37", "P103"] ' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, ["P2936", "P37", "P103"]. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg \
--match 'ckg: (C {label: C_label})-[p2:ckgr1 {`label;label`: r1_label}]->(c1 {label: quali_label})-[p1:ckgr2 {`label;label`: r2_label}]->(pred {label: pred_label})' \
--where 'pred in ["P2936", "P37", "P103"] ' \
--optional '(p1)-[p3:ckgp1 {label: p1_label}]->(v1 {label: v1_label}) ' \
--return 'p1 as id, c1 as node1, quali_label as `node1;label`, p1.label as label, r2_label as `label;label`, pred as node2, pred_label as `node2;label`, p2 as id, C as node1, C_label as `node1;label`, p2.label as label, r1_label as `label;label`, c1 as node2, quali_label as `node2;label`, p3 as id, p1 as node1, "" as `node1;label`, p3.label as label, p1_label as `label;label`, v1 as node2, v1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K6-mK-p_languages.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'p1.label in ["P2936", "P37", "P103"] AND p1.label = pred AND q1.label = c1 AND EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-mandatory-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1 {`label;label`: p_label}]->(v1 {label: v1_label}), cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'p1.label in ["P2936", "P37", "P103"] AND p1.label = pred AND q1.label = c1 AND NOT EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, v2 as node2, v2_label as `node2;label`, pc2 as id, C as node1, C_label as `node1;label`, "ckgr1" as label, "ckg:Represented By" as `label;label`, c1 as node2, c1_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-suggested-context.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg \
--match 'cc: (:Q96 {label: c_label})-[p1 {`label;label`: p_label}]->(v1 {label: v1_label}) ' \
--where 'p1.label in ["P2936", "P37", "P103"] ' \
--optional 'cq: (p1)-[q1 {`label;label`: q_label}]->(v2 {label: v2_label}) ' \
--where 'NOT EXISTS {ckg: (C)-[pc2:ckgr1]->(c1)-[pc1:ckgr2]->(pred) where q1.label = c1 AND p1.label = pred } ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, p_label as `label;label`, v1 as node2, v1_label as `node2;label`, q1 as id, iif(q1 is not null, p1, "") as node1, "" as `node1;label`, q1.label as label, q_label as `label;label`, v2 as node2, v2_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-qualified.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as cc -i $GRAPH_QUALS --as cq -i $GRAPH_CKG_POC --as ckg --force \
--match 'cc: (:Q96 {label: c_label})-[p1 {label: pred_label}]->(v1 {label: v1_label}), ckg: (C {label: C_label})-[pc2:ckgr1]->(c1 {label: c1_label})-[pc1:ckgr2]->(pred) ' \
--where 'EXISTS {ckg: (pc1)-[pc3:ckgp1]->(ckgl2)} AND NOT EXISTS {cq: (p1)-[q1]->(v2) where q1.label = c1} AND p1.label in ["P2936", "P37", "P103"] ' \
--return 'p1 as id, "Q96" as node1, c_label as `node1;label`, p1.label as label, pred_label as `label;label`, v1 as node2, v1_label as `node2;label`, concat(p1,"-",c1) as id, p1 as node1, "" as `node1;label`, c1 as label, c1_label as `label;label`, "unknown" as node2, "" as `node2;label` ' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-unknown.tsv

exit 0 

printf "listar" 

FILES="/app/kgtk/data/WD_PoC/*-P13*"
for f in $FILES
do
  echo "Processing $f file..."

  cut -f 1-7  < f > file1.tsv
  cut -f 8-14 < f > file2.tsv
  cut -f 15-21 < f > file3.tsv

  kgtk cat -i file1.tsv file2.tsv file3.tsv / deduplicate -o /app/kgtk/data/WD_PoC/$f.new
done


cut -f 1-6  < CKG-H4-K1-possible.tsv > file1.tsv
cut -f 7-12 < CKG-H4-K1-possible.tsv > file2.tsv
cut -f 13-18 < CKG-H4-K1-possible.tsv > file3.tsv
cut -f 19-24 < CKG-H4-K1-possible.tsv > file4.tsv

kgtk cat -i file1.tsv file2.tsv file3.tsv file4.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K1-possible-multi.tsv

