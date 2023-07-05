export GRAPH_CKG_H4=/app/kgtk/data/H4/CKG-H4.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 -o /app/kgtk/data/H4/CKG-H4.out
 
## K6 => (?id1 (?v1, h4p7, 'Brasil'). ?id2(?v1, h4r2, v2). ?id3(?v1, is_a, h4c1))

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 3 \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1)-[p2:h4r2]->(v2 {label: v2_label}), (v1)-[p3:is_a]->(:h4c1 {label: h4c1_label})' \
--where 'l2 = "Brasil"' \
-o /app/kgtk/data/H4/CKG-H4-K6-base.tsv

## mK(relationship) => "(?c1, ckg:Contextualizes, h4r7. ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4p7 {label: pred_label})' \
-o /app/kgtk/data/H4/CKG-H4-K6-mK-h4p7.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:h4r2 {label: pred_label})' \
-o /app/kgtk/data/H4/CKG-H4-K6-mK-h4r2.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: quali_label})-[p1:ckgr2]->(:is_a {label: pred_label})' \
-o /app/kgtk/data/H4/CKG-H4-K6-mK-is_a.tsv

## mK(entity) => "(?c1, ckg:Contextualizes, ?tipo. {h4v1, ?c1, ?valor . h4v1, rdf:type, ?tipo.} ?C  {label = ?C.label}, ckg:Represented By, ?c1)"

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as ckg --multi 2 \
--match 'ckg: (C {label: C_label})-[p2:ckgr1]->(c1 {label: pred_label})-[p1:ckgr2]->(:h4c1 {label: type_label})' \
-o /app/kgtk/data/H4/CKG-H4-K1-mK-h4c1.tsv

## K6' => (?id1 (?v1, h4p7, 'Brasil'). ?id2(?v1, h4r2, ?v2). ?id2, h4q3, ?v3. ?id2, h4q4, ?v4. ?id3(?v1, is_a, h4c1). ?id4(?v1, h4r6, ?v5). ?id5(?v1, h4r1, ?v6))

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 7 \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1 {label: v1_label})-[p2:h4r2]->(v2 {label: v2_label}), (p2)-[q3:h4q3]->(v3 {label: v3_label}), (p2)-[q4:h4q4]->(v4 {label: v4_label}), (v1)-[p3:is_a]->(:h4c1 {label: h4c1_label}), (v1)-[p4:h4r6]->(v5 {label: v5_label}), (v1)-[p5:h4r1]->(v6 {label: v6_label})' \
--where 'l2 = "Brasil"' \
-o /app/kgtk/data/H4/CKG-H4-K6-exact.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1 {label: v1_label})-[p2:h4r2]->(v2 {label: v2_label}), (v1)-[p3:is_a]->(:h4c1 {label: h4c1_label})' \
--where 'l2 = "Brasil"' \
--optional 'h4: (p2)-[q3:h4q3]->(v3 {label: v3_label})' \
--optional 'h4: (p2)-[q4:h4q4]->(v4 {label: v4_label})' \
--optional 'h4: (v1)-[p4:h4r6]->(v5 {label: v5_label})' \
--optional 'h4: (v1)-[p5:h4r1]->(v6 {label: v6_label})' \
--return 'DISTINCT 
p1, v1 as node1, v1_label as `node1;label`, p1.label, l2 as node2, ""  as `node2;label`, p2, v1 as node1, v1_label as `node1;label`, p2.label, v2 as node2, v2_label as `node2;label`, p3, v1, v1_label as `node1;label`, p3.label, "h4c1" as node2, h4c1_label as `node2;label`, coalesce(q3, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q3.label, "h4q3") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown")  as `node2;label`, coalesce(q4, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q4.label, "h4q4") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as node2_label, coalesce(p4, "unknown") as id, v1, v1_label as `node1;label`, coalesce(p4.label, "h4r6") as label, coalesce(v5, "unknown") as node2, coalesce(v5_label, "unknown") as `node2;label`, coalesce(p5, "unknown") as id, v1, v1_label as `node1;label`, coalesce(p5.label, "h4r1") as label, coalesce(v6, "unknown") as node2, coalesce(v6_label, "unknown") as `node2;label`' \
-o /app/kgtk/data/H4/CKG-H4-K6-possible.tsv

cut -f 1-6  < CKG-H4-K6-possible.tsv > file1.tsv
cut -f 7-12 < CKG-H4-K6-possible.tsv > file2.tsv
cut -f 13-18 < CKG-H4-K6-possible.tsv > file3.tsv
cut -f 19-24 < CKG-H4-K6-possible.tsv > file4.tsv
cut -f 25-30 < CKG-H4-K6-possible.tsv > file5.tsv
cut -f 31-36 < CKG-H4-K6-possible.tsv > file6.tsv
cut -f 37-42 < CKG-H4-K6-possible.tsv > file7.tsv

