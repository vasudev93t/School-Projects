/*Q1) Discuss the forecasting applications in the following area:

Social Goods:
Health and healthcare: Forecast the peak of certain diseases in the future to equip hospital facilities and staff with 
necessary equipment 
Humanitarian operations: Forecast the revenue & manpower required 
Disaster relief: Determine potential survivors to forecast supply of food and water
Education: Universities can forecast the relevance of courses based on job-market demand and student interest to ajust 
offering
Social services: Forecast the divorce rates to adjust training and preapareness for foster homes 
Environment; Forecast impact of greenhouse gases to Ozone layer
Sustainability: Forecast the reduction in plsatic waste through recycling
Sharing economy: Forecast the demand of online sharing service based on net traffic patten on the internet
Transportation: Forecast the change in consumer preference to align production capabilites and goals
Urban planning: Forecast human traffic volume across the area for efficient desig 
Fraud, collusion, and corruption: Forecast factors that increase fraud, corruption based on quantittaive and qualitative 
historical  data
Government policy: Forecast immigration movement to create policies 
Poverty: Forecast future GDP growth and income disparirty to assign economic pacakges 
Privacy: Forecast personal data breaches with rapid change in technology
Cyber security: Forecast future behaviours of cyber crimes 
Crime and terrorism: Forecast rate of crime in future and in which areas to develop strategic defences 

2. Energy analytics: Forecast profit and margins to improve operational capabilites 

3. Tourism: Forecast period of high toursit influx vs low influx

4. Supply chain and inventory management: Forecast demand for individual products and raw materials accordingly

5. Financial markets: Forecast movement and volatility of the various stock indexes

6. ICT and innovation: Forecast demand for exisitng and new technology in the future

7. Business cycle: Forecast behaviour of supply and demand to adjust operations accordingly

8. Digitalized businesses: Forecast the consumer demand patterns in digital space and willignness to pay for digital services

9. Industry 4.0: Forecast production capabilites with shift in manufacturing companies deploying IoT sensors on the factory floor 

10. Society 5.0: Forecast job vacanies with increase in AI tech in Society 5.0

11. Big data analytics: Forecast application development to aid with insights and data extraction
*/



/*Q2) What is your view about the future of forecasting?

1. We need to learn from the past to strive a balance between judgement and robustness of statistical models.
2, With ample data avaiable for forecasters after the .com boom and introduction of social media, 
forecaster will have ample data to fill gaps that previous methods eoncountered
3. With new technology and softwares in the future, processing this data should be more efficient and cost effective for
companies to implement and reduce the oppurtunity cost associated with forecasting



/*Question 3*/

/*Example 1.1 to 1.4
Forecasting is crucial to companies, organizations and governments as they help to plan for future events and provide a 
sensible direction to decision making process for future events. 

Time series is a chronological sequence of observations on a particular variable. 
Trend refers to the upward or downward movement of a series over a period. 
Cycle refers to the recurring up and down movements around a trend cycle. 
Seasonal variations are periodic patterns that complete themselves within a calander year
Irregular fluctuations are ones that follow no specific patterns and happen erradicaly.

Time-series data is a set of observations collected at usually discrete and equally spaced time intervals
Cross-sectional data are observations that come from different varaibles at a single point in time

Point forecast is a single number that represents our best prediction while prediction interval forecast
is a range of number.


/*Example 1.5*/
Title"Graph of Forecast Errors of Model A, B & C";
data ModelABC;
input
period
errorA
errorB
errorC
;
datalines;
1	25	15	-20
2	12	6	6
3	7	-10	15
4	5	-3	-10
5	3	12	8
6	0	4	-5
7	-4	-7	7
8	-11	-1	-8
9	-17	9	3
10	-21	7	10
11	-28	-12	-12
12	-34	-5	4
13	-21	17	-7
14	-13	3	9
15	-7	-9	19
16	-2	-3	-7
17	5	13	16
18	9	5	-6
19	15	-10	-9
20	19	-6	5
run;

