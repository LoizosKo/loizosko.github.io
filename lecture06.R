library(tidyverse)
library(cluster)
library(factoextra)

library(psych)
library(corrplot)


# We start with reading the data

SD3 <- readRDS("SD3.RDS")



# Let's quickly review some clustering
#Before constructing the distance metric we need to scale first. Assuming that the weight of each item is the same though, we do not need to scale
distm <- dist(SD3, method = "euclidean")

#now I can plot my graphs
plot(hclust(distm, method = 'single')) #person 26, and 30 are very similar. 
plot(hclust(distm, method = 'complete'))#It gives you some balance. You can distinctly see three groups here.

sd3clust <- hclust(distm, method = 'complete')
sd3clusters <- cutree(sd3clust, k = 3)
#I construct these clusters


averages <- SD3 %>% 
  mutate(cluster = sd3clusters) %>%
  group_by(cluster) %>%
  summarise_all(mean)

elbow_method <- fviz_nbclust(SD3,
                             FUNcluster = kmeans,
                             method = "wss")
elbow_method


# We can now play around with dimensionality reduction

corrplot(cor(SD3), method="number")
#Principal component analysis is valuable when variables are correlated
#we can see that there are some correlation patterns from the data

#principal component analysis code.
pr.out <- prcomp(SD3,
                 scale = TRUE,#divide by sd
                 center = TRUE)#subtracting means
#you need both, dividing by sd and subtracting the means

#If there is (e.g. id or place of birth) data i don't care about, i need to remove them before starting the analysis.

summary(pr.out)
#we always get as many principle components as many variables
#if we look at the **proportion of variance** of each PC (e.g. PC=0.27, this means that it captures almost 30% of the data)
#cumulative proportion, keeps growing and growing until it gets to 1. This helps you see which data to remove (e.g. the ones that explain the least, can be removed)

biplot(pr.out)
#

fviz_eig(pr.out)


fviz_pca_ind(pr.out,
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)

fviz_pca_var(pr.out,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE # Avoid text overlapping
)


fviz_pca_biplot(pr.out, repel = TRUE,
                axes = c(2,3),
                col.var = "#2E9FDF", # Variables color
                col.ind = "#696969" # Individuals color
                )


# We can now do factor analysis

fa.parallel(SD3, n.obs = 200, fa = "fa", fm = "minres")

EFA_model <- fa(SD3, nfactors = 3)
fa.diagram(EFA_model)
EFA_model$loadings
