export GRAPH_CLAIMS=/app/kgtk/data/WD_PoC/countries-claims.tsv
export GRAPH_QUALS=/app/kgtk/data/WD_PoC/countries-quals.tsv
export GRAPH_CKG_POC=/app/kgtk/data/WD_PoC/context_mappings.tsv

## K1. Quais unidades geo-políticas / nações o atual México substituiu? 
## K1 => q96, p1365, ?v1

\time --format='Elapsed time: %e seconds'  kgtk --debug reachable-nodes -i $GRAPH_CLAIMS --root Q96 --prop P1365 --breadth-first \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-path.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1365. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P1365 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K1-mK-p1365.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}) ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-K1-possible.tsv

## K1 => ?v1, p1366, q96

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (v1 {label: v1_label})-[p1:P1366]->(:Q96 {label: c_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1366. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P1366 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K1-mK-p1366.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (v1 {label: v1_label})-[p1:P1366]->(:Q96 {label: c_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (v1 {label: v1_label})-[p1:P1366]->(:Q96 {label: c_label}) ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1366-K1-possible.tsv

# K2. Quando o México foi fundado?

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (:Q96 {label: c_label})-[p1:P571]->(v1 {label: v1_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P571. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P571 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K2-mK-p571.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P571]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P571]->(v1 {label: v1_label}) ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p571-K2-possible.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P576]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P576. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P576 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K2-mK-p576.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P576]->(v2 {label: v2_label}), q: (p2)-[q1]->(v3 {label: v3_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P1365]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P576]->(v2 {label: v2_label})' \
--optional 'q: (p2)-[q1]->(v3 {label: v3_label})' \
-o /app/kgtk/data/WD_PoC/q96-p1365-p576-K2-possible.tsv

# K3. Quais foram as capitais do México?

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P36. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P36 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K3-mK-p36.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}) ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p36-K3-possible.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P571. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P571 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K3-mK-p571.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 4 \
--match 'c: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P571]->(v2 {label: v2_label}), q: (p1)-[q1]->(v3 {label: v3_label}), (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p36-p571-K3-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P36]->(v1 {label: v1_label}), (v1 {label: v1_label})-[p2:P571]->(v2 {label: v2_label})' \
--optional 'q: (p1)-[q1]->(v3 {label: v3_label})' \
--optional 'q: (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p36-p571-K3-possible.tsv

# K4. Qual é a posição do principal líder administrativo no México e quem foram estes lideres? 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P35]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1906]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p35-P1906-K4-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P35. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P35 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p35.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1906. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P1906 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p1906.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 4 \
--match 'c: (:Q96 {label: c_label})-[p1:P35]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1906]->(v2 {label: v2_label}), q: (p1)-[q1]->(v3 {label: v3_label}), (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p35-P1906-K4-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P35]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1906]->(v2 {label: v2_label}) ' \
--optional 'q: (p1)-[q1]->(v3 {label: v3_label})' \
--optional 'q: (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p35-P1906-K4-possible.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P6]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1313]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p6-P1313-K4-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P6. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P6 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p6.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P1313. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P1313 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K4-mK-p1313.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 4 \
--match 'c: (:Q96 {label: c_label})-[p1:P6]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1313]->(v2 {label: v2_label}), q: (p1)-[q1]->(v3 {label: v3_label}), (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p6-P1313-K4-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P6]->(v1 {label: v1_label}), (:Q96 {label: c_label})-[p2:P1313]->(v2 {label: v2_label}) ' \
--optional 'q: (p1)-[q1]->(v3 {label: v3_label})' \
--optional 'q: (p2)-[q2]->(v4 {label: v4_label})' \
-o /app/kgtk/data/WD_PoC/q96-p6-P1313-K4-possible.tsv

# K5. Qual é o regime de governo no México? 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (:Q96 {label: c_label})-[p1:P122]->(v1 {label: v1_label})' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, P122. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:P122 {label: pred_label})' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K5-mK-p122.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1:P122]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1:P122]->(v1 {label: v1_label}) ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label})' \
-o /app/kgtk/data/WD_PoC/q96-p122-K5-possible.tsv

#K6. Quais idiomas são falados no México?

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c \
--match 'c: (:Q96 {label: c_label})-[p1]->(v1 {label: v1_label})' \
--where 'p1.label in ["P2936", "P37", "P103"] ' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, ["P2936", "P37", "P103"]. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_POC --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(pred {label: pred_label})' \
--where 'pred in ["P2936", "P37", "P103"] ' \
-o /app/kgtk/data/WD_PoC/CKG-POC-K5-mK-p122.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q  --multi 2 \
--match 'c: (:Q96 {label: c_label})-[p1]->(v1 {label: v1_label}), q: (p1)-[q1]->(v2 {label: v2_label})' \
--where 'p1.label in ["P2936", "P37", "P103"] ' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c -i $GRAPH_QUALS --as q \
--match 'c: (:Q96 {label: c_label})-[p1]->(v1 {label: v1_label}) ' \
--where 'p1.label in ["P2936", "P37", "P103"] ' \
--optional 'q: (p1)-[q1]->(v2 {label: v2_label}) ' \
-o /app/kgtk/data/WD_PoC/q96-languages-K6-possible.tsv

exit 0 
 
## K1 => ?v1, h4r7, h4v1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, h4r7. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4r7 {label: pred_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-mK-h4r7.tsv

## mK(entity) => "(?c1, ckg:Contextualizes, ?tipo. {h4v1, ?c1, ?valor . h4v1, rdf:type, ?tipo.} ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(:h4v1 {label: type_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-mK-h4v1.tsv

## K1' => (?id1(?v1, h4r7, h4v1). ?id1, h4q1, ?v2. ?id1, h4q2, ?v3. ?id1, h4q3, ?v4)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label}), (p1)-[q1:h4q1]->(v2 {label: v2_label}), (p1)-[q2:h4q2]->(v3 {label: v2_label}), (p1)-[q3:h4q3]->(v4 {label: v4_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label})' \
--optional 'h4: (p1)-[q1:h4q1]->(v2 {label: v2_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v4 {label: v4_label})' \
--return 'DISTINCT p1 as id, v1 as node1, v1_label as `node1;label`, p1.label as label, "h4v1" as node2, h4v1_label as `node2;label`, coalesce(q1, "unknown") as id, p1 as node1, "" as `node1;label`, coalesce(q1.label, "h4q1") as label, coalesce(v2, "unknown") as node2, coalesce(v2_label, "unknown") as `node2;label`, coalesce(q2, "unknown") as id, p1 as node1, "" as `node1;label`, coalesce(q2.label, "h4q2") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as `node2;label`, coalesce(q3, "unknown") as id, p1 as node1, "" as `node1;label`, coalesce(q3.label, "h4q3") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as `node2;label`' \
-o /app/kgtk/data/H4/CKG-H4-K1-possible.tsv

cut -f 1-6  < CKG-H4-K1-possible.tsv > file1.tsv
cut -f 7-12 < CKG-H4-K1-possible.tsv > file2.tsv
cut -f 13-18 < CKG-H4-K1-possible.tsv > file3.tsv
cut -f 19-24 < CKG-H4-K1-possible.tsv > file4.tsv

kgtk cat -i file1.tsv file2.tsv file3.tsv file4.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K1-possible-multi.tsv