proc sgplot data=ModelABC;
   series x=period y=errorA / legendlabel="MODEL A";
   series x=period y=errorB / legendlabel="MODEL B";
   series x=period y=errorC / legendlabel="MODEL C";
   yaxis label="Error";
run;

/*1.5B
Erros Patterns from Model A and Model B appear to be random as the move around the positie and negative sporadically*/

/*Model C can fit data charaterizing sales as it could be showcasing a seasonality in the sales data that can repeat
anually, Example: Sales of Winter Clothing*/



Title"Question 1.6";
data monthlysales;
input Month $ ActualSales PredictedSales;
ForecastError=ActualSales - PredictedSales;
Absolutedeviation=abs(ForecastError);
SquaredError=Absolutedeviation**2;
AbsolutePercentageError=(ForecastError/ActualSales)*100;
datalines;
Jan	270 265
Feb	263	268
March 275 269
April 262 267
May 250 245
June 278 275
run;

proc print data=monthlysales;
run; 
Title "MAD";
proc means data=monthlysales;
var Absolutedeviation;
run;
Title "MSE";
proc means data=monthlysales;
var SquaredError;
run;
Title "MAPE";
proc means data=monthlysales;
var AbsolutePercentageError;
run;


/*Question 1.7 
Univariate models predict the future values of a time series solely on the basis of the past values of the time series
Causual models include other variables that are related to the variable to be predicted.
Given the above definitio,
1.7a and 1.7c are univariate models are they are solely on the basis of past values of the time series
1.7b is a casual model as other variables like advertising expenditure and number of calls  by salesperson affect
the dependent sales variable*/


Title"Question 1.8";
data GDP;
input Year  PCP PredictedPCP;
ForecastError=PCP - PredictedPCP;
Absolutedeviation=abs(ForecastError);
SquaredError=Absolutedeviation**2;
AbsolutePercentageError=(ForecastError/PCP)*100;
datalines;
1979 3074 3292
1980 3135 3250
1981 3206 3230
1982 3267 3255
1983 3310 3266
1984 3362 3283
1985 3418 3300
1986 3500 3337
run;

proc print data=GDP;
run; 
/*Time Series Plot*/
symbol value=none interpol=L width=1;
title "Time Series Plot for GDP error";
proc gplot data=GDP;
plot ForecastError*Year;
run;
/*1.8C 
I feel that the forecasting method does not fit the data pattern is it shows an upward trend showing that it does
not account for the upward trend in the time series*/

Title "MAD";
proc means data=monthlysales;
var Absolutedeviation;
run;
Title "MSE";
proc means data=monthlysales;
var SquaredError;
run;
Title "MAPE";
proc means data=monthlysales;
var AbsolutePercentageError;
run;


Title"Question 1.9";
data Actualsales;
input Year AS MethodA MethodB;
ForecastErrorA=AS - MethodA;
ForecastErrorB=AS - MethodB;
AbsolutedeviationA=abs(ForecastErrorA);
AbsolutedeviationB=abs(ForecastErrorB);
SquaredErrorA=AbsolutedeviationA**2;
SquaredErrorB=AbsolutedeviationB**2;
datalines;
1998 8.0 9.0 9.5
1999 12.0 11.5 10.5
2000 14.0 14.0 12.0
2001 16.0 16.5 13.0
2002 10.0 19.0 15.0
run;

proc print data=Actualsales;
run; 
Title "MAD for Method A";
proc means data=Actualsales;
var AbsolutedeviationA;
run;
Title "MSE for Method A";
proc means data=Actualsales;
var SquaredErrorA;
run;

Title "MAD for Method B";
proc means data=Actualsales;
var AbsolutedeviationB;
run;
Title "MSE for Method B";
proc means data=Actualsales;
var SquaredErrorB;
run;

/*1.9C 
The reason why the MSE for both the models differs greatly is because of the fact that a MSE squares a the models erros. 
Thus model A prediction for year 2002 had an error of 9 which resulted in a much larger MSE*/
