library(caret)
greenbuildings <- read.csv("https://raw.githubusercontent.com/jgscott/ECO395M/master/data/greenbuildings.csv")
str(greenbuildings)

gbPrice = greenbuildings

# Descriptive Statistics and data Preprocessing
library(skimr)
library(knitr)
skim(greenbuildings) %>% skimr::kable()

# Check Missing Values
sum(is.na(greenbuildings))
table(is.na(greenbuildings))
prop.table(table(is.na(greenbuildings)))
# Only .04% of total data is missing
colMeans(is.na(greenbuildings))
# .937% or the empl_gr data is missing from the dataset

#Check Correlation of empl_gr with other variables to see if it is MAR or MNAR
library(corrr)
library(ggplot2)
library(dplyr)
empl_gr_Check <- greenbuildings %>%
  correlate() %>%
  focus(empl_gr)

empl_gr_Check

empl_gr_Check %>% 
  mutate(rowname = factor(rowname, levels = rowname[order(empl_gr)])) %>%  # Order by correlation strength
  ggplot(aes(x = rowname, y = empl_gr)) +
  geom_bar(stat = "identity") +
  ylab("Correlation with empl_gr") +
  xlab("Variable") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Imputation of missing data for emp_gl using MICE
# Assumption: missing data is MAR and therefore all values that are missing can be explained by the data we already have
# Statistical reasoning: Deleting NA data or simply replacing with the mean or mode can bias our model
# it is unlikely that the missing values are random, and it is correlated with other variables of interest, therefore we can predict the missing values
library(mice)
md.pattern(greenbuildings)
mice_imputes = mice(greenbuildings, m=5, maxit = 50, seed = 100)
mice_imputes$method
mice_imputes

# Red line is imputed data, blue line is original; due to similarity, we can assume that the missing values were MAR
densityplot(mice_imputes)

# Choose final model
gb_impute = complete(mice_imputes,5)
gb_impute

View(gb_impute)

# Check for missing values, and look at summary statistics for the imputed data set
skim(gb_impute) %>% skimr::kable()

# Correlation graphs for the greenbuildings dataset
# Not Necessary, but could be useful for visualization?? 
library(GGally)
ggpairs(data = gb_impute, columns =1:3, title = "Green Buildings Correlation Plot")
ggpairs(data = gb_impute,columns =3:8, title = "Green Buildings Correlation Plot 2")

# Use new data set to check correlation of rent with other variables
rent_Check <- gb_impute %>%
  correlate() %>%
  focus(Rent)

rent_Check

as.matrix(rent_Check)

rent_Check %>% 
  mutate(rowname = factor(rowname, levels = rowname[order(Rent)])) %>%  # Order by correlation strength
  ggplot(aes(x = rowname, y = Rent)) +
  geom_bar(stat = "identity") +
  ylab("Correlation with Rent") +
  xlab("Variable") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#########
# Number of cores
library(foreach)
library(doMC)

# Register Cores
registerDoMC(2)
#########

# Forward Selection Model
gb_lm0 = lm(Rent ~ 1, data= gb_impute)
gb_lm_forward = step(gb_lm0, direction='forward',
                  scope=~(cluster + size + empl_gr + leasing_rate + stories + age + renovated + 
                          class_a + class_b + LEED + Energystar + green_rating + net + amenities +
                          cd_total_07 + hd_total07 + total_dd_07 + Precipitation+ Gas_Costs + Electricity_Costs
                          + cluster_rent)^2)
# AIC_gb_lm_forward = 34768.95

# Step Function
# Create medium model for step function
# Re-run optimal model, includng Green_Certified Variable
gb_lm_full = lm(Rent ~ cluster_rent + age + Electricity_Costs + size + stories +
               class_a + amenities + CS_PropertyID + class_b + hd_total07 + net + 
               Gas_Costs + cluster + empl_gr + Precipitation + green_rating + cd_total_07 + 
               hd_total07 + total_dd_07 + LEED + Energystar + leasing_rate, data=gb_impute)

gb_lm_step = step(gb_lm_full, 
                    scope=~(.)^2)

# AIC_gb_lm_step = 34662.54