kgtk cat -i file1.tsv file2.tsv file3.tsv file4.tsv file5.tsv file6.tsv file7.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K6-possible-multi.tsv

## Regra para o HOJE = Corrente

## Se (?id1(?v1, h4r2, ?v2). (?id1, h4q4, ?v3)) ^ ?v3 = max(?v4) from (?id2(?v1, h4r2, ?v5). (?id2, h4q4, ?v4)) Então (?c1 (?id1, ckgr4, ckgl1). ?c2(ckgT1, ckgr3, ckgl1)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1)-[p2:h4r2]->(), (p2)-[q2:h4q4]->(v2)' \
--return 'max(coalesce(v2, "-1")) as max_date'

export GRAPH_CKG_K6=/app/kgtk/data/H4/CKG-H4-K6-possible-multi.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 -i $GRAPH_CKG_K6 --as k6 --multi 2 --force \
--match 'k6: (v1)-[p2:h4r2]->(), (p2)-[q2:h4q4]->(v2), h4: (ct {label: ct_label})-[c1:ckgr3 {label: ckgr3_label}]->(:ckgl1 {label: ckgl1_label})' \
--where 'v2 = "^1964"' \
--return '"ckg:i1" as id, p2 as node1, "" as `node1;label`, "ckgr4" as label, "ckgl1" as node2, ckgl1_label as `node2;label`, c1 as id, ct as node1, ct_label as  `node1;label`, "ckgr3" as label, "ckgl1" as node2, ckgl1_label as `node2;label`' \
--limit 1 \
-o /app/kgtk/data/H4/CKG-H4-K6-inferred.tsv

kgtk cat -i CKG-H4-K6-possible-multi.tsv CKG-H4-K6-inferred.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K6-possible-final.tsv

## K7 => (?id2 (?v1, h4p7, 'Brasil'). ?id1 (?v1, h4r2, ?v2). ?id1, h4q3, ?v3. ?id1, h4q4, ?v4. ?id3 (?v5, h4r2, ?v6). ?id3, h4q3, ?v7. ?id1, h4q4, ?v8.
##       WHERE check_overlap(?v2, ?v6) AND before(?v4, ?v8) AND ?v1 != ?v5)

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 --multi 7 \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1 {label: v1_label})-[p2:h4r2]->(v2 {label: v2_label}), (p2)-[q3:h4q3]->(v3 {label: v3_label}), (p2)-[q4:h4q4]->(v4 {label: v4_label}), (v5 {label: v5_label})-[p5:h4r2]->(v6 {label: v6_label}), (p5)-[q7:h4q3]->(v7 {label: v7_label}), (p5)-[q8:h4q4]->(v8 {label: v8_label})' \
--where 'l2 = "Brasil" AND v1 != v5 AND v8 < v4' \
-o /app/kgtk/data/H4/CKG-H4-K7-temp-exact.tsv
 
\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  --force \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1 {label: v1_label})-[p2:h4r2]->(v2 {label: v2_label}), (v5 {label: v5_label})-[p5:h4r2]->(v6 {label: v6_label})' \
--where 'l2 = "Brasil" AND v1 != v5' \
--optional 'h4: (p2)-[q3:h4q3]->(v3 {label: v3_label})' \
--optional 'h4: (p2)-[q4:h4q4]->(v4 {label: v4_label})' \
--optional 'h4: (p5)-[q7:h4q3]->(v7 {label: v7_label})' \
--optional 'h4: (p5)-[q8:h4q4]->(v8 {label: v8_label})' \
--with  '*' --where 'kgtk_null_to_empty(v8) < kgtk_null_to_empty(v4)' \
--return 'DISTINCT 
p1, v1, v1_label as `node1;label`, p1.label, l2 as node2, "" as `node2;label`, p2, v1, v1_label as `node1;label`, p2.label, v2 as node2, v2_label as `node2;label`, 
coalesce(q3, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q3.label, "h4q3") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as `node2;label`, coalesce(q4, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q4.label, "h4q4") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as `node2;label`, p5, v5, v5_label as `node1;label`, p5.label, v6 as node2, v6_label as `node2;label`, coalesce(q7, "unknown") as id, p5 as node1, "" as `node1;label`, coalesce(q7.label, "h4q3") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as `node2;label`, coalesce(q8, "unknown") as id, p5 as node1, "" as `node1;label`, coalesce(q8.label, "h4q4") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as `node2;label`' \
-o /app/kgtk/data/H4/CKG-H4-K7-temp-possible.tsv

