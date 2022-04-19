
library(readr)
library(tidyverse)


edge_data <- read_csv("edge_data.csv")

edgelist <- edge_data %>% select(Out_tie, In_tie, tie_type)
nodelist <- edge_data %>% select(Out_tie, introvert) %>% distinct()

library(igraph)

newnetwork <- graph_from_data_frame(d = edgelist,
                                    vertices = nodelist,
                                    directed = TRUE)


plot(newnetwork,
     edge.arrow.size = 0.1,
     vertex.size = 3,
     vertex.label = NA)


V(newnetwork)$color <- V(newnetwork)$introvert

plot(newnetwork,
     edge.arrow.size = 0.1,
     vertex.size = 3,
     vertex.label = NA)

edgelist1 <- edgelist %>% filter(tie_type == 3)
newnetwork1 <- graph_from_data_frame(d = edgelist1,
                                    vertices = nodelist,
                                    directed = TRUE)
plot(newnetwork1,
     edge.arrow.size = 0.1,
     vertex.size = 3,
     vertex.label = NA)

# Let's do some descriptive stats
edge_density(newnetwork, loops=F)

# We can confirm that directly
ecount(newnetwork)/(vcount(newnetwork)*(vcount(newnetwork)-1))

reciprocity(newnetwork)
transitivity(newnetwork, type="global")
diameter(newnetwork, directed=F, weights=NA)

deg <- degree(newnetwork, mode="all")
mean(deg)
plot(newnetwork, vertex.size=deg/10, edge.arrow.size = 0.1)
hist(deg, breaks = 20, main="Histogram of node degree")


deg.dist <- degree_distribution(newnetwork, cumulative=T, mode="all")
plot( x=0:max(deg), y=1-deg.dist, pch=19, cex=1.2, col="orange", xlab="Degree", ylab="Cumulative Frequency")


degree(newnetwork, mode="in")
centr_degree(newnetwork, mode="in", normalized=T)


closeness(newnetwork, mode="all", weights=NA)

betweenness(newnetwork, directed=T, weights=NA)


mean_distance(newnetwork, directed=T)
distances(newnetwork, weights=NA)



ceb <- cluster_edge_betweenness(newnetwork)
dendPlot(ceb, mode="hclust")
plot(ceb, newnetwork, vertex.size = 3, edge.arrow.size = 0.2)



clp <- cluster_label_prop(newnetwork)
plot(clp, newnetwork, newnetwork, vertex.size = 3, edge.arrow.size = 0.2)

