import pandas as pd
import os
import graphviz

def kgtk2gviz_all (node, query, question, path):

    dir = "/app/kgtk/data/WD_PoC/Examples/"
    g_name = node +"-"+ query
    f_name=dir+'graphical/'+g_name+'.gv'
    e = graphviz.Graph(g_name, strict=True, engine='dot', filename='graphical/'+g_name+'.gv')
    e.attr(label=question)
    e.attr(fontsize='20')

    for file in os.listdir(dir):
        if query in file and node in file and ((path=="No" and "path" not in file) or (path=="Yes" and "path" in file)):
            name = os.path.join(dir, file)
            kgtk = pd.read_table(name, sep='\t')
            cols = list(kgtk.columns)
            for i in kgtk.index:    
                
                e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                e.node(kgtk["id"][i].replace(":", "_"), label= "")           
                                    
                if pd.isna(kgtk["node1;label"][i]):
                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["node1"][i].replace(":", "_"), label= "")
                else:
                    e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                    e.node(kgtk["node1"][i].replace(":", "_"), label= kgtk["node1;label"][i])

                if pd.isna(kgtk["node2;label"][i]):
                    e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                    e.node(kgtk["id"][i]+kgtk["node2"][i].replace(":", "_"), label= kgtk["node2"][i])	
                else:
                    e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                    e.node(kgtk["node2"][i].replace(":", "_"), label= kgtk["node2;label"][i])
                
                e.attr('edge', fontsize='10')
                e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')

                if "id" in cols:      
                    e.edge(kgtk["node1"][i].replace(":", "_"), kgtk["id"][i].replace(":", "_"), label= kgtk["label"][i])
                    if pd.isna(kgtk["node2;label"][i]):
                        e.edge(kgtk["id"][i].replace(":", "_"), kgtk["id"][i]+kgtk["node2"][i].replace(":", "_"), label= kgtk["label;label"][i])
                    else: 
                        e.edge(kgtk["id"][i].replace(":", "_"), kgtk["node2"][i].replace(":", "_"), label= kgtk["label;label"][i])
                else:
                    e.edge(kgtk["node1"][i].replace(":", "_"), kgtk["node2"][i].replace(":", "_"), label= kgtk["label"][i])
                    
                if "id.1" in cols and not pd.isna(kgtk["id.1"][i]):
                
                    if pd.isna(kgtk["node1;label.1"][i]):
                        e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                        e.node(kgtk["node1.1"][i].replace(":", "_"), label= "")
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node1.1"][i].replace(":", "_"), label= kgtk["node1;label.1"][i])

                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["id.1"][i].replace(":", "_"), label= "")
                                
                    if pd.isna(kgtk["node2;label.1"][i]):
                        e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                        e.node(kgtk["id.1"][i]+kgtk["node2.1"][i].replace(":", "_"), label= kgtk["node2.1"][i])	
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node2.1"][i].replace(":", "_"), label= kgtk["node2;label.1"][i].replace(":", "_"))
                            
                    e.edge(kgtk["node1.1"][i].replace(":", "_"), kgtk["id.1"][i].replace(":", "_"), label= kgtk["label.1"][i], color="navyblue")
                    if pd.isna(kgtk["node2;label.1"][i]):
                        e.edge(kgtk["id.1"][i].replace(":", "_"), kgtk["id.1"][i]+kgtk["node2.1"][i].replace(":", "_"), label= kgtk["label;label.1"][i], color="navyblue")
                    else:
                        e.edge(kgtk["id.1"][i].replace(":", "_"), kgtk["node2.1"][i].replace(":", "_"), label= kgtk["label;label.1"][i], color="navyblue")
                            
                if "id.2" in cols and not pd.isna(kgtk["id.2"][i]):
                                        
                    if pd.isna(kgtk["node1;label.2"][i]):
                        e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                        e.node(kgtk["node1.2"][i].replace(":", "_"), label= "")
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node1.2"][i].replace(":", "_"), label= kgtk["node1;label.2"][i])

                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["id.2"][i].replace(":", "_"), label= "")
                            
                    if pd.isna(kgtk["node2;label.2"][i]):
                        e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                        e.node(kgtk["id.2"][i]+kgtk["node2.2"][i].replace(":", "_"), label= kgtk["node2.2"][i])	
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node2.2"][i].replace(":", "_"), label= kgtk["node2;label.2"][i])
                            
                    e.edge(kgtk["node1.2"][i].replace(":", "_"), kgtk["id.2"][i].replace(":", "_"), label= kgtk["label.2"][i])
                    if pd.isna(kgtk["node2;label.2"][i]):
                        e.edge(kgtk["id.2"][i].replace(":", "_"), kgtk["id.2"][i]+kgtk["node2.2"][i].replace(":", "_"), label= kgtk["label;label.2"][i])
                    else:
                        e.edge(kgtk["id.2"][i].replace(":", "_"), kgtk["node2.2"][i].replace(":", "_"), label= kgtk["label;label.2"][i])            

    print(e.source)
    try:
        e.view()
    except Exception:
        pass

    print('File generated? ', os.path.isfile(f_name))

