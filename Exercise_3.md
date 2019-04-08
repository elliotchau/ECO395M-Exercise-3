Exercise 3
================

By Hana Krijestorac, David Garrett, and Elliot Chau

Problem 1
=========

Model selection and regularization: green buildlings
----------------------------------------------------

Before buildling the best predictive model, we noticed that there were missing observations in the data set. We elected to analyze possible corrections before proceeding with the model buildling process. Below is a table of basic summary statistics of the greenbuildlings data.
  


|   variable    | missing | complete |  n   |   mean    |    sd     |  p0  |   p25    |  p50   |   p75    |  p100   |   hist   |
|---------------|---------|----------|------|-----------|-----------|------|----------|--------|----------|---------|----------|
|      age      |    0    |   7894   | 7894 |   47.24   |   32.19   |  0   |    23    |   34   |    79    |   187   | ▆▇▂▃▂▁▁▁ |
|   amenities   |    0    |   7894   | 7894 |   0.53    |    0.5    |  0   |    0     |   1    |    1     |    1    | ▇▁▁▁▁▁▁▇ |
|  cd_total_07  |    0    |   7894   | 7894 |  1229.35  |  1104.59  |  39  |   684    |  966   |   1620   |  5240   | ▇▆▂▁▂▁▁▁ |
|    class_a    |    0    |   7894   | 7894 |    0.4    |   0.49    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▅ |
|    class_b    |    0    |   7894   | 7894 |   0.46    |    0.5    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▇ |
|    cluster    |    0    |   7894   | 7894 |  588.62   |  399.91   |  1   |   272    |  476   |   1044   |  1230   | ▅▇▇▇▁▁▆▇ |
| CS_PropertyID |    0    |   7894   | 7894 | 453002.52 | 743405.31 |  1   |  157452  | 313253 | 441188.5 | 6208103 | ▇▁▁▁▁▁▁▁ |
|  Energystar   |    0    |   7894   | 7894 |   0.081   |   0.27    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
| green_rating  |    0    |   7894   | 7894 |   0.087   |   0.28    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|  hd_total07   |    0    |   7894   | 7894 |  3432.04  |  1976.94  |  0   |   1419   |  2739  |   4796   |  7200   | ▁▇▂▃▂▃▅▂ |
|     LEED      |    0    |   7894   | 7894 |  0.0068   |   0.082   |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|      net      |    0    |   7894   | 7894 |   0.035   |   0.18    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|   renovated   |    0    |   7894   | 7894 |   0.38    |   0.49    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▅ |
|     size      |    0    |   7894   | 7894 | 234637.74 |   3e+05   | 1624 | 50891.25 | 128838 |  294212  | 3781045 | ▇▁▁▁▁▁▁▁ |
|    stories    |    0    |   7894   | 7894 |   13.58   |   12.29   |  1   |    4     |   10   |    19    |   110   | ▇▂▁▁▁▁▁▁ |
|  total_dd_07  |    0    |   7894   | 7894 |  4661.4   |  1984.33  | 2103 |   2869   |  4979  |   6413   |  8244   | ▇▁▁▃▂▂▃▁ |


|     variable      | missing | complete |  n   | mean  |   sd   |   p0   |  p25  |  p50  |  p75  | p100  |   hist   |
|-------------------|---------|----------|------|-------|--------|--------|-------|-------|-------|-------|----------|
|   cluster_rent    |    0    |   7894   | 7894 | 27.5  |  10.6  |   9    |  20   | 25.14 |  34   | 71.44 | ▂▇▅▅▂▁▁▁ |
| Electricity_Costs |    0    |   7894   | 7894 | 0.031 | 0.0085 | 0.018  | 0.023 | 0.033 | 0.038 | 0.063 | ▆▃▂▇▁▁▁▁ |
|      empl_gr      |   74    |   7820   | 7894 | 3.21  |  8.16  | -24.95 | 1.74  | 1.97  | 2.38  | 67.78 | ▁▁▇▁▁▁▁▁ |
|     Gas_Costs     |    0    |   7894   | 7894 | 0.011 | 0.0024 | 0.0095 | 0.01  | 0.01  | 0.012 | 0.029 | ▇▂▁▁▁▁▁▁ |
|   leasing_rate    |    0    |   7894   | 7894 | 82.61 | 21.38  |   0    | 77.85 | 89.53 | 96.44 |  100  | ▁▁▁▁▁▁▃▇ |
|   Precipitation   |    0    |   7894   | 7894 | 31.08 | 11.58  | 10.46  | 22.71 | 23.16 | 43.89 | 58.02 | ▁▁▇▁▁▃▂▁ |
|       Rent        |    0    |   7894   | 7894 | 28.42 | 15.08  |  2.98  | 19.5  | 25.16 | 34.18 |  250  | ▇▂▁▁▁▁▁▁ |


Because empl_gr (employer growth) had 74 missing observations, we then decided to take a look at which variables were positively or negatively correlated with empl_gr.

![image](https://user-images.githubusercontent.com/47119252/55695009-40d49080-597c-11e9-934e-da8d708fe3c0.png)

We then impute the missing data. We assume that the missing data is missing-at-random (MAR), and therefore all values that are missing can be explained by the data we already have. Deleting NA data or simply replacing them with the mean or mode can bias our model. It is unlikely that the missing values are random, and it is correlated with other variables of interest; therefore, we can predict the missing values.

![image](https://user-images.githubusercontent.com/47119252/55695148-da9c3d80-597c-11e9-99b9-f6d286aad6c9.png)

The red line is imputed data, and the blue line is the original. Due to the similarity, we can assume that the missing values were MAR.

Below is a table of summary statistics for the corrected data set.

|   variable    | missing | complete |  n   |   mean    |    sd     |  p0  |   p25    |  p50   |   p75    |  p100   |   hist   |
|---------------|---------|----------|------|-----------|-----------|------|----------|--------|----------|---------|----------|
|      age      |    0    |   7894   | 7894 |   47.24   |   32.19   |  0   |    23    |   34   |    79    |   187   | ▆▇▂▃▂▁▁▁ |
|   amenities   |    0    |   7894   | 7894 |   0.53    |    0.5    |  0   |    0     |   1    |    1     |    1    | ▇▁▁▁▁▁▁▇ |
|  cd_total_07  |    0    |   7894   | 7894 |  1229.35  |  1104.59  |  39  |   684    |  966   |   1620   |  5240   | ▇▆▂▁▂▁▁▁ |
|    class_a    |    0    |   7894   | 7894 |    0.4    |   0.49    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▅ |
|    class_b    |    0    |   7894   | 7894 |   0.46    |    0.5    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▇ |
|    cluster    |    0    |   7894   | 7894 |  588.62   |  399.91   |  1   |   272    |  476   |   1044   |  1230   | ▅▇▇▇▁▁▆▇ |
| CS_PropertyID |    0    |   7894   | 7894 | 453002.52 | 743405.31 |  1   |  157452  | 313253 | 441188.5 | 6208103 | ▇▁▁▁▁▁▁▁ |
|  Energystar   |    0    |   7894   | 7894 |   0.081   |   0.27    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
| green_rating  |    0    |   7894   | 7894 |   0.087   |   0.28    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|  hd_total07   |    0    |   7894   | 7894 |  3432.04  |  1976.94  |  0   |   1419   |  2739  |   4796   |  7200   | ▁▇▂▃▂▃▅▂ |
|     LEED      |    0    |   7894   | 7894 |  0.0068   |   0.082   |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|      net      |    0    |   7894   | 7894 |   0.035   |   0.18    |  0   |    0     |   0    |    0     |    1    | ▇▁▁▁▁▁▁▁ |
|   renovated   |    0    |   7894   | 7894 |   0.38    |   0.49    |  0   |    0     |   0    |    1     |    1    | ▇▁▁▁▁▁▁▅ |
|     size      |    0    |   7894   | 7894 | 234637.74 |   3e+05   | 1624 | 50891.25 | 128838 |  294212  | 3781045 | ▇▁▁▁▁▁▁▁ |
|    stories    |    0    |   7894   | 7894 |   13.58   |   12.29   |  1   |    4     |   10   |    19    |   110   | ▇▂▁▁▁▁▁▁ |
|  total_dd_07  |    0    |   7894   | 7894 |  4661.4   |  1984.33  | 2103 |   2869   |  4979  |   6413   |  8244   | ▇▁▁▃▂▂▃▁ |

|     variable      | missing | complete |  n   | mean  |   sd   |   p0   |  p25  |  p50  |  p75  | p100  |   hist   |
|-------------------|---------|----------|------|-------|--------|--------|-------|-------|-------|-------|----------|
|   cluster_rent    |    0    |   7894   | 7894 | 27.5  |  10.6  |   9    |  20   | 25.14 |  34   | 71.44 | ▂▇▅▅▂▁▁▁ |
| Electricity_Costs |    0    |   7894   | 7894 | 0.031 | 0.0085 | 0.018  | 0.023 | 0.033 | 0.038 | 0.063 | ▆▃▂▇▁▁▁▁ |
|      empl_gr      |    0    |   7894   | 7894 |  3.2  |  8.13  | -24.95 | 1.74  | 1.97  | 2.44  | 67.78 | ▁▁▇▁▁▁▁▁ |
|     Gas_Costs     |    0    |   7894   | 7894 | 0.011 | 0.0024 | 0.0095 | 0.01  | 0.01  | 0.012 | 0.029 | ▇▂▁▁▁▁▁▁ |
|   leasing_rate    |    0    |   7894   | 7894 | 82.61 | 21.38  |   0    | 77.85 | 89.53 | 96.44 |  100  | ▁▁▁▁▁▁▃▇ |
|   Precipitation   |    0    |   7894   | 7894 | 31.08 | 11.58  | 10.46  | 22.71 | 23.16 | 43.89 | 58.02 | ▁▁▇▁▁▃▂▁ |
|       Rent        |    0    |   7894   | 7894 | 28.42 | 15.08  |  2.98  | 19.5  | 25.16 | 34.18 |  250  | ▇▂▁▁▁▁▁▁ |
> 

Proceeding with development of the best model, we try various methods.

The following is the LASSO model.



Analysis of Variance Table
  
 gb_lm_full
 > Model 1: Rent ~ cluster_rent + age + Electricity_Costs + size + stories + 
 >   class_a + amenities + CS_PropertyID + class_b + hd_total07 + 
 >   net + Gas_Costs + cluster + empl_gr + Precipitation + green_rating + 
 >   cd_total_07 + hd_total07 + total_dd_07 + LEED + Energystar + 
 >   leasing_rate
    
 gb_lm_forward  
 > Model 2: Rent ~ cluster_rent + size + class_a + class_b + cd_total_07 + 
 >   age + cluster + net + Electricity_Costs + leasing_rate + 
 >   hd_total07 + LEED + amenities + cluster_rent:size + size:cluster + 
 >   cluster_rent:cluster + class_b:age + class_a:age + cd_total_07:Electricity_Costs + 
 >   size:leasing_rate + cd_total_07:net + class_b:Electricity_Costs + 
 >   cd_total_07:hd_total07 + cluster_rent:age + cluster_rent:net + 
 >   cluster_rent:leasing_rate + cluster_rent:LEED + cluster:leasing_rate + 
 >   size:cd_total_07 + class_b:amenities + size:Electricity_Costs + 
 >   class_a:Electricity_Costs + cluster:Electricity_Costs + cluster:hd_total07 + 
 >   size:class_a + size:class_b + size:amenities + size:age + 
 >   class_b:cd_total_07 + Electricity_Costs:amenities + cluster_rent:amenities + 
 >   class_b:hd_total07 + class_a:hd_total07 + size:hd_total07 + 
 >   cluster_rent:Electricity_Costs + age:Electricity_Costs + 
 >   Electricity_Costs:hd_total07 + net:Electricity_Costs + net:hd_total07 + 
 >   age:LEED
  
 gb_lm_step
 > Model 3: Rent ~ cluster_rent + age + Electricity_Costs + size + stories + 
 >   class_a + amenities + CS_PropertyID + class_b + hd_total07 + 
 >   net + Gas_Costs + cluster + empl_gr + Precipitation + green_rating + 
 >   cd_total_07 + LEED + leasing_rate + cluster_rent:size + size:cluster + 
 >   cluster_rent:cluster + size:Precipitation + cluster_rent:stories + 
 >   size:leasing_rate + net:cd_total_07 + age:class_b + stories:class_a + 
 >   age:class_a + hd_total07:Precipitation + amenities:green_rating + 
 >   cluster_rent:LEED + cluster_rent:leasing_rate + class_b:Gas_Costs + 
 >   stories:amenities + Gas_Costs:Precipitation + size:cd_total_07 + 
 >   amenities:class_b + size:CS_PropertyID + cluster:leasing_rate + 
 >   class_b:Precipitation + Electricity_Costs:class_b + CS_PropertyID:class_b + 
 >   CS_PropertyID:hd_total07 + Electricity_Costs:CS_PropertyID + 
 >   CS_PropertyID:empl_gr + cluster_rent:amenities + amenities:CS_PropertyID + 
 >   cluster_rent:age + age:Electricity_Costs + cluster_rent:cd_total_07 + 
 >   Electricity_Costs:cluster + hd_total07:cluster + class_a:Precipitation + 
 >   class_a:Gas_Costs + Electricity_Costs:class_a + class_a:CS_PropertyID + 
 >   age:CS_PropertyID + Electricity_Costs:amenities + class_b:empl_gr + 
 >   CS_PropertyID:Gas_Costs + hd_total07:cd_total_07 + stories:cluster + 
 >   cluster_rent:net + LEED:leasing_rate + Gas_Costs:cluster + 
 >   cluster:cd_total_07 + amenities:Gas_Costs + amenities:Precipitation + 
 >   stories:cd_total_07
    
 >  Res.Df    RSS Df Sum of Sq       F    Pr(>F)    
 > 1   7873 695267                                   
 > 2   7843 637567 30     57700 24.0411 < 2.2e-16 ***
 > 3   7823 625851 20     11716  7.3226 < 2.2e-16 ***

Compared to the full model, all models findings are statistically significant down to the 1% level. We also find that the gb_lm_step model results not only in the lowest AIC, but also the lowest RSS and therefore is the optimal model.

Best performing model: gb_lm_step
AIC = 34662.54

Problem 2
=========

What causes what?
-----------------

**1) Why can’t I just get data from a few different cities and run the regression of “Crime” on “Police” to understand how more cops in the streets affect crime?**

The reason we can’t simply take data from multiple cities and run the regression of “Crime” on “Police” is due to the reverse causality problem that surrounds this regression. If we are trying to estimate the causal effect of the number of police officers in a city has on its crime rate, there is an issue of whether some cities have more police officers due to having a high crime rate, or if a city has a low crime rate because it has a high number of police officers. There is also an issue of potential lead-lag effects in regards to these variables. An immediate increase in the amount of police officers may not cause an immediate decrease in crime, or vis versa. Therefore, without using some sort of exogenous instrument that affects the number of police officers in a city, but does not affect the crime rate, we will be unable to find a causal estimate between them.

**2) How were the researchers from UPenn able to isolate this effect?**

Researchers at UPenn were able to isolate the effect that the number of police officers in a city has on its crime rate by using the “Terrorism Alert System” as an instrumental variable. They found that when the system was placed at a terror alert level of orange in Washington D.C., the city increased the number of police officers it had patrolling the streets and in public places, and yet it would be highly unlikely that this terror alert would affect the number of crimes committed during this time period. Because of this, the terror alert level satisfied both criteria for being an instrumental variable since it was found to be correlated with the endogenous explanatory variable “Police”, since it caused an increase in the number of officers on the street, but was not correlated with the crime rate (due to this increase not being associated with the crime rate), or other factors in the explanatory equation such as the number of tourists in the city during this alert. By using this instrument, they found that the crime rate did in fact decrease during the time periods when the terrorism alert level was at orange, and thus when more cops were patrolling the streets. With this method, they were able to find that high alert days were correlated with a 7.316 unit decrease in the number of crimes committed, and a 6.046 unit decrease in the number of crimes committed during high alert days, when accounting for METRO ridership. Both of these estimates were statistically significant at the 5% level of significance.

**3) Why did they have to control for Metro ridership? What was that trying to capture?**

The reason that the researchers controlled for Metro ridership is due to the fact that, if the number of metro riders in the city also decreased during high alert days, it is likely that the number of crimes that occurred in the city would decrease as well. By controlling for the effects of ridership on the number of crimes, they can show that, although high alert days decrease the crime rate in Washington D.C, its effect is not as high as when accounting for the number of tourists or citizens using the metro system in the city.

**4) What is the conclusion?**

This regression is estimating the effect that high alert days have on crime in different areas of D.C., with a focus on the National Mall (District 1). Separating D.C. into districts finds that, when the city is on high alert, there is a large decrease in the crime rate in District 1 of 13.679 units that is statistically significant at the 1% level, holding all else fixed, while there is only an 11.629 unit decrease in other districts during high alert days that is not statistically significant, holding all else fixed. This is likely due to the fact that large numbers of new police officers are stationed at the mall during high alert days due to it being a likely target for terroristic acts, and thus in need of more security. Due to this large increase in police officers, there is a strong, statistically significant, decrease in the crime rate during this time period that is not directly due to the crime rate of the area itself.
