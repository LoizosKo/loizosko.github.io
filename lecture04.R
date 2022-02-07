# Lecture 04.

# We will be using the data available here:
# https://github.com/OutlierAI/datadrivendaily

install.packages("ggdendro")
install.packages("factoextra")
install.packages("dendextend")

library(tidyverse)
library(readr)
library(factoextra)
library(ggdendro)
library(dendextend)



sales_data <- read_csv("sales_data.csv")

## HIERARCHICAL CLUSTERING

#1. scale the data
sales_data2 <- scale(sales_data) #command 'scale' helps us standardize the data

#2. calculate the distances
distm <- dist(sales_data2) # This function calculates distances between variables

#3. do hierarchical clustering
hc <- hclust(distm) #n(n-1)/2 = distances calculated
plot(hc)
ggdendrogram(hc, rotate = TRUE) #this command helps the previous dendrogram to look better


# Three different ways to construct hierarchical clustering
plot(hclust(dist(sales_data), method = 'single')) #single linkage
plot(hclust(dist(sales_data), method = 'average')) #average linkage
plot(hclust(dist(sales_data), method = 'complete')) #complete linkage. This is the most balanced one hence the most frequently used

# We can record clusters using this function:
clustering <- hclust(dist(scale(sales_data2)), method = 'complete')
cutree(clustering, k = 3) #the command to identify clusters. k=3 means that wwe ask for three clusters. There are as many 1s at cluster one, there are as many 2s at cluster two, there are as many 3s at cluster three.

#hierarchical clustering gives us the options of the clusters existing and we decide how many we want.

# There are also better ways to visualize the data:
dend <- as.dendrogram(clustering)
plot(dend)
dend <- color_branches(dend, k = 3)
plot(dend)

# We can get an idea of what the differences between clusters are using the following code:
sales_data %>% mutate(cluster = cutree(clustering, k = 3)) %>% 
  group_by(cluster) %>% 
  summarise_all(funs(mean(.,  na.rm = T))) #na.rm = T --> if there are missing values remove them.

#young cluster is 1, average cluster is 2, oldest cluster is 3. The cluster 2 makes the most purchases.


## K-MEANS CLUSTERING

kmeansclustering <- kmeans(drop_na(sales_data), 
                           centers = 3)
kmeansclustering_2 <- kmeans(scale(sales_data), 
                             centers = 3, #you specified the number of centers (number of stars)
                             iter.max = 15, #maximum number of iteration is 15. You are allowed to do it 15 times, after that just stop and give the result
                             nstart = 25) #repeat the experiment 25 times and choose the average of the 25 time result.


# How to determine the optimal number of clusters:

elbow_method <- fviz_nbclust(scale(sales_data), 
                             FUNcluster = kmeans, 
                             method = "wss")
elbow_method #the elbow graph. We did clustering with differnt number of clusters. For 1 class the average distance is around 120. If I create a second class, the average distance drops to around 60 (people are in different clusters now)
#the most clusters I create, the average number falls. We see a great improvement until 4 to 5 clusters. That seems the ideal. After that, the improvements are minor.

silhouette_method <- fviz_nbclust(scale(sales_data), 
                                  FUNcluster = kmeans, 
                                  method = "silhouette")
silhouette_method #This method is similar to elbow method except right now is based on silhouettes.
#Now we find the distances between objects of the same class
#We want the silhouette clust to be as large as possible. By default we higlight the highest number. Here we stop again at 4 or 5 clusters as after that there are not a lot of improvements so there is no sense of doing it.