def kgtk2gviz ():

    dir = "/app/kgtk/data/WD_PoC/Examples/"

    for file in os.listdir(dir):
        if 'tsv' in file and not 'gv' in file:
            g_name = file
            f_name = dir+g_name+'.gv' 
            e = graphviz.Graph(g_name, strict=True, engine='dot', filename=f_name)
            e.attr(fontsize='20')

            print(file)

            name = os.path.join(dir, file)
            kgtk = pd.read_table(name, sep='\t')
            cols = list(kgtk.columns)

            for i in kgtk.index:
                           
                if not pd.isna(kgtk["node1;label"][i]):
                    e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black") 
                    e.node(kgtk["node1"][i].replace(":", "_"), label= kgtk["node1"][i].replace(":", "_")+": "+kgtk["node1;label"][i])
                else:
                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["node1"][i].replace(":", "_"), label= "")
                    
                if "node2;label" in cols:
                    if pd.isna(kgtk["node2;label"][i]):
                        e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                        e.node(kgtk["id"][i]+kgtk["node2"][i].replace(":", "_"), label= kgtk["node2"][i])	
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black") 
                        e.node(kgtk["node2"][i].replace(":", "_"), label= kgtk["node2"][i].replace(":", "_")+": "+kgtk["node2;label"][i])
                    
                e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                if "id" in cols:
                    e.node(kgtk["id"][i].replace(":", "_"), label= "")
                
                e.attr('edge', fontsize='10')
                if "id" in cols:      
                    e.edge(kgtk["node1"][i].replace(":", "_"), kgtk["id"][i].replace(":", "_"), label= kgtk["label"][i])
                    if pd.isna(kgtk["node2;label"][i]):
                        e.edge(kgtk["id"][i].replace(":", "_"), kgtk["id"][i]+kgtk["node2"][i].replace(":", "_"), label= kgtk["label;label"][i])
                    else: 
                        e.edge(kgtk["id"][i].replace(":", "_"), kgtk["node2"][i].replace(":", "_"), label= kgtk["label;label"][i])
                else:
                    e.edge(kgtk["node1"][i].replace(":", "_"), kgtk["node2"][i].replace(":", "_"), label= kgtk["label"][i])
                    
                if "id.1" in cols and not pd.isna(kgtk["id.1"][i]):
                
                    if pd.isna(kgtk["node1;label.1"][i]):
                        e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                        e.node(kgtk["node1.1"][i].replace(":", "_"), label= "")
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node1.1"][i].replace(":", "_"), label= kgtk["node1.1"][i].replace(":", "_")+": "+kgtk["node1;label.1"][i])

                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["id.1"][i].replace(":", "_"), label= "")
                                
                    if pd.isna(kgtk["node2;label.1"][i]):
                        e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                        e.node(kgtk["id.1"][i]+kgtk["node2.1"][i].replace(":", "_"), label= kgtk["node2.1"][i])	
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node2.1"][i].replace(":", "_"), label= kgtk["node2.1"][i].replace(":", "_")+": "+kgtk["node2;label.1"][i].replace(":", "_"))
                            
                    e.edge(kgtk["node1.1"][i].replace(":", "_"), kgtk["id.1"][i].replace(":", "_"), label= kgtk["label.1"][i], color="navyblue")
                    if pd.isna(kgtk["node2;label.1"][i]):
                        e.edge(kgtk["id.1"][i].replace(":", "_"), kgtk["id.1"][i]+kgtk["node2.1"][i].replace(":", "_"), label= kgtk["label;label.1"][i], color="navyblue")
                    else:
                        e.edge(kgtk["id.1"][i].replace(":", "_"), kgtk["node2.1"][i].replace(":", "_"), label= kgtk["label;label.1"][i], color="navyblue")
                            
                if "id.2" in cols and not pd.isna(kgtk["id.2"][i]):
                                        
                    if pd.isna(kgtk["node1;label.2"][i]):
                        e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                        e.node(kgtk["node1.2"][i].replace(":", "_"), label= "")
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node1.2"][i].replace(":", "_"), label= kgtk["node1.2"][i].replace(":", "_")+": "+kgtk["node1;label.2"][i])

                    e.attr('node', shape='point', fontsize='10', color= 'orange', style= 'filled')
                    e.node(kgtk["id.2"][i].replace(":", "_"), label= "")
                            
                    if pd.isna(kgtk["node2;label.2"][i]):
                        e.attr('node', shape='plain', fontsize='10', color= '', style= '', fontcolor = "forestgreen")
                        e.node(kgtk["id.2"][i]+kgtk["node2.2"][i].replace(":", "_"), label= kgtk["node2.2"][i])	
                    else:
                        e.attr('node', shape='ellipse', fontsize='10', color= '', style= '', fontcolor = "black")
                        e.node(kgtk["node2.2"][i].replace(":", "_"), label= kgtk["node2.2"][i].replace(":", "_")+": "+kgtk["node2;label.2"][i])
                            
                    e.edge(kgtk["node1.2"][i].replace(":", "_"), kgtk["id.2"][i].replace(":", "_"), label= kgtk["label.2"][i])
                    if pd.isna(kgtk["node2;label.2"][i]):
                        e.edge(kgtk["id.2"][i].replace(":", "_"), kgtk["id.2"][i]+kgtk["node2.2"][i].replace(":", "_"), label= kgtk["label;label.2"][i])
                    else:
                        e.edge(kgtk["id.2"][i].replace(":", "_"), kgtk["node2.2"][i].replace(":", "_"), label= kgtk["label;label.2"][i])            

            try:
                e.view()
            except Exception:
                pass

            print('File generated? ', os.path.isfile(f_name))


option = input("[Examples] or All or One:") or "Examples"

if option == "Examples": kgtk2gviz ()


if option == "One":
    question = input("Please enter K-id question:") or r'\n\nGeo-political changes over time'
    node = input("Please enter a QNode[q96]:") or "q96"
    query = input("Please enter a K-id[K0]:") or "K0"
    path = input("Please enter a path option[No]/Yes:") or "No"

    kgtk2gviz_all (node, query, question, path)

if option == "All":
    path = "No"

    qdict =	{
      "K0": "How country_oficial_name is shaped (spatial) today ?",
      "K1": "Geo-political changes of country_oficial_name over time",
      "K2": "When country_oficial_name was established?", 
      "K3": "Capital cities of country_alias?",
      "K4": "What position does the main administrative leader occupy in country_alias and who were these leaders?",
      "K5": "What is the government regime in country_alias?",
      "K6": "What languages ​​are spoken in country_alias?"
    }

    clist = ["q155", "q96", "q183", "q16", "q408", "q77"]

    for node in clist:
        for query, question in qdict.items():
            kgtk2gviz_all (node, query, question, path)

