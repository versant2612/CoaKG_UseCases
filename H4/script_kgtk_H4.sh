export GRAPH_CKG_H4=/app/kgtk/data/H4/CKG-H4.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 -o /app/kgtk/data/H4/CKG-H4.out
 
## K1 => ?v1, h4r7, h4v1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label})' 

## mK(relationship) => "(?c1, ckg:Contextualizes, h4r7. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4r7 {label: pred_label})'

## mK(entity) => "(?c1, ckg:Contextualizes, ?tipo. {h4v1, ?c1, ?valor . h4v1, rdf:type, ?tipo.} ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {()-[p3:is_a]->(type)} and EXISTS {(:h4v1)-[p3 {label: c1}]->()}' 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {(:h4v1)-[p3:is_a]->(type)} and EXISTS {()-[p3 {label: c1}]->()}' 

## K1' => (?id1(?v1, h4r7, h4v1). ?id1, h4q1, ?v2. ?id1, h4q2, ?v3. ?id1, h4q3, ?v4)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label}), (p1)-[q1:h4q1]->(v2 {label: v2_label}), (p1)-[q2:h4q2]->(v3 {label: v2_label}), (p1)-[q3:h4q3]->(v4 {label: v4_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(:h4v1 {label: h4v1_label})' \
--optional 'h4: (p1)-[q1:h4q1]->(v2 {label: v2_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v4 {label: v4_label})' \
--return 'p1, v1, v1_label, p1.label, "h4v1" as node2, h4v1_label, coalesce(q1, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q1.label, "h4q1") as label, coalesce(v2, "unknown") as node2, coalesce(v2_label, "unknown") as node2_label, coalesce(q2, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q2.label, "h4q2") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as node2_label, coalesce(q3, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q3.label, "h4q3") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label' \
-o /app/kgtk/data/H4/CKG-H4-K1-possible.tsv

## K2 => (?v1,  h4r7, ?v2. ?v2, h4r1, h4v41)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 2 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label})-[p2:h4r1]->(:h4v41 {label: h4v41_label})' 

## mK(relationship) => "(?c1, ckg:Contextualizes, h4r1. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4r1 {label: pred_label})'

## mK(entity) => "(?c1, ckg:Contextualizes, ?tipo. {h4v41, ?c1, ?valor . h4v41, rdf:type, ?tipo.} ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {()-[p3:is_a]->(type)} and EXISTS {(:h4v41)-[p3 {label: c1}]->()}' 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {(:h4v41)-[p3:is_a]->(type)} and EXISTS {()-[p3 {label: c1}]->()}' 

