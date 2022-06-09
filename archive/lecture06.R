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
#screte plot --> we can see that there is a lot of staff captured by the first principle component. There are not three different questions, it does seem that we capture the same thing (i.e. one personality trait)

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
#same thing as the square box with arrows above, just a bit more pretty.

# We can now do factor analysis
fa.parallel(SD3, n.obs = 200, fa = "fa", fm = "minres")#we identify how many factors we have using a screte plot. This code is based on some assumption on what would be the case if questions were asked randomly


EFA_model <- fa(SD3, nfactors = 3)#We will work with the three factors.
fa.diagram(EFA_model)#the results I get from the factor analysis. This is consistent on what we got from PCA.
EFA_model$loadings#exploratory factor analysis

#we drop all the observation that have missing values. Why drop it in order for everything to work.
#another way is to do **multiple impuatations** -- make predictions what the person would have said to the question given some other characteristics.

#confirmatory factor analysis = develop the questions and match everything/ test if everything makes sense 