# Inferred Context

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1)-[p1]->(), (p1)-[q1:h4q1]->(v2) ' \
--where 'NOT EXISTS {(p1)-[q2:h4q2]->(v3)}' \
--return '"ckg:i1" as id, p1 as node1, "ckgr4" as label, "ckgl1" as node2

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CKG_H4 --as h4 \
--match 'h4: (v1)-[p1]->(), (p1)-[q1:h4q4]->(v2)' \
--return 'v1, p1.label, max(coalesce(v2, "-1")) as max_date'

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $CONT_ANSWERS --as ca \
--match 'h4: (v1)-[p1]->(), (p1)-[q1:h4q4]->(v2)' \
--where 'v2 = $max_date ' --para max_date="^1964" \
--return '"ckg:i1" as id, p1 as node1, "ckgr4" as label, "ckgl1" as node2