# Variables Included in Regression
getCall(gb_lm_step)
coef(gb_lm_step)

# Lasso Model
# Full model
full = lm(Rent ~., data = gb_impute)
full

#Forward Stepwise Procedure
# Null Model
null = lm(Rent~1, data = gb_impute)

system.time(fwd <- step(null, scope = formula(full), dir="forward"))
# AIC_full = 35390.21

system.time(fwd <- step(null, scope = formula(gb_lm_forward), dir="forward"))
# AIC_gb_lm_forward_step = 34768.95

# Load gamlr for LASSO
library(gamlr)

# Create numeric design matrix
gbx = sparse.model.matrix(Rent ~., data = gb_impute)[,-1]

gby = gb_impute$Rent

# Fit single lasso
gb_lasso =  gamlr(gbx, gby)
plot(gb_lasso)

View(gb_lasso)

# AIC selected coef
AICc(gb_lasso)

# AIC_lasso= 35425.42

plot(gb_lasso$lambda, AICc(gb_lasso))
plot(log(gb_lasso$lambda), AICc(gb_lasso))

# Coefficient at AIC-optimizing value
gb_beta = coef(gb_lasso)
gb_beta

# Optimal lambda
log(gb_lasso$lambda[which.min(AICc(gb_lasso))])
sum(gb_beta!=0)

# CV lasso
gb_cvl = cv.gamlr(gbx, gby, verb = TRUE) 

# Plotting OOS deviance as a function of log lambda
plot(gb_cvl, bty="n") 

# CV min deviance Selection
gbb.min = coef(gb_cvl, select="min")
log(gb_cvl$lambda.min)
sum(gbb.min!=0)

# CV 1SE selection
gbb.1se = coef(gb_cvl)
log(gb_cvl$lambda.1se)
sum(gbb.1se!=0)

# Comparing AICc and CV error
plot(gb_cvl, bty="n")
lines(log(gb_lasso$lambda), AICc(gb_lasso)/n, col="green", lwd=2)
legend("top", fill=c("blue","green"),
       legend=c("CV","AICc"), bty="n")
#######

# Anova for model comparison
anova(gb_lm_full, gb_lm_forward, gb_lm_step)

# Compared to the full model, all models findings are statistically significant at any level of significance
# We also find that the gb_lm_step model results not only in the lowest AIC, but also the lowest RSS and therefore is the optimal model 
# Best Performing Model: gb_lm_step
# AIC = 34662.54
# Variables:
getCall(gb_lm_step)

# Check model using Train-Test Split for comparison
set.seed(200)
index <- createDataPartition(gb_impute$Rent, p=.75, list = FALSE)

trainSet <- gb_impute[index,]

testSet <- gb_impute[-index,]

# checking for missing values
skim(trainSet) %>% skimr::kable()

# Normalize and Scale Variables
trainX <- trainSet[,-ncol(trainSet) != "Rent"]
preProcValues <- preProcess(x = trainX, method = c("center", "scale"))
preProcValues

# Training Data for knn
set.seed(200)
ctrl <- trainControl(method="repeatedcv", repeats = 5)
knnFit <- train(Rent ~., data = trainSet, method = "knn", trControl = ctrl, preProcess = c("center", "scale"), tuneLength = 20)

# knnFit output
knnFit

# Plotting knnFit results
plot(knnFit)

# Prediction of model
knnPredict <- predict(knnFit, newdata = testSet)

knnPredict

# KNN model gives an RMSE value of 9.872747 
sqrt(625851/7894)
# The RMSE for the optimal model, gb_lm_step, is 8.904036
# Therefore we can say that this is actually our optimal model as it has the lowest RMSE, and therefore a lower prediction error rate, than the KNN model

# Part 2
coef(gb_lm_step)
# On average, the effect of Green Certified on Rent for class_c buildings, holding all other features fixed, is +2.01 dollars per square foot per calander year

