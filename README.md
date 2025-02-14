# Load required libraries
library(ISLR)
library(leaps)
library(ggplot2)

# Part 1: Baseball Hitters Analysis
# Load and prepare data
data(Hitters)
Hitters.new <- na.omit(Hitters)
X <- as.matrix(Hitters.new[,c(-14,-15,-20,-19)])
Y <- as.matrix(Hitters.new[,19])

# Perform variable selection using Mallow's Cp
subset_model <- regsubsets(Y ~ ., data = Hitters.new, nvmax = ncol(X))
subset_summary <- summary(subset_model)

# Find best model using different criteria
best_model_cp <- which.min(subset_summary$cp)
best_model_r2 <- which.max(subset_summary$adjr2)
best_model_bic <- which.min(subset_summary$bic)

# Get variables for each criterion
best_variables_cp <- names(coef(subset_model, best_model_cp))
best_variables_r2 <- names(coef(subset_model, best_model_r2))
best_variables_bic <- names(coef(subset_model, best_model_bic))

# Print results
print("Best variables using Cp:")
print(best_variables_cp)
print("Best variables using adjusted R²:")
print(best_variables_r2)
print("Best variables using BIC:")
print(best_variables_bic)

# Stepwise regression
# Full model
full_model <- lm(Salary ~ ., data = Hitters.new)

# Backward selection
backward_model <- step(full_model, direction = "backward", trace = FALSE)

# Forward selection
null_model <- lm(Salary ~ 1, data = Hitters.new)
forward_model <- step(null_model, scope = formula(full_model), 
                     direction = "forward", trace = FALSE)

# Stepwise selection
stepwise_model <- step(null_model, scope = formula(full_model), 
                      direction = "both", trace = FALSE)

# Print summaries
print("Backward Selection Summary:")
print(summary(backward_model))
print("Forward Selection Summary:")
print(summary(forward_model))
print("Stepwise Selection Summary:")
print(summary(stepwise_model))

# Part 2: Iris PCA Analysis
# Load and prepare Iris data
data(iris)
iris_data <- iris[, 1:4]

# Calculate covariance matrix and eigen decomposition
cov_matrix <- var(iris_data)
eigen_decomp <- eigen(cov_matrix)

# Print eigenvalues and eigenvectors
print("Eigenvalues:")
print(eigen_decomp$values)
print("Eigenvectors:")
print(eigen_decomp$vectors)

# Perform PCA
pca_result <- princomp(iris_data, cor = FALSE)
print("PCA Summary:")
print(summary(pca_result))
print("PCA Loadings:")
print(pca_result$loadings)

# Extract first two principal components
pc1 <- eigen_decomp$vectors[, 1]
pc2 <- eigen_decomp$vectors[, 2]

# Perform scaled PCA
pca_scaled <- princomp(iris_data, cor = TRUE)
print("Scaled PCA Summary:")
print(summary(pca_scaled))

# Create PCA projection
pc_projection <- as.matrix(iris_data) %*% eigen_decomp$vectors[, 1:2]
iris_pca_df <- data.frame(
  PC1 = pc_projection[, 1],
  PC2 = pc_projection[, 2],
  Species = iris$Species
)

# Create PCA plot
pca_plot <- ggplot(iris_pca_df, aes(x = PC1, y = PC2, color = Species)) +
  geom_point(size = 3) +
  labs(title = "PCA Projection of Iris Data",
       x = "PC1",
       y = "PC2") +
  theme_minimal()

# Display plot
print(pca_plot)

# Function for species-specific PCA
perform_pca <- function(species_name) {
  species_data <- iris_data[iris$Species == species_name, ]
  pca_result <- princomp(species_data, cor = FALSE)
  return(summary(pca_result))
}

# Perform PCA for each species
pca_setosa <- perform_pca("setosa")
pca_versicolor <- perform_pca("versicolor")
pca_virginica <- perform_pca("virginica")

# Print species-specific results
print("Setosa PCA Summary:")
print(pca_setosa)
print("Versicolor PCA Summary:")
print(pca_versicolor)
print("Virginica PCA Summary:")
print(pca_virginica)