cut -f 1-6  < CKG-H4-K7-temp-possible.tsv > file1.tsv
cut -f 7-12 < CKG-H4-K7-temp-possible.tsv > file2.tsv
cut -f 13-18 < CKG-H4-K7-temp-possible.tsv > file3.tsv
cut -f 19-24 < CKG-H4-K7-temp-possible.tsv > file4.tsv
cut -f 25-30 < CKG-H4-K7-temp-possible.tsv > file5.tsv
cut -f 31-36 < CKG-H4-K7-temp-possible.tsv > file6.tsv
cut -f 37-42 < CKG-H4-K7-temp-possible.tsv > file7.tsv

kgtk cat -i file1.tsv file2.tsv file3.tsv file4.tsv file5.tsv file6.tsv file7.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K7-temp-possible-multi.tsv

export PYTHONPATH=$PYTHONPATH:/app/kgtk/functions

export GRAPH_CKG_GEO=/app/kgtk/data/H4/CKG-H4-K7-temp-possible-multi.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_GEO --as geo --force --multi 2 \
--import 'geo_functions as g' \
--match 'geo: (:h4v9 {label: h4v9_label})-[r1:h4r2]->(geo1), (v2 {label: v2_label})-[r2:h4r2]->(geo2) ' \
--where 'v2 != "h4v9"' \
--return 'concat("ckg:i7",v2) as id, "h4v9" as node1, h4v9_label as `node1;label`, pycall("g.geo_operation", geo1, geo2) as label, v2 as node2, v2_label as `node2;label`, "ckg:i3" as id, "ckgL1" as node1, "Location" as `node1;label`, "ckgr3" as label, pycall("g.geo_operation", geo1, geo2) as node2, "" as `node2;label`' \
-o /app/kgtk/data/H4/CKG-H4-K7-geo-inferred.tsv

kgtk cat -i /app/kgtk/data/H4/CKG-H4-K7-geo-inferred.tsv /app/kgtk/data/H4/CKG-H4-K7-temp-possible-multi.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K7-possible-final.tsv

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4  --force \
--import 'geo_functions as g' \
--match 'h4: (v1 {label: v1_label})-[p1:h4p7]->(l2), (v1 {label: v1_label})-[p2:h4r2]->(geo1), (v5 {label: v5_label})-[p5:h4r2]->(geo2)' \
--where 'l2 = "Brasil" AND v1 != v5' \
--optional 'h4: (p2)-[q3:h4q3]->(v3 {label: v3_label})' \
--optional 'h4: (p2)-[q4:h4q4]->(v4 {label: v4_label})' \
--optional 'h4: (p5)-[q7:h4q3]->(v7 {label: v7_label})' \
--optional 'h4: (p5)-[q8:h4q4]->(v8 {label: v8_label})' \
--return 'DISTINCT 
p1, v1, v1_label as `node1;label`, p1.label, l2 as node2, "" as `node2;label`, coalesce(q3, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q3.label, "h4q3") as label, coalesce(v3, "unknown") as node2, coalesce(v3_label, "unknown") as `node2;label`, coalesce(q4, "unknown") as id, p2 as node1, "" as `node1;label`, coalesce(q4.label, "h4q4") as label, coalesce(v4, "unknown") as node2, coalesce(v4_label, "unknown") as `node2;label`, coalesce(q7, "unknown") as id, p5 as node1, "" as `node1;label`, coalesce(q7.label, "h4q3") as label, coalesce(v7, "unknown") as node2, coalesce(v7_label, "unknown") as `node2;label`, coalesce(q8, "unknown") as id, p5 as node1, "" as `node1;label`, coalesce(q8.label, "h4q4") as label, coalesce(v8, "unknown") as node2, coalesce(v8_label, "unknown") as `node2;label`, "ckg:i7" as id, v1 as node1, v1_label as `node1;label`, pycall("g.geo_operation", geo1, geo2) as label, v5 as node2, v5_label as `node2;label`, "ckg:i3" as id, "ckgL1" as node1, "Location" as `node1;label`, "ckgr3" as label, pycall("g.geo_operation", geo1, geo2) as node2' \
-o /app/kgtk/data/H4/CKG-H4-K7-geo-possible.tsv

cut -f 1-6  < CKG-H4-K7-geo-possible.tsv > file1.tsv
cut -f 7-12 < CKG-H4-K7-geo-possible.tsv > file2.tsv
cut -f 13-18 < CKG-H4-K7-geo-possible.tsv > file3.tsv
cut -f 19-24 < CKG-H4-K7-geo-possible.tsv > file4.tsv
cut -f 25-30 < CKG-H4-K7-geo-possible.tsv > file5.tsv
cut -f 31-36 < CKG-H4-K7-geo-possible.tsv > file6.tsv
cut -f 37-42 < CKG-H4-K7-geo-possible.tsv > file7.tsv

kgtk cat -i file1.tsv file2.tsv file3.tsv file4.tsv file5.tsv file6.tsv file7.tsv / deduplicate -o /app/kgtk/data/H4/CKG-H4-K7-geo-possible-multi.tsv

