printf "Claims e Qualificações da WD - Junho 2022\n" > /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "INICIO Current date %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

export GRAPH_ALIAS=/app/kgtk/data/wikidata/alias.en.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_QUALS=/app/kgtk/data/wikidata/qualifiers.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_CLAIMS=/app/kgtk/data/wikidata/claims.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1
export GRAPH_LABEL=/app/kgtk/data/wikidata/labels.en.tsv.gz >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.0 Preparar ambiente %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_ALIAS --as alias --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_QUALS --as quals --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_CLAIMS --as c --index none --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query -i $GRAPH_LABEL --as lab --limit 3 >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 
\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "WD1.1 Filtrar CLAIMS para o conjunto completo com os tipos de interesse %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab --force \
--match 'c: (item)-[:P31]->(:Q859563), (item)-[p1]->(p_val), lab: (pred)-[]->(pred_label), lab: (item)-[]->(item_label)' \
--where 'p1.label = pred' \
--optional 'lab: (p_val)-[]->(val_label)' \
--order-by 'item_label, p1.label, val_label' \
--return 'p1 as id, item as node1, item_label as `node1;label`, pred as label, pred_label as `label;label`, p_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/secular_state-claims.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab --force \
--match 'c: (item)-[:P31]->(:Q512187), (item)-[p1]->(p_val), lab: (pred)-[]->(pred_label), lab: (item)-[]->(item_label)' \
--where 'p1.label = pred' \
--optional 'lab: (p_val)-[]->(val_label)' \
--order-by 'item_label, p1.label, val_label' \
--return 'p1 as id, item as node1, item_label as `node1;label`, pred as label, pred_label as `label;label`, p_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/federal_republic-claims.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab --force \
--match 'c: (item)-[:P31]->(:Q6256), (item)-[p1]->(p_val), lab: (pred)-[]->(pred_label), lab: (item)-[]->(item_label)' \
--where 'p1.label = pred' \
--optional 'lab: (p_val)-[]->(val_label)' \
--order-by 'item_label, p1.label, val_label' \
--return 'p1 as id, item as node1, item_label as `node1;label`, pred as label, pred_label as `label;label`, p_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/countries-claims.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.2 Contar Predicados do conjunto filtrado %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/secular_state-claims.tsv --columns label \
--output-file /app/kgtk/data/WD_PoC/secular_state-pred-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/secular_state-pred-counted.tsv --as p -i $GRAPH_LABEL --as lab \
--match 'p: (pred)-[]->(cp)' \
--opt 'lab: (pred)-[]->(pred_name)' \
--order-by 'cast(cp, integer) desc' \
--return 'pred as node1, pred_name as `node1;label`, "count" as label, cast(cp, integer) as node2' \
-o /app/kgtk/data/WD_PoC/secular_state-pred-label-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/federal_republic-claims.tsv --columns label \
--output-file /app/kgtk/data/WD_PoC/federal_republic-pred-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/federal_republic-pred-counted.tsv --as p -i $GRAPH_LABEL --as lab \
--match 'p: (pred)-[]->(cp)' \
--opt 'lab: (pred)-[]->(pred_name)' \
--order-by 'cast(cp, integer) desc' \
--return 'pred as node1, pred_name as `node1;label`, "count" as label, cast(cp, integer) as node2' \
-o /app/kgtk/data/WD_PoC/federal_republic-pred-label-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/countries-claims.tsv --columns label \
--output-file /app/kgtk/data/WD_PoC/countries-pred-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/countries-pred-counted.tsv --as p -i $GRAPH_LABEL --as lab \
--match 'p: (pred)-[]->(cp)' \
--opt 'lab: (pred)-[]->(pred_name)' \
--order-by 'cast(cp, integer) desc' \
--return 'pred as node1, pred_name as `node1;label`, "count" as label, cast(cp, integer) as node2' \
-o /app/kgtk/data/WD_PoC/countries-pred-label-counted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.3 Contar QNodes do conjunto filtrado %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/secular_state-claims.tsv --column node1 \
/ sort -c node2 --numeric-column node2 --reverse-column node2 -o /app/kgtk/data/WD_PoC/secular_state-node1-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/federal_republic-claims.tsv --column node1 \
/ sort -c node2 --numeric-column node2 --reverse-column node2 -o /app/kgtk/data/WD_PoC/federal_republic-node1-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug unique -i /app/kgtk/data/WD_PoC/countries-claims.tsv --column node1 \
/ sort -c node2 --numeric-column node2 --reverse-column node2 -o /app/kgtk/data/WD_PoC/countries-node1-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.4 Obter Qualificações dos Conjuntos de interesse %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/secular_state-claims.tsv --as f -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'f: ()-[p1]->(), quals: (p1)-[q1]->(q_val), lab: (quali)-[]->(quali_label)' \
--where 'q1.label = quali' \
--optional 'lab: (q_val)-[]->(val_label)' \
--order-by 'p1, q1.label, val_label' \
--return 'q1 as id, p1 as node1, "" as `node1;label`, quali as label, quali_label as `label;label`, q_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/secular_state-quals.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/federal_republic-claims.tsv --as f -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'f: ()-[p1]->(), quals: (p1)-[q1]->(q_val), lab: (quali)-[]->(quali_label)' \
--where 'q1.label = quali' \
--optional 'lab: (q_val)-[]->(val_label)' \
--order-by 'p1, q1.label, val_label' \
--return 'q1 as id, p1 as node1, "" as `node1;label`, quali as label, quali_label as `label;label`, q_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/federal_republic-quals.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i /app/kgtk/data/WD_PoC/countries-claims.tsv --as f -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'f: ()-[p1]->(), quals: (p1)-[q1]->(q_val), lab: (quali)-[]->(quali_label)' \
--where 'q1.label = quali' \
--optional 'lab: (q_val)-[]->(val_label)' \
--order-by 'p1, q1.label, val_label' \
--return 'q1 as id, p1 as node1, "" as `node1;label`, quali as label, quali_label as `label;label`, q_val as node2, val_label as `node2;label`' \
-o /app/kgtk/data/WD_PoC/countries-quals.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