## K2' => (?id1(?v1, h4r7, ?v2). ?id1, h4q1, ?v3. ?id1, h4q2, ?v4. ?id1, h4q3, ?v5.
##         ?id2(?v2, h4r1, h4v41). ?id2, h4q1, ?v6. ?id2, h4q2, ?v7. ?id2, h4q3, ?v8.
##         WHERE check_temporal_relation (?id1, ckgr10, ?id2) )

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (p1)-[q1:h4q1]->(v3 {label: v3_label}), (p1)-[q2:h4q2]->(v4 {label: v4_label}), (p1)-[q3:h4q3]->(v5 {label: v5_label}),(v2 {label: v2_label})-[p2:h4r1]->(:h4v41 {label: h4v41_label}), (p2)-[q4:h4q1]->(v6 {label: v6_label}), (p2)-[q5:h4q2]->(v7 {label: v7_label}), (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--where 'v3 < v7 AND v6 < v4' \
-o /app/kgtk/data/H4/CKG-H4-K2-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (v2 {label: v2_label})-[p2:h4r1]->(:h4v41 {label: h4v41_label})' \
--optional 'h4: (p1)-[q1:h4q1]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v4 {label: v4_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v5 {label: v5_label})' \
--optional 'h4: (p2)-[q4:h4q1]->(v6 {label: v6_label})' \
--optional 'h4: (p2)-[q5:h4q2]->(v7 {label: v7_label})' \
--optional 'h4: (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--with  '*' --where 'kgtk_null_to_empty(v3) < coalesce(v7, "^2023") AND kgtk_null_to_empty(v6) < coalesce(v4, "^2023")' \
--return 'p1, v1, v1_label, p1.label, v2 as node2, v2_label as node2_label, coalesce(q1, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q1.label, "h4q1") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as node2_label, coalesce(q2, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q2.label, "h4q2") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label, coalesce(q3, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q3.label, "h4q3") as label, coalesce(v5, "unknown") as node2, coalesce(v5_label, "unknown") as node2_label, p2, v2, v2_label, p2.label, "h4v41" as node2, h4v41_label as node2_label, coalesce(q4, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q4.label, "h4q1") as label, coalesce(v6, "unknown") as node2, coalesce(v6_label, "unknown") as node2_label, coalesce(q5, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q5.label, "h4q2") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as node2_label, coalesce(q6, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q6.label, "h4q3") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as node2_label' \
-o /app/kgtk/data/H4/CKG-H4-K2-possible.tsv

## K3 => (?v1, h4r7, ?v2. h4v21, is_a, h4v20) ** uso do --force uma vez que é um padrão sub-grafo não conexo

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --force --multi 2 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (:h4v21 {label: h4v1_label})-[p2:is_a]->(:h4v20 {label: h4v20_label})' 

## mK(relationship) => "(?c1, ckg:Contextualizes, h4r7. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4r7 {label: pred_label})'

## mK(entity) => "(?c1, ckg:Contextualizes, ?tipo. {h4v1, ?c1, ?valor . h4v1, rdf:type, ?tipo.} ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {()-[p3:is_a]->(type)} and EXISTS {(:h4v20)-[p3 {label: c1}]->()}' 

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg  --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(type {label: type_label})' \
--where 'EXISTS {(:h4v20)-[p3:is_a]->(type)} and EXISTS {()-[p3 {label: c1}]->()}' 

## K3' => (?id1(?v1, h4r7, ?v2). ?id1, h4q1, ?v3. ?id1, h4q2, ?v4. ?id1, h4q3, ?v5. 
##         ?id1(h4v21, is_a, h4v20). h4v21, h4q1, ?v6. h4v21, h4q2, ?v7. ?id2, h4q3, ?v8. 
##         WHERE check_temporal_relation (?id1, ckgr10, ?id2))

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (p1)-[q1:h4q1]->(v3 {label: v3_label}), (p1)-[q2:h4q2]->(v4 {label: v4_label}), (p1)-[q3:h4q3]->(v5 {label: v5_label}), (:h4v21 {label: h4v21_label})-[p2:is_a]->(:h4v20 {label: h4v20_label}), (:h4v21 {label: h4v21_label})-[p3:h4q1]->(v6 {label: v6_label}), (:h4v21 {label: h4v21_label})-[p4:h4q2]->(v7 {label: v7_label}), (p2)-[q4:h4q3]->(v8 {label: v8_label})' \
--where 'v3 < v7 AND v6 < v4' \
-o /app/kgtk/data/H4/CKG-H4-K3-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --force \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (:h4v21 {label: h4v1_label})-[p2:is_a]->(:h4v20 {label: h4v20_label})' \
--optional 'h4: (p1)-[q1:h4q1]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v4 {label: v4_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v5 {label: v5_label})' \
--optional 'h4: (:h4v21 {label: h4v21_label})-[p3:h4q1]->(v6 {label: v6_label})' \
--optional 'h4: (:h4v21 {label: h4v21_label})-[p4:h4q2]->(v7 {label: v7_label})' \
--optional 'h4: (p2)-[q4:h4q3]->(v8 {label: v8_label})' \
--with  '*' --where 'kgtk_null_to_empty(v3) < coalesce(v7, "^2023") AND kgtk_null_to_empty(v6) < coalesce(v4, "^2023")' \
--return 'p1, v1, v1_label, p1.label, v2 as node2, v2_label as node2_label, coalesce(q1, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q1.label, "h4q1") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as node2_label, coalesce(q2, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q2.label, "h4q2") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label, coalesce(q3, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q3.label, "h4q3") as label, coalesce(v5, "unknown") as node2, coalesce(v5_label, "unknown") as node2_label, p2, "h4v21" as node1, h4v21_label as node1_label, "is_a" as p2_label, "h4v21" as node2, h4v21_label as node2_label, coalesce(p3, "unknown") as id, "h4v21" as node1, h4v21_label as node1_label, coalesce(p3.label, "h4q1") as label, coalesce(v6, "unknown") as node2, coalesce(v6_label, "unknown") as node2_label, coalesce(p4, "unknown") as id, "h4v21" as node1, h4v21_label as node1_label, coalesce(p4.label, "h4q2") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as node2_label, coalesce(q4, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q4.label, "h4q3") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as node2_label' \
-o /app/kgtk/data/H4/CKG-H4-K3-possible.tsv

## K4 => (?id1(?v1, h4r7, ?v2). ?id1, h4q1, ?v3. ?id1, h4q2, ?v4. ?id1, h4q3, ?v5.
##        ?id2(h4v6, h4r7, ?v2). ?id2, h4q1, ?v6. ?id2, h4q2, ?v7. ?id1, h4q3, ?v8.
##        WHERE check_temporal_relation(?id1, ckgr11, ?id2) )

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (p1)-[q1:h4q1]->(v3 {label: v3_label}), (p1)-[q2:h4q2]->(v4 {label: v4_label}), (p1)-[q3:h4q3]->(v5 {label: v5_label}),(:h4v6 {label: h4v6_label})-[p2:h4r7]->(v2 {label: v2_label}), (p2)-[q4:h4q1]->(v6 {label: v6_label}), (p2)-[q5:h4q2]->(v7 {label: v7_label}), (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--where 'v1 != "h4v6" and v3 < v6' \
-o /app/kgtk/data/H4/CKG-H4-K4-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (:h4v6 {label: h4v6_label})-[p2:h4r7]->(v2 {label: v2_label})' \
--where 'v1 != "h4v6"' \
--optional 'h4: (p1)-[q1:h4q1]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v4 {label: v4_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v5 {label: v5_label})' \
--optional 'h4: (p2)-[q4:h4q1]->(v6 {label: v6_label})' \
--optional 'h4: (p2)-[q5:h4q2]->(v7 {label: v7_label})' \
--optional 'h4: (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--with  '*' --where 'kgtk_null_to_empty(v3) < kgtk_null_to_empty(v6)' \
--return 'p1, v1, v1_label, p1.label, v2 as node2, v2_label as node2_label, coalesce(q1, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q1.label, "h4q1") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as node2_label, coalesce(q2, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q2.label, "h4q2") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label, coalesce(q3, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q3.label, "h4q3") as label, coalesce(v5, "unknown") as node2, coalesce(v5_label, "unknown") as node2_label, p2, "h4v6" as node2, h4v6_label as node2_label, p2.label, v2, v2_label, coalesce(q4, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q4.label, "h4q1") as label, coalesce(v6, "unknown") as node2, coalesce(v6_label, "unknown") as node2_label, coalesce(q5, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q5.label, "h4q2") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as node2_label, coalesce(q6, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q6.label, "h4q3") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as node2_label' \
-o /app/kgtk/data/H4/CKG-H4-K4-possible.tsv

## K5 => ((?id1(?v1, h4r7, ?v2). ?id1, h4q1, ?v3. ?id1, h4q2, ?v4. ?id1, h4q3, ?v5.
##        ?id2(h4v2, h4r7, ?v2). ?id2, h4q1, ?v6. ?id2, h4q2, ?v7. ?id1, h4q3, ?v8.
##        WHERE check_temporal_relation(?id1, ckgr12, ?id2) )

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (p1)-[q1:h4q1]->(v3 {label: v3_label}), (p1)-[q2:h4q2]->(v4 {label: v4_label}), (p1)-[q3:h4q3]->(v5 {label: v5_label}),(:h4v2 {label: h4v2_label})-[p2:h4r7]->(v2 {label: v2_label}), (p2)-[q4:h4q1]->(v6 {label: v6_label}), (p2)-[q5:h4q2]->(v7 {label: v7_label}), (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--where 'v1 != "h4v2" and v3 > v6' \
-o /app/kgtk/data/H4/CKG-H4-K5-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  \
--match 'h4: (v1 {label: v1_label})-[p1:h4r7]->(v2 {label: v2_label}), (:h4v2 {label: h4v2_label})-[p2:h4r7]->(v2 {label: v2_label})' \
--where 'v1 != "h4v2"' \
--optional 'h4: (p1)-[q1:h4q1]->(v3 {label: v3_label})' \
--optional 'h4: (p1)-[q2:h4q2]->(v4 {label: v4_label})' \
--optional 'h4: (p1)-[q3:h4q3]->(v5 {label: v5_label})' \
--optional 'h4: (p2)-[q4:h4q1]->(v6 {label: v6_label})' \
--optional 'h4: (p2)-[q5:h4q2]->(v7 {label: v7_label})' \
--optional 'h4: (p2)-[q6:h4q3]->(v8 {label: v8_label})' \
--with  '*' --where 'kgtk_null_to_empty(v3) > kgtk_null_to_empty(v6)' \
--return 'DISTINCT p1, v1, v1_label, p1.label, v2 as node2, v2_label as node2_label, coalesce(q1, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q1.label, "h4q1") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as node2_label, coalesce(q2, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q2.label, "h4q2") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label, coalesce(q3, "unknown") as id, p1 as node1, "" as node1_label, coalesce(q3.label, "h4q3") as label, coalesce(v5, "unknown") as node2, coalesce(v5_label, "unknown") as node2_label, p2, "h4v2" as node2, h4v2_label as node2_label, p2.label, v2, v2_label, coalesce(q4, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q4.label, "h4q1") as label, coalesce(v6, "unknown") as node2, coalesce(v6_label, "unknown") as node2_label, coalesce(q5, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q5.label, "h4q2") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as node2_label, coalesce(q6, "unknown") as id, p2 as node1, "" as node1_label, coalesce(q6.label, "h4q3") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as node2_label' \
-o /app/kgtk/data/H4/CKG-H4-K5-possible.tsv