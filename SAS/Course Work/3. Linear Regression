/*Q3.9, 3.10, 3.11, 3.18*/
data pricedifference;
input
demand pricedif;
datalines;
7.38 -0.05
8.51 0.25
9.52 0.60
7.50 0.00
9.33 0.25
8.28 0.20
8.75 0.15
7.87 0.05
7.10 -0.15
8.00 0.15
7.89 0.20
8.15 0.10
9.10 0.40
8.86 0.45
8.90 0.35
8.87 0.30
9.26 0.50
9.00 0.50
8.75 0.40
7.95 -0.05
7.65 -0.05
7.27 -0.10
8.00 0.20
8.50 0.10
8.75 0.50
9.21 0.60
8.27 -0.05
7.67 0.00
7.93 0.05
9.26 0.55
. 0.10
. 0.25
run;

proc gplot data = pricedifference; 
plot demand*pricedif; 

PROC REG data=pricedifference;
 MODEL demand = pricedif/clb clm cli;
 output out = pricedifference_results predicted = yhat residual = resid; 
RUN;
 
/* 
3.9 From the scatter plot, we can see that the points are fairly linear and therefore a linear regression model would fairly relate y to x. 
Using the Proc Reg, we see that the COD rsquare is 79% and the points are within the 95% prediction interval.  

3.10a. It gives us the value of demand when the price difference is equal 0.10 based on the simple regression model  
3.10b. It gives us the value of demand when the price difference is equal -0.05 based on the simple regression model
3.10c. The slope parameter is 2.66521 from the results. It indidcates the demand for the large bottle of fresh based on the price differences 
in the sales period. 
3.10d. The y intercept is 7.81409, it indicates the amount of demand if there was no price difference during the sales period. It makes practical 
sense as it gives the company an indication of what its demand would be if its prices were the same as competition. 
3.10e. The factors are the number of loads and the time of the year that may effect the difference in cost per period. 
*/

/*Q3.11
3.11a. Bo is 7.81409 and B1 is 2.66521. Bo indicates the amount of demand if there was no price difference during the sales period. It makes practical 
sense as it gives the company an indication of what its demand would be if its prices were the same as competition. 
3.11b. Using the output table, we can see that the predicted yhat will be 8.081.
3.11c. Using our model equation with Bo=7.81409 and B1 = 2.66521, yhat of 8.5 requires a price difference of $0.257
3.11d. MSE = 0.10021 and RMSE = 0.31656

3.18a. Bo is 7.81409 and B1 is 2.66521
3.18b. SSE=2.80590 MSE = 0.10021 and RMSE = 0.31656
3.18c. t = 10.31 sb1 = 0.2585, t = b1/sb1: 10.31 = 2.66521/0.2585
3.18d. With defualt SAS alpha = 0.05 and pvalue from results = <.0001. We reject null hypothesis for alternate. 
3.18e. When alpha = 0.01, pvalue is still lesser. We reject null hypothesis and are confident up to 99% that we can explain y with 
its relationship with x.
3.18f.We are confident up to 99.9% as pvalue is is lesser than even 0.001.
3.18g.Confidence Interval at 95% is 2.13570<b1<3.19473*/

PROC REG data=pricedifference;
 MODEL demand = pricedif/clb clm cli alpha=0.01;
RUN; 
/* 
3.18h.Confidence Interval at 99% is 1.95091<b1<3.37952  
3.18i. sb0 = 0.07988 and t = b0/sb0  -> t value = 97.82	
3.18j. Up to alpha = 0.001 as pvalue is is lesser than even 0.001.
*/

/*
3.22a. yhat = 8.0806 with 7.9479<95%CLMean<8.2133 
3.22b. yhat = 8.0806 with 7.4187<95%CLpredicted<8.7425
3.22c Refer to fit pot for demand graph
3.22d. Refer to 99% table for predicted yhat.  
 */

/* 
3.30a. From result, Total Vairance = 13.45859 , Explained Variance = 10.65268 , Unexplained Variance = 2.80590	
for F test DF = n-2 = 30-2 = 28
F = 106.30
3.30b. P value is lesser than alpha 0.05, reject null hypothesis in favour of alternate. Model provides strong evidence
of relationship between demand and price difference.
3.30c. P value is lesser than alpha 0.01, reject null hypothesis in favour of alternate. Model provides strong evidence
of relationship between demand and price difference.
3.30d. P value =<.0001,lesser than even at 0.001, 99.9% confident Model provides strong evidence
of relationship between demand and price difference.
3.30e.
 */

data taxation;
input
y x;
datalines;
8.0 1
4.7 0.125
3.7 0.25
2.8 0.0625
8.9 1
5.8 0.5
2.0 0.08333
1.9 0.2
3.3 0.3333
. 0.2
run;

proc gplot data = taxation; 
plot y*x; 

PROC REG data = taxation;
 MODEL y = x/clb clm cli;
 output out = tax_results predicted = yhat residual = resid; 
RUN;

data taxation;
input
y x;
datalines;
8.0 1
4.7 0.125
3.7 0.25
2.8 0.0625
8.9 1
5.8 0.5
2.0 0.08333
1.9 0.2
3.3 0.3333
. 0.2
run;

proc gplot data = taxation; 
plot y*x; 

PROC REG data = taxation;
 MODEL y = x/clb clm cli;
 output out = tax_results predicted = yhat residual = resid; 
RUN;

data stocks;
input
y x;
datalines;
17.73 17.96
4.54 8.11
3.96 12.46
8.12 14.70
6.78 11.90
9.69 9.67
12.37 13.35
15.88 16.11
-1.34 6.70
18.09 9.41
17.17 8.96
6.78 14.17
4.74 9.12
23.02 14.23
7.68 10.43
14.32 19.74
-1.63 6.42
16.51 12.16
17.53 23.19
12.69 19.20
4.66 10.76
3.67 8.49
10.49 17.70
10.00 9.10
21.90 17.47
5.86 18.45
10.81 10.06
5.71 13.30
13.38 17.66
13.43 14.59
10.00 20.94
16.66 9.62
9.40 16.32
0.24 8.19
4.37 15.74
3.11 12.02
6.63 11.44
14.73 32.58
6.15 11.89
5.96 10.06
6.30 9.60
0.68 7.41
12.22 19.88
0.90 6.97
2.35 7.90
5.03 9.34
6.13 15.40
6.58 11.95
14.26 9.56
2.60 10.05
4.97 12.11
6.65 11.53
4.25 9.92
7.30 12.27
. 15.00
run; 
proc gplot data = stocks; 
plot y*x; 

PROC REG data = stocks;
 MODEL y = x/clb clm cli;
 output out = tax_stocks predicted = yhat residual = resid; 
RUN;

/* 
3..36a Point estimate is 10.04 and 8.4940<95%CLMean<11.5144	 
3.36b -0.3099<95%CLpredicted<20.3182 */