printf "WD1.5 Contar Qualificadores do conjunto filtrado %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'c: ()-[:P31]->(:Q859563), ()-[p1]->(), quals: (p1)-[q1]->(), lab: (quali)-[]->(quali_label), lab: (pred)-[]->(pred_label)' \
--where 'q1.label = quali and p1.label = pred' \
--order-by 'p1.label, q1.label' \
--return 'q1.label as node1, quali_label as `node1;label`, p1.label as `node1;pred`, pred_label as `node1;pred_label`, "count" as label, count(q1.label) as node2' \
-o /app/kgtk/data/WD_PoC/secular_state-qual-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'c: ()-[:P31]->(:Q512187), ()-[p1]->(), quals: (p1)-[q1]->(), lab: (quali)-[]->(quali_label), lab: (pred)-[]->(pred_label)' \
--where 'q1.label = quali and p1.label = pred' \
--order-by 'p1.label, q1.label' \
--return 'q1.label as node1, quali_label as `node1;label`, p1.label as `node1;pred`, pred_label as `node1;pred_label`, "count" as label, count(q1.label) as node2' \
-o /app/kgtk/data/WD_PoC/federal_republic-qual-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk --debug query -i $GRAPH_CLAIMS --as c --index none -i $GRAPH_LABEL --as lab -i $GRAPH_QUALS --as quals --force \
--match 'c: ()-[:P31]->(:Q6256), ()-[p1]->(), quals: (p1)-[q1]->(), lab: (quali)-[]->(quali_label), lab: (pred)-[]->(pred_label)' \
--where 'q1.label = quali and p1.label = pred' \
--order-by 'p1.label, q1.label' \
--return 'q1.label as node1, quali_label as `node1;label`, p1.label as `node1;pred`, pred_label as `node1;pred_label`, "count" as label, count(q1.label) as node2' \
-o /app/kgtk/data/WD_PoC/countries-qual-count-sorted.tsv >> /home/cloud-di/kgtk_WD_PoC.log 2>&1

\time --format='Elapsed time: %e seconds'  kgtk query --show-cache >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

printf "FIM Current date %s\n" "$(date)" >> /home/cloud-di/kgtk_WD_PoC.log 2>&1 

