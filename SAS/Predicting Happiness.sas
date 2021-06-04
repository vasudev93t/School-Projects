FILENAME REFFILE '/home/u54945437/DSCI5340/2019.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.HAPPINESSREPORT2019;
	GETNAMES=YES;
RUN;

Title "Gdp per captia vs rank ";  
/*Using this to set the bemchmark that while money does happiness, its not entirely true.   */
proc sgplot data = happinessreport2019; 
scatter y='Gdp per capita'n x= 'Overall rank'n;

/*Dropping Overall Rank and Country columns*/
data HAPPINESSREPORT2019_1;
set work.happinessreport2019 (drop='overall rank'n 'country or region'n);
run;

Title 'Missing Value Check'; /*Checking for Missing Values*/
proc means data=happinessreport2019_1 nmiss;
var _all_;
title "Missing Value";
run;

Title 'Descriptive Statistics';
 /*Checking Mean and S.D*/
proc means data =happinessreport2019_1;
run;

/*Checking Median, Skeweness and Kurtosis*/
proc univariate data =happinessreport2019_1;
run;

/*Aim of this plots is to ovbserve visually the relationship between independent variable and Happiness Score*/
Title "Happiness Score vs Gdp per capita";
proc sgplot data = happinessreport2019_1; 
scatter y=score x='Gdp per capita'n;
reg y=score x='Gdp per capita'n;

Title 'Happiness Score vs Social support';
proc sgplot data = happinessreport2019_1; 
scatter y=score x='Social support'n;
reg y=score x='Social support'n;

Title 'Happiness Score vs Healthy life expectancy';
proc sgplot data = happinessreport2019_1; 
scatter y=score x='Healthy life expectancy'n;
reg y=score x='Healthy life expectancy'n;

Title 'Happiness Score vs Freedom to make life choices';
proc sgplot data = happinessreport2019_1; 
scatter y=score x='Freedom to make life choices'n;
reg y=score x='Freedom to make life choices'n;

Title'Happiness Score vs Generosity';
proc sgplot data = happinessreport2019_1; 
scatter y=score x=Generosity;
reg y=score x=Generosity;

Title'Happiness Score vs Perceptions of corruption';
proc sgplot data = happinessreport2019_1; 
scatter y=score x='Perceptions of corruption'n;
reg y=score x='Perceptions of corruption'n;


Title'Regression Analysis';
/*Checking Correlation of varaibles with each other*/
proc corr data =happinessreport2019_1 plots=matrix(histogram) PLOTS(MAXPOINTS=NONE);
var score 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n 'Freedom to make life choices'n Generosity 'Perceptions of corruption'n;
run;
/*
Pearson correlation is the one most commonly used in statistics. 
This measures the strength and direction of a linear relationship between two variables
Small Corr	.1 to .3  
Medium Corr	.3 to .5
Strong Corr	.6 to 0.8
Severe Corr 0.85> (Rejection if between independent variable)

Overall none of the independent variable are extremely correlated.
*/

/*Checking Model for Multi-collinearity */
PROC REG data = happinessreport2019_1;
MODEL score = 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n 
'Freedom to make life choices'n Generosity 'Perceptions of corruption'n/tol vif;
RUN;
/* 
1. VIF values all smaller than 5. So overall not much interaction between dependent variables
2. When looking at dependednt and independent variables, Generosity has p-value greater than Alpha so we do not reject H0 
as it shows that there isnt a regression relationship between Generosity and Happiness Score.
*/

/*Use backward elimination to confirm Model*/
PROC REG data = happinessreport2019_1;
MODEL score = 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n
'Freedom to make life choices'n Generosity 'Perceptions of corruption'n/ selection=backward SLSTAY=.05;
RUN;

/*Check for outliers or influential data*/
PROC REG data = happinessreport2019_1;
MODEL score = 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n
'Freedom to make life choices'n 'Perceptions of corruption'n/ r influence;
output out=results predicted=yhat residual=resid;


/*Confirm that model satisfies regression assumption -  Constant Variance, independence and normality*/
PROC REG data = happinessreport2019_1;
MODEL score = 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n
'Freedom to make life choices'n 'Perceptions of corruption'n/ clb cli clm;
output out=results predicted=yhat residual=resid;
Proc plot data = work.results;
plot resid*(yhat 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n
'Freedom to make life choices'n 'Perceptions of corruption'n);
proc univariate data=work.results normal plot;
var resid;
RUN;

/*Use model to predict values for 2020*/
data HAPPINESSREPORT2019_2;
set work.happinessreport2019 (drop='overall rank'n 'country or region'n 'generosity'n);
run;

data estimate_2020_1;
score=. ; 'Gdp per capita'n = 1.032; 'Social support'n = 0.954; 'Healthy life expectancy'n = 1.108;
'Freedom to make life choices'n = 0.949; 'Perceptions of corruption'n = 0.186;

data estimate_2020_2;
score=. ; 'Gdp per capita'n = 1.039; 'Social support'n = 0.954; 'Healthy life expectancy'n = 1.119;
'Freedom to make life choices'n = 0.946; 'Perceptions of corruption'n = 0.179;


data predict_2020;
set work.happinessreport2019_2 estimate_2020_1 estimate_2020_2;

PROC REG data = predict_2020 alpha=0.05;
MODEL score = 'Gdp per capita'n 'Social support'n 'Healthy life expectancy'n
'Freedom to make life choices'n 'Perceptions of corruption'n/ clb cli clm;
/* Predicted values are lower than actual values for top 2 countires in 2020. However only slighlty lower as Happiness has strong elements of
qualitative portion that play a role in this*/


/*While we know other factors play a role in happiness, GDP does seem to have the strongest impact.
Predicting the GDP of Finland with time-series regression. */

FILENAME REFFILE '/home/u54945437/DSCI5340/Finland Dataset_30 Years.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.GDP;
	GETNAMES=YES;
RUN;

data Finland_GDP;
set  work.gdp;
rename Time = Year;
where Location = 'FIN';
input
T;
datalines;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
run;

data Finland_GDP_2018;
set finland_gdp (drop=Location Indicator Subject Measure Frequency 'Flag Codes'n);
where Year < '2019';
run;


data prediction_2019;
Year = '2019'; Value=.; T=30;

data prediction_2020;
Year = '2020'; Value=.; T=31;

data Finland_Prediction;
set finland_gdp_2018 prediction_2019 prediction_2020;

proc plot data = Finland_Prediction;
plot value*T;

proc reg data = Finland_Prediction;
model value = T/clm cli dw;
output out = results_GDP predicted =yhat residual = resid;
proc plot data = work.results_GDP;
plot resid*T;
run;

/* Since d = 0.593 < d(l,alpha =0.05) = 1.34 for n=29 and k = 1. 
We reject H0 in favour of HA = Error Terms are positively correlated*/

proc arima data=Finland_Prediction ;
identify var=value nlag=24;
run;

/*Visual inspection of the autocorrelation function plot (ACF) indicates that the Value series is nonstationary, since
the ACF decays very slowly.*/

proc arima data = Finland_Prediction;
identify var = value
crosscorr=T
noprint;
estimate input = T
printall plot;
proc arima data = Finland_Prediction;
identify var = value
crosscorr= T
noprint;
estimate input = T
p=(1) printall plot;
forecast lead = 5 out = work.fcast1;
run;