# Part 3
# Re-run optimal model and include an interaction for class_a and class_b buildings with green_rating
gbGR_lm_model = lm(formula = Rent ~ class_a:green_rating + class_b:green_rating + cluster_rent + age + Electricity_Costs + 
    size + stories + class_a + amenities + CS_PropertyID + class_b + 
    hd_total07 + net + Gas_Costs + cluster + empl_gr + Precipitation + 
    green_rating + cd_total_07 + LEED + leasing_rate + cluster_rent:size + 
    size:cluster + cluster_rent:cluster + size:Precipitation + 
    cluster_rent:stories + size:leasing_rate + net:cd_total_07 + 
    stories:class_a + age:class_b + age:class_a + hd_total07:Precipitation + 
    cluster_rent:LEED + stories:amenities + amenities:class_b + 
    cluster_rent:leasing_rate + class_b:Precipitation + size:cd_total_07 + 
    Electricity_Costs:class_b + Gas_Costs:Precipitation + cluster_rent:amenities + 
    amenities:green_rating + CS_PropertyID:hd_total07 + Electricity_Costs:CS_PropertyID + 
    CS_PropertyID:class_b + cluster_rent:age + age:Electricity_Costs + 
    cluster:leasing_rate + hd_total07:cd_total_07 + Electricity_Costs:cluster + 
    hd_total07:cluster + cluster_rent:cd_total_07 + class_a:Precipitation + 
    size:CS_PropertyID + amenities:CS_PropertyID + Electricity_Costs:class_a + 
    CS_PropertyID:empl_gr + amenities:Gas_Costs + amenities:Precipitation + 
    age:cd_total_07 + class_b:empl_gr + cluster_rent:net + stories:cluster + 
    class_a:CS_PropertyID + age:CS_PropertyID + LEED:leasing_rate + 
    class_a:Gas_Costs + class_b:Gas_Costs + CS_PropertyID:Gas_Costs + 
    Electricity_Costs:amenities + stories:cd_total_07 + class_a:empl_gr + 
    Gas_Costs:cluster + cluster:cd_total_07, data = gb_impute)

gbGR_lm_model

# Effect of green rating for class_c buildings
4.696e+00
# For class_c buildings, the effect of having a green_rating on Rent is +4.696 dollars per square foot, holding all else fixed

# Effect of green rating for class_b buildings:
4.696e+00  - 2.485e+00
# For class_b buildings, the effect of having a green_rating on Rent is +2.211 dollars per squarefoot per calander year compared to class_c buildings, holding all else fixed

# Effect of green rating for class_a buildings:
4.696e+00 -2.935e+00 
# For class_a buildings, the effect of having a green_rating on Rent is +1.761 dollars per squarefoot per calander year compared to class_c buildings, holding all else fixed

# By including the interaction between green_rating and building types, we can see that there is a diminishing effect in green_rating as buildng quality increases
library(ggplot2)
library(sjPlot)
library(snakecase)
library(cowplot)
RentPredPlot1 <- plot_model(gbGR_lm_model, type = "pred", terms =c("green_rating")) +
  ggtitle("Predicted Effect on Rent for \nclass_c buildings with green_rating") +
  theme(legend.position = c(0, .8), legend.justification = c(0, .5))
RentPredPlot2 <- plot_model(gbGR_lm_model, type = "pred", terms = c("class_b", "green_rating")) +
  ggtitle("Predicted Effect on Rent for \nclass_b buildings with green_rating") +
  scale_colour_discrete(guide = guide_legend(title = "green_rating")) + 
  scale_fill_discrete(guide = guide_legend(title = "green_rating")) +
  theme(legend.position = c(0, .8), legend.justification = c(0, .5))
RentPredPlot3 <- plot_model(gbGR_lm_model, type = "pred", terms = c("class_a", "green_rating")) +
  ggtitle("Predicted Effect on Rent for \nclass_a buildings with green_rating") +
  scale_colour_discrete(guide = guide_legend(title = "green_rating")) + 
  scale_fill_discrete(guide = guide_legend(title = "green_rating")) +
  theme(legend.position = c(0, .8), legend.justification = c(0, .5))

library(gridExtra)
RentPredPlot1
plot_grid(RentPredPlot2, RentPredPlot3, align = "v", ncol=2, axis = 'l')

# Interactions between class_a and class_b buildings and green ratings have very large confidence intervals and therefore are likely to be a weak/statistically insignificant estimator 
# This is likely why it was not included in the optimal model using the step function



