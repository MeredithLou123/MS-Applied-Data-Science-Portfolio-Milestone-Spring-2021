library(topicmodels)
library(tidytext)
library(tidyverse)
library(jsonlite)
library(ggplot2)
library(scales)
library(caret)
library(e1071)
library(arulesViz)
library(arules)
library(gam)
library(randomForest)
library(imputeTS)
library(PCAmixdata)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(ggrepel)
library(mgcv)
################################ Phase 1: Mitigate Missing Data ###############################

js = fromJSON("./Spring2020-survey.json")
df = as.data.frame(js)
summary(df) #this tells some of the columns are NAs

#focus on numerical and categorical data first
df = select(df,-starts_with("freeText"))
#Take out data from west airways since it less than 30 and 26 Na's
df %>% group_by(Partner.Code) %>% summarise(n=n()) %>% arrange(desc(n))
new_df =  df %>% filter(Partner.Code != 'HA')

new_df = select(new_df,-starts_with("freeText"))
summary(new_df)

new_df = new_df %>% mutate(PassengerType = case_when(
Likelihood.to.recommend > 8 ~ "promoters",
Likelihood.to.recommend < 7 ~ "detractors",
Likelihood.to.recommend == 7 | Likelihood.to.recommend == 8 ~"passive")) %>%
mutate(Promoter = if_else(PassengerType=='promoters',1,0)) %>%
mutate(Detractor = if_else(PassengerType=='detractors',1,0))
 




new_df$longtrip = new_df$Flight.time.in.minutes + new_df$Departure.Delay.in.Minutes + new_df$Arrival.Delay.in.Minutes
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#17.0    72.0   116.0   145.5   188.0  2161.0
summary(new_df$longtrip)
#Transform columns from nums to categorie
new_df = new_df %>% mutate(AgeType = case_when(
  Age >= 15 & Age <= 17 ~ "Teenager",
  Age >= 18  & Age < 25 ~ "Young Adults",
  25 <= Age & Age < 65 ~ "Adults",
  Age >= 65 ~ "Elderly")) %>%
  mutate(Sensitivity = case_when(Price.Sensitivity <= 1 ~ "low sensitivity",
                                 Price.Sensitivity > 1 & Price.Sensitivity <= 2 ~ "moderate sensitivity",
                                 Price.Sensitivity > 2 ~ "high sensitivity"))  %>%
  mutate(foodSpending = case_when(Eating.and.Drinking.at.Airport <= 30 ~"low spending",
                                  Eating.and.Drinking.at.Airport > 30 &  Eating.and.Drinking.at.Airport < 90 ~"medium spending",
                                  Eating.and.Drinking.at.Airport >= 90  ~"high spending")) %>%
  mutate(shopSpending = case_when(Shopping.Amount.at.Airport <= 28 ~ "low spending",
                                  Shopping.Amount.at.Airport > 28 & Shopping.Amount.at.Airport <= 30 ~ "medium spending",
                                  Shopping.Amount.at.Airport > 30 ~ "high spending")) 
new_df = new_df %>% mutate(LongDuration = case_when(longtrip >= 116 ~ 'True', longtrip < 116 ~ 'False'))


# Departure.Delay.in.Minutes" 191 "Arrival.Delay.in.Minutes" 219  "Flight.time.in.minutes"  219
na_df = new_df %>% filter(is.na(Arrival.Delay.in.Minutes)) #includes all the cancelled flights data 
(sum(na_df$Promoter) / nrow(na_df) - sum(na_df$Detractor) / nrow(na_df)) * 100   #NPS score for null values [-0.41] -19.17808



sum(na_df$Promoter) #43
sum(na_df$Detractor) #detractor 85
nrow(is.na(na_df$Departure.Delay.in.Minutes))


na_df %>% filter(is.na(na_df$Departure.Delay.in.Minutes)) %>% summarise(n=n())

new_df = new_df %>% na.omit()
View(new_df)


################################  Descriptive Statistics ###############################



new_df %>% group_by(Airline.Status) %>% summarise(n=n()) %>% arrange(desc(n))
na_df %>% group_by(Gender) %>% summarise(n=n()) %>% arrange(desc(n))
new_df %>% group_by(Type.of.Travel) %>% summarise(n=n()) %>% arrange(desc(n))
new_df %>% group_by(Class) %>% summarise(n=n()) %>% arrange(desc(n))
new_df %>% group_by(Type.of.Travel,Class) %>% summarise(n=n()) %>% arrange(desc(n))
new_df %>% group_by(Class,Type.of.Travel) %>% summarise(n=n()) %>% arrange(desc(n))
new_df %>% group_by(Year.of.First.Flight) %>% summarise(n=n()) %>% arrange(desc(n))
new_df  %>% group_by(AgeType) %>% summarise(m=mean(Loyalty)) %>% arrange(desc(m))
new_df  %>% group_by(Gender) %>% summarise(m=mean(Loyalty)) %>% arrange(desc(m))

na_df %>%  group_by(AgeType) %>% summarise(n= sum(Total.Freq.Flyer.Accts)) 
na_df %>%  group_by(AgeType) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
new_df %>% filter(Gender=='Male') %>% group_by(Class) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
new_df %>% filter(Gender=='Female') %>% group_by(Class) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n)) 

new_df %>% group_by(AgeType) %>% summarise(n=mean(Eating.and.Drinking.at.Airport))  %>% arrange(desc(n))
new_df %>% group_by(AgeType) %>% summarise(n=mean(Shopping.Amount.at.Airport))  %>% arrange(desc(n))
new_df %>% filter(AgeType=='Elderly') %>% group_by(Airline.Status) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))

new_df %>% filter(AgeType=='Young Adults') %>% group_by(Type.of.Travel) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))

new_df %>%  filter(Gender=='Male') %>% group_by(Partner.Name) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
new_df %>%  filter(Gender=='Female'& Type.of.Travel =='Business travel') %>% group_by(Class) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
new_df %>%  filter(AgeType=='Elderly' & Type.of.Travel =='Personal Travel') %>% group_by(Partner.Name) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))

new_df %>%  filter(Gender=='Female'& Type.of.Travel =='Business travel') %>% group_by(Class) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
new_df %>%  filter(Gender=='Female'& Type.of.Travel =='Personal Travel') %>% group_by(Class) %>% summarise(n=n()) %>% mutate(n=n/sum(n)*100) %>%arrange(desc(n))
calculate_NPS = function(df,feature,cond){
  cond_temp = enquo(cond)
  feature_temp = enquo(feature)
  res = filter(df,!!feature_temp == !!cond_temp)
  t = (sum(res$Promoter) / nrow(res) - sum(res$Detractor) / nrow(res)) * 100   
  tibble(feature = !!cond, nps_score = t)
  
}




flightYear = bind_rows(calculate_NPS(new_df,Year.of.First.Flight,2003),
          calculate_NPS(new_df,Year.of.First.Flight,2004),
          calculate_NPS(new_df,Year.of.First.Flight,2005),
          calculate_NPS(new_df,Year.of.First.Flight,2006),
          calculate_NPS(new_df,Year.of.First.Flight,2007),
          calculate_NPS(new_df,Year.of.First.Flight,2008),
          calculate_NPS(new_df,Year.of.First.Flight,2009),
          calculate_NPS(new_df,Year.of.First.Flight,2010),
          calculate_NPS(new_df,Year.of.First.Flight,2011),
          calculate_NPS(new_df,Year.of.First.Flight,2012))


flightYear$Year = as.character.Date(flightYear$feature)

##NA values ####
na_df  %>% group_by(AgeType) %>% summarise(m=mean(Loyalty)) %>% arrange(desc(m))
na_df %>% group_by(Airline.Status) %>% summarise(n=n()) %>% arrange(desc(n))
na_df %>% group_by(Gender) %>% summarise(n=n()) %>% arrange(desc(n))
na_df %>% group_by(Type.of.Travel) %>% summarise(n=n()) %>% arrange(desc(n))




################################  Data Visualization ###############################



ggplot(flightYear,aes(x=Year,y=nps_score)) + geom_point(shape=23, fill="blue", color="darkred", size=3) 


# 
# Year  Month     n
# <chr> <chr> <int>
#   1 14    1      3368
# 2 14    2      2994
# 3 14    3      3663
new_df %>% separate("Flight.date",c("Month","Day","Year"),sep="/") %>%
  mutate(MonthYear = paste(Month,Year,sep="/")) %>% select(Year,Month,Flights.Per.Year) %>% group_by(Year,Month) %>% summarise(n=n())
dates = new_df %>% separate("Flight.date",c("Month","Day","Year"),sep="/") %>%
  mutate(MonthYear = paste(Month,Year,sep="/"))
  
ggplot(dates) + aes(x=MonthYear,y=Flights.Per.Year,fill=Gender) + geom_col()

passengers = new_df  %>% group_by(PassengerType) %>% summarise(n=n()) %>% mutate(Percentile=n/sum(n)*100) %>%arrange(desc(n))
ggplot(passengers) + aes(x=PassengerType,y=Percentile) + geom_col() 

ggplot(new_df) + aes(x=longtrip) + geom_density() #right skewed 

ggplot(dates) + aes(x=MonthYear,y=Loyalty,fill=Gender) + geom_col()


AgeGroup = bind_rows(calculate_NPS(new_df,AgeType,"Teenager"),calculate_NPS(new_df,AgeType,"Adults"),calculate_NPS(new_df,AgeType,"Young Adults"),calculate_NPS(new_df,AgeType,"Elderly"))
AgeGroup = AgeGroup %>% rename(Age = feature)


#Age group by percentage

data <- new_df %>% 
  group_by(AgeType) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(AgeType))
data
data$label <- scales::percent(data$per)
ggplot(data=data)+
  geom_bar(aes(x="", y=per, fill=AgeType), stat="identity", width = 1)+
  coord_polar("y", start=0)+
  theme_void()+
  geom_text(aes(x=1, y = cumsum(per) - per/2, label=label)) + scale_fill_manual(values=c("#55DDE0", "#33658A", "#2F4858", "#F6AE2D", "#F26419", "#999999")) 

ggplot(AgeGroup,aes(Age, nps_score, fill = nps_score < 0)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  ylab("Net Promoter Score by Age Group") +
  scale_fill_discrete(name = "", labels = c("Adults"))

#Distribution of partner airlines

partner <- new_df %>% 
  group_by(Partner.Name) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(per=`n`/sum(`n`)) %>% 
  arrange(desc(Partner.Name))
partner

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7","#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442")
partner$label <- scales::percent(partner$per)
ggplot(data=partner)+
  geom_bar(aes(x="", y=per, fill=Partner.Name), stat="identity", width = 1)+
  coord_polar("y", start=0)+
  theme_void()+
  geom_text(aes(x=1, y = cumsum(per) - per/2, label=label)) + scale_fill_manual(values=cbPalette) 

#NPS score by gender 
bind_rows(calculate_NPS(new_df,Gender,"Female"),calculate_NPS(new_df,Gender,"Male"))




#How many flights does elderly take compare to other age groups? 

#elders take the most flights per year 
new_df %>% group_by(AgeType) %>% summarise(total = mean(Flights.Per.Year))
#elderly spent the most for eating and drinking at airport 
new_df %>% group_by(AgeType) %>% summarise(total = mean(Eating.and.Drinking.at.Airport))

LongTrips = bind_rows(calculate_NPS(new_df,LongDuration,"True"),calculate_NPS(new_df,LongDuration,"False"))
LongTrips = LongTrips %>% rename(LongDurationTrips = feature)


ggplot(LongTrips,aes(x=LongDurationTrips,y=nps_score,fill=LongDurationTrips)) + geom_bar(stat="identity") + scale_fill_brewer(palette="Spectral")


#Food Spending at airport 

FoodSpend = bind_rows(calculate_NPS(new_df,foodSpending,"low spending"),calculate_NPS(new_df,foodSpending,"medium spending"),calculate_NPS(new_df,foodSpending,"high spending")) 
Shopping = bind_rows(calculate_NPS(new_df,shopSpending,"low spending"),calculate_NPS(new_df,shopSpending,"medium spending"),calculate_NPS(new_df,shopSpending,"high spending"))
View(FoodSpend)

ggplot(new_df,aes(x=AgeType,y=Eating.and.Drinking.at.Airport,fill=PassengerType)) + geom_col() + scale_fill_brewer(palette="Set2")

spend = new_df %>% select(Shopping.Amount.at.Airport,Eating.and.Drinking.at.Airport) %>% filter(Eating.and.Drinking.at.Airport > 0) %>% filter(Shopping.Amount.at.Airport > 0)
ggplot(spend,aes(x=Shopping.Amount.at.Airport,y=Eating.and.Drinking.at.Airport)) + geom_point()


#nps score for male and female passengers
gender_score = bind_rows(calculate_NPS(new_df,Gender,"Female"),calculate_NPS(new_df,Gender,"Male"))
gender_score = gender_score %>% rename(gender = feature)
ggplot(gender_score,aes(x=gender,y=nps_score,fill=gender)) + geom_bar(stat="identity") + scale_fill_brewer(palette="Set2")



#smaller data set containing only the trips where customers reported the lowest levels of satisfaction
flights = function(df,c1,c2){
    city1 = c1
    city2 = c2
    citydata = df[(df$Origin.City == city1 & df$Destination.City == city2),]
    
    res = (sum(citydata$Promoter) / nrow(citydata) - sum(citydata$Detractor) / nrow(citydata)) * 100
  
    tibble(Route1 = !!c1,Route2 = !!c2,nps_score = res,olong = citydata$olong,olat=citydata$olat, dlong = citydata$dlong,dlat = citydata$dlat)
    
}


routes = new_df %>% select(Origin.City,Destination.City) %>% distinct(Origin.City,Destination.City)


datalist = list()

for(i in 1:nrow(routes)){
    result = flights(new_df,routes[i,1],routes[i,2])
    datalist[[i]] = result
  } 
final = bind_rows(datalist)
final = final[which(final$nps_score <= -100),]

final = final %>% distinct(Route1,Route2,nps_score,olong,olat,dlong,dlat)

usMap = borders("state", colour="black", fill="black",xlim=c(-130,-60),ylim=c(20,50))
flightMap =  ggplot() + usMap +
  geom_curve(data=final,
             aes(x=olong, y=olat, xend=dlong, yend=dlat),
             col="#00008b",
             size=.5,
             curvature=0.2) +
  geom_point(data=final,
             aes(x=olong, y=olat), 
             colour="blue",
             size=1.5) +
  geom_point(data=final,
             aes(x=dlong, y=dlat), 
             colour="blue") +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.ticks=element_blank(),
        plot.title=element_text(hjust=0.5, size=12)) +
  ggtitle("Migration Map by Lowest Nps Score")
flightMap


################################  Data Modeling  ###############################
#Feature selection 
new_df %>% group_by(Flight.cancelled) %>% summarise(n=n())
quali = new_df %>% select("Gender","Airline.Status","Type.of.Travel","Class","Partner.Code","PassengerType")
quanti = new_df %>% select("Age","Price.Sensitivity","Year.of.First.Flight","Flights.Per.Year","Loyalty","Shopping.Amount.at.Airport","Eating.and.Drinking.at.Airport","longtrip","Flight.Distance")
res = PCAmix(X.quanti = quanti,X.quali = quali,ndim = 9,graph=False)
plot(res,choice="ind",coloring.ind=quali,cex=0.8)
plot(res, choice="cor",cex=0.9,coloring.var=TRUE)

plot(res, choice="sqload",cex=0.9,coloring.var=TRUE)

plot(res, choice="levels",cex=0.9,coloring.var=TRUE)

df_temp = new_df %>% select("Gender","Airline.Status","Type.of.Travel","Class","Age","Price.Sensitivity","Year.of.First.Flight","Flights.Per.Year","Loyalty","Shopping.Amount.at.Airport","Eating.and.Drinking.at.Airport","longtrip","Flight.Distance","Likelihood.to.recommend","Type.of.Travel")



model = train(Airline.Status ~ .,data = df_temp,preProcess="scale",method = "gbm")
importance = varImp(model)
plot(importance)

data.train = new_df %>% select("Gender","Airline.Status","Type.of.Travel","Class","PassengerType","Partner.Name","foodSpending","shopSpending","Sensitivity","LongDuration","AgeType")
for(i in 1:ncol(data.train)) data.train[[i]] <- as.factor(data.train[[i]])

data.trans = as(data.train,"transactions")
inspect(data.trans)

sort(itemFrequency(data.trans))

itemFrequencyPlot(data.trans,topN=20,col=brewer.pal(8,'Pastel2'))
freq = crossTable(data.trans,sort=TRUE)
freq[1:6,1:6]

new_rules = apriori(data.trans,parameter= list(supp=0.2,conf=0.76),control = list(verbose=F))
plot(new_rules)

n1 = apriori(data.trans,parameter= list(supp=0.1,conf=0.6),control=list(verbose=F),appearance =list(default="lhs",rhs=("Gender=Female")))
n2 = apriori(data.trans,parameter= list(supp=0.1,conf=0.6),control=list(verbose=F),appearance =list(default="lhs",rhs=("PassengerType=detractors")))
n3 = apriori(data.trans,parameter= list(supp=0.009,conf=0.8),control=list(verbose=F),appearance =list(default="lhs",rhs=("LongDuration=True")))
n4 = apriori(data.trans,parameter= list(supp=0.19,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("shopSpending=low spending")))

summary(n1)
inspectDT(n1[quality(n1)$lift > 1.05])



summary(n3)
inspectDT(n3[quality(n3)$lift > 1.62])

summary(n4)
inspectDT(n4[quality(n4)$lift > 1.01])


##female promoters 
model.fem = new_df %>% filter(Gender=='Female') %>% select("Gender","Airline.Status","Type.of.Travel","Class","PassengerType","AgeType","foodSpending","shopSpending","Sensitivity","LongDuration")
for(i in 1:ncol(model.fem)) model.fem[[i]] <- as.factor(model.fem[[i]])
trans.fem = as(model.fem,"transactions")

inspect(trans.fem)

sort(itemFrequency(trans.fem))

itemFrequencyPlot(trans.fem,topN=20,col=brewer.pal(8,'Pastel2'))


trans.f1 = apriori(trans.fem,parameter= list(supp=0.1,conf=0.4),control=list(verbose=F),appearance =list(default="lhs",rhs=("PassengerType=promoters")))
trans.f2 = apriori(trans.fem,parameter= list(supp=0.1,conf=0.67),control=list(verbose=F),appearance =list(default="lhs",rhs=("shopSpending=low spending")))
summary(trans.f2)

inspectDT(trans.f2[quality(trans.f2)$lift > 1.02])



#Customer segments: customers age older than 65 with low nps score 

## Apriro algorithm (inferential Model) ## 

#Flights not cancelled
model_train = new_df %>% filter(AgeType == 'Elderly') %>% select("Gender","Airline.Status","Type.of.Travel","Class","PassengerType","Partner.Name","foodSpending","shopSpending","Sensitivity","LongDuration")
str(model_train)
summary(model_train)


#model_train$Year.of.First.Flight = as.factor(model_train$Year.of.First.Flight)
for(i in 1:ncol(model_train)) model_train[[i]] <- as.factor(model_train[[i]])

transactional_data = as(model_train,"transactions")
#Flights cancelled
inspect(transactional_data)

sort(itemFrequency(transactional_data))

itemFrequencyPlot(transactional_data,topN=20,col=brewer.pal(8,'Pastel2'))
ct = crossTable(transactional_data,sort=TRUE)
ct[1:6,1:6]

rules = apriori(transactional_data,parameter= list(supp=0.2,conf=0.7),control = list(verbose=F))
plot(rules)

rule = apriori(transactional_data,parameter= list(supp=0.05,conf=0.8),control=list(verbose=F),appearance =list(default="lhs",rhs=("PassengerType=detractors")))

ruleset = apriori(transactional_data,parameter= list(supp=0.05,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("Class=Eco")))

r1 = apriori(transactional_data,parameter= list(supp=0.003,conf=0.8),control=list(verbose=F),appearance =list(default="lhs",rhs=("Airline.Status=Blue")))
r2 = apriori(transactional_data,parameter= list(supp=0.002,conf=0.9),control=list(verbose=F),appearance =list(default="lhs",rhs=("LongDuration=True")))
r3 = apriori(transactional_data,parameter= list(supp=0.002,conf=0.75),control=list(verbose=F),appearance =list(default="lhs",rhs=("Gender=Female")))
r4 = apriori(transactional_data,parameter= list(supp=0.005,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("Type.of.Travel=Personal Travel")))
r5 = apriori(transactional_data,parameter= list(supp=0.002,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("PassengerType=promoters")))

summary(rule)

inspectDT(rule[quality(rule)$lift > 1.5])

##oursin airlines
model.d = new_df %>% filter(Partner.Name == 'Oursin Airlines Inc.') %>% select("Gender","Airline.Status","Type.of.Travel","Class","PassengerType","AgeType","foodSpending","shopSpending","Sensitivity","LongDuration")
for(i in 1:ncol(model.d)) model.d[[i]] <- as.factor(model.d[[i]])
trans.d = as(model.d,"transactions")
#Flights cancelled
inspect(trans.d)

sort(itemFrequency(trans.d))

itemFrequencyPlot(trans.d,topN=20,col=brewer.pal(8,'Pastel2'))


trans.r2 = apriori(trans.d,parameter= list(supp=0.1,conf=0.8),control=list(verbose=F),appearance =list(default="lhs",rhs=("LongDuration=True")))
summary(trans.r2)

inspectDT(trans.r2[quality(trans.r2)$lift > 1.09])




#cancelled flights (consists of NA values)
mean(na_df$Flight.Distance) 
na_df = na_df %>% mutate(Long.Distance = case_when(Flight.Distance >= 614 ~ 'long trip',Flight.Distance < 614 ~'short trip'))

naSelected = na_df  %>% select("Gender","Airline.Status","Type.of.Travel","Class","PassengerType","Partner.Name","foodSpending","shopSpending","Sensitivity","AgeType","Long.Distance")
str(naSelected)
for(i in 1:ncol(naSelected))  naSelected[[i]] <- as.factor(naSelected[[i]])

transactional= as(naSelected,"transactions")
inspect(transactional)

sort(itemFrequency(transactional))

itemFrequencyPlot(transactional,topN=20,col=brewer.pal(8,'Pastel2'))
ct_temp = crossTable(transactional,sort=TRUE)
ct_temp[1:6,1:6]

na_rules = apriori(transactional,parameter= list(supp=0.05,conf=0.75),control = list(verbose=F))
plot(na_rules)

r = apriori(transactional,parameter= list(supp=0.1,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("Long.Distance=short trip")))
ra = apriori(transactional,parameter= list(supp=0.05,conf=0.75),control=list(verbose=F),appearance =list(default="lhs",rhs=("Gender=Female")))
rb = apriori(transactional,parameter= list(supp=0.1,conf=0.7),control=list(verbose=F),appearance =list(default="lhs",rhs=("AgeType=Adults")))

summary(ra)
inspectDT(ra[quality(ra)$lift > 1.38]) 






############# Generalized Additive Model using Splines for regression  ##########################################

#In the presence of multicollinearity, regression estimates are unstable and have high standard errors.

ggplot(new_df,aes(x=Likelihood.to.recommend)) + geom_density(color="blue",fill='black')
#Data split
m = new_df %>% select("Likelihood.to.recommend","Shopping.Amount.at.Airport","Eating.and.Drinking.at.Airport","Price.Sensitivity","Flights.Per.Year","Total.Freq.Flyer.Accts","Arrival.Delay.in.Minutes","Airline.Status","Gender","Class","longtrip") 



str(m)
set.seed(1234)

#create balanced splits of the data
#For Group k-fold cross-validation, the data are split such that no group is contained in both the modeling and holdout sets.
i = createDataPartition(m$Likelihood.to.recommend, 
                            times = 2, #number of partition
                            p = 0.6,
                            list = FALSE)
m_train = m[i,]
m_test = m[-i,]


#One hot encoding 
dmy = dummyVars( ~ .,data=m_train,levelsOnly = FALSE)
 
m.data = as.data.frame(predict(dmy,newdata = m_train))
names(m.data) 
summary(m.data)


dm = dummyVars( ~ .,data=m_test,levelsOnly = FALSE)


m.test = as.data.frame(predict(dm,newdata = m_test))
names(m.test) 
summary(m.data)



names(m.data)[names(m.data) == "ClassEco Plus"] = 'ClassEcoPlus'

names(m.test)[names(m.test) == "ClassEco Plus"] = 'ClassEcoPlus'
for(i in 1:ncol(m.data)) m.data[[i]] <- as.numeric(m.data[[i]])
train.control <- trainControl(method = "repeatedcv", 
                              number = 10, repeats = 3)


mod_gam = gam(Likelihood.to.recommend ~ Airline.StatusBlue + GenderFemale + ClassEco + s(Total.Freq.Flyer.Accts) + Price.Sensitivity+ Shopping.Amount.at.Airport + s(longtrip),data=m.data)
summary(mod_gam)
vis.concurvity(mod_gam)


# 
# vis.concurvity <- function(b, type="estimate"){
#   cc <- concurvity(b, full=FALSE)[[type]]
#   
#   diag(cc) <- NA
#   cc[lower.tri(cc)]<-NA
#   
#   layout(matrix(1:2, ncol=2), widths=c(5,1))
#   opar <- par(mar=c(5, 6, 5, 0) + 0.1)
#   # main plot
#   image(z=cc, x=1:ncol(cc), y=1:nrow(cc), ylab="", xlab="",
#         axes=FALSE, asp=1, zlim=c(0,1))
#   axis(1, at=1:ncol(cc), labels = colnames(cc), las=2)
#   axis(2, at=1:nrow(cc), labels = rownames(cc), las=2)
#   # legend
#   opar <- par(mar=c(5, 0, 4, 3) + 0.1)
#   image(t(matrix(rep(seq(0, 1, len=100), 2), ncol=2)),
#         x=1:3, y=1:101, zlim=c(0,1), axes=FALSE, xlab="", ylab="")
#   axis(4, at=seq(1,101,len=5), labels = round(seq(0,1,len=5),1), las=2)
#   par(opar)
# }

allgamFit <- train(Likelihood.to.recommend ~ ., data = m.data,
                method = "gam",
                family=Gamma(link=log),
                metric = "RMSE")


summary(allgamFit)

plot(allgamFit)


# Test data
testpred <- predict(allgamFit,
                            newdata = m.test,interval= "prediction") 

summary(testpred)  
postResample(pred = testpred, obs = m.test$Likelihood.to.recommend)





#Customer segments: customers age older than 65 with low nps score 


#Data split
model = new_df %>% filter(AgeType == 'Elderly') %>% select("Likelihood.to.recommend","Shopping.Amount.at.Airport","Eating.and.Drinking.at.Airport","Price.Sensitivity","Flights.Per.Year","Total.Freq.Flyer.Accts","Arrival.Delay.in.Minutes","longtrip") 



str(model)
set.seed(1234)

#create balanced splits of the data
#For Group k-fold cross-validation, the data are split such that no group is contained in both the modeling and holdout sets.
index = createDataPartition(model$Likelihood.to.recommend, 
                           times = 2, #number of partition
                           p = 0.6,
                           list = FALSE)
train = model[index,]
test = model[-index,]
str(test)
str(train)
summary(train)
train.control <- trainControl(method = "repeatedcv", 
                              number = 10, repeats = 3)

#The target outcome y given the features does not follow a Gaussian distribution.

ggplot(new_df,aes(x=Likelihood.to.recommend)) + geom_density()
#no linear relationship 
ggplot(new_df,aes(x=Likelihood.to.recommend,y=longtrip)) + geom_smooth() + scale_x_continuous(trans='log10') + scale_y_continuous(trans='log10')


gamFit <- train(Likelihood.to.recommend ~ ., data = train,
               method = "gam",
               trControl = train.control,
               metric = "RMSE")
summary(gamFit) #r squared is farily low so then we will try tuning the parameters
plot(gamFit)

#p value > 0.05 drop longtrip and dlight distance and departure delay in minutes
gamFit <- train(Likelihood.to.recommend ~ ., data = train,
                method = "gam",
                trControl = train.control,
                family=Gamma(link=log),
                metric = "RMSE")
summary(gamFit)


#class probabilities 
# Fit a logistic model

#predict the data
#for average  60 flights per year, the predicted number of promoters is -1.0 lower than the average prediction.

# Test data
test_predictions <- predict(gamFit,
                            newdata = test,interval= "prediction") 
summary(test_predictions)






################################  Random Forest Classification #######################################################

allrfm = new_df %>%  select("PassengerType","foodSpending","shopSpending","Gender","Airline.Status","Sensitivity","Type.of.Travel","Class","Partner.Name","LongDuration","AgeType") 
for(i in 1:ncol(allrfm)) allrfm[[i]] <- as.factor(allrfm[[i]])

set.seed(998)
allinTraining <- createDataPartition(allrfm$PassengerType, p = .75, list = FALSE)
alltraining <- allrfm[allinTraining,]
alltesting  <- allrfm[-allinTraining,]


#distribution of original data
table(allrfm$PassengerType) /nrow(allrfm)
table(alltraining$PassengerType) / nrow(alltraining)
table(alltesting$PassengerType) / nrow(alltesting)




allrf = randomForest(PassengerType ~ ., ntree = 100, data = alltraining,importance=TRUE)
plot(rf)
print(rf)
varImpPlot(rf,  
           sort = T,
           n.var=10,
           main="Top 10 - Variable Importance")

#Validation data using cross validation 
rfControl <- trainControl(method = "repeatedcv",
                          number = 10, repeats = 5,
                          classProbs = TRUE,
                          #summaryFunction = threeClassSummary,
                          search = "random")
set.seed(825)
mtry <- sqrt(ncol(alltraining))

tunegrid <- expand.grid(.mtry=mtry)

allrfFit <- train(PassengerType ~ ., data = alltraining,
               method = "rf",
               trControl = rfControl,
               metric = "Accuracy",
               tuneGrid=tunegrid,
               tuneLength = 15)

print(allrfFit)
plot(allrfFit)



allrfmPred <- predict(allrfFit, newdata = alltesting)
#interpret the results
confusionMatrix(allrfmPred, alltesting$PassengerType)

#Training for female passengers with blue airline status
rfm.fem = new_df %>% filter(Gender == 'Female' & Type.of.Travel == 'Personal Travel') %>%  select("PassengerType","foodSpending","shopSpending","Gender","Airline.Status","Sensitivity","Type.of.Travel","Class","Partner.Name","LongDuration","AgeType") 


rfm.fem$PassengerType = factor(rfm.fem$PassengerType)
summary(rfm.fem)
p = ggplot(rfm.fem,aes(x=Type.of.Travel,  
                   y=Airline.Status, 
                   color=PassengerType))

p + geom_jitter(alpha=0.3) +  
  scale_color_manual(breaks = c('promoters','detractors','passive'),
                     values=c('darkgreen','red','blue'))


rfmPred.fem <- predict(allrfFit, newdata = rfm.fem)
#interpret the results
confusionMatrix(rfmPred.fem, rfm.fem$PassengerType)


#we want to classify elderly with low nps score

rfm = new_df %>% filter(AgeType == 'Elderly' & LongDuration=="True") %>%  select("PassengerType","foodSpending","shopSpending","Gender","Airline.Status","Sensitivity","Type.of.Travel","Class","Partner.Name","LongDuration","AgeType") 
for(i in 1:ncol(rfm)) rfm[[i]] <- as.factor(rfm[[i]])

rfm$PassengerType = factor(rfm$PassengerType)
summary(rfm)
p = ggplot(rfm,aes(x=Type.of.Travel,  
                    y=Airline.Status, 
                    color=PassengerType))

p + geom_jitter(alpha=0.3) +  
  scale_color_manual(breaks = c('promoters','detractors','passive'),
                     values=c('darkgreen','red','blue'))

p1 = ggplot(rfm,aes(x=Sensitivity,  
                   y=Airline.Status, 
                   color=PassengerType))

p1 + geom_jitter(alpha=0.3) +  
  scale_color_manual(breaks = c('promoters','detractors','passive'),
                     values=c('darkgreen','red','blue'))

p1 = ggplot(rfm,aes(x=Gender,  
                    y=Airline.Status, 
                    color=PassengerType))

p1 + geom_jitter(alpha=0.3) +  
  scale_color_manual(breaks = c('promoters','detractors','passive'),
                     values=c('darkgreen','red','blue'))

p1 = ggplot(rfm,aes(x=Sensitivity,  
                    y=Airline.Status, 
                    color=PassengerType))

p1 + geom_jitter(alpha=0.3) +  
  scale_color_manual(breaks = c('promoters','detractors','passive'),
                     values=c('darkgreen','red','blue'))

set.seed(995)

sample.ind = replicate(20,sample(2,nrow(rfm),replace = TRUE, prob = c(0.05,0.95)))

#class imbalance problem
data.test = rfm[sample.ind==1,]
data.train = rfm[sample.ind==2,]
str(data.train)
str(data.test)

#
set.seed(998)
inTraining <- createDataPartition(rfm$PassengerType, p = .75, list = FALSE)
training <- rfm[ inTraining,]
testing  <- rfm[-inTraining,]


#distribution of original data
table(rfm$PassengerType) /nrow(rfm)
table(training$PassengerType) / nrow(training)
table(testing$PassengerType) / nrow(testing)



#distribution of training data
table(data.train$PassengerType) / nrow(data.train)
#distribution of test data
table(data.val$PassengerType) / nrow(data.val) #rouly the same ratio of promoters to detractors upon creating train and test data 



#Validation data using cross validation 
rfControl <- trainControl(method = "repeatedcv",
                          number = 10, repeats = 5,
                          classProbs = TRUE,
                          #summaryFunction = threeClassSummary,
                          search = "random")
set.seed(825)
mtry <- sqrt(ncol(training))
tunegrid <- expand.grid(.mtry=c(1:6))

rfFit <- train(PassengerType ~ ., data = training,
method = "rf",
trControl = rfControl,
metric = "Accuracy",
tuneGrid=tunegrid,
tuneLength = 15)

print(rfFit)
plot(rfFit)
#comparsion of two models

rfmPred.comp <- predict(allrfFit, newdata = rfm)


# rfmPred <- predict(rfFit, newdata = testing)
# #interpret the results
# confusionMatrix(rfmPred, testing$PassengerType)

confusionMatrix(rfmPred.comp, rfm$PassengerType)



rfm.air = new_df %>% filter(Partner.Name == 'Oursin Airlines Inc.') %>%  select("PassengerType","foodSpending","shopSpending","Gender","Airline.Status","Sensitivity","Type.of.Travel","Class","Partner.Name","LongDuration","AgeType") 
for(i in 1:ncol(rfm.air)) rfm.air[[i]] <- as.factor(rfm.air[[i]])
rfmPred.air <- predict(allrfFit, newdata = rfm.air)
confusionMatrix(rfmPred.air, rfm.air$PassengerType)

################################  Nature Language Processing   ###############################

charVector <- select(df,starts_with("freeText"))
posWords <- scan("positive-words.txt", character(0), sep = "\n")
negWords <- scan("negative-words.txt", character(0), sep = "\n")
charVector <- charVector %>% na.omit()

View(charVector)
summary(charVector)
summary(posWords)
#Clean unneeded rows
posWords = posWords[-1:-34]
View(posWords)
negWords = negWords[-1:-34]
View(negWords)


charVector <- VectorSource(charVector)

words.corpus <- Corpus(charVector)
words.corpus
words.corpus = tm_map(words.corpus,stripWhitespace) #remove whitespace
words.corpus = tm_map(words.corpus,content_transformer(tolower)) #convert to lower case
words.corpus = tm_map(words.corpus,removePunctuation)
words.corpus = tm_map(words.corpus,removeNumbers)
words.corpus = tm_map(words.corpus,removeWords,c(stopwords("english"),'flight','southeast','flights','seat','airline','first','flying',"got","didnt","one","delayed","delay","delays"))


nlp = DocumentTermMatrix(words.corpus)
nlp
ap_lda <- LDA(nlp, k = 4, control = list(seed = 1234))
topics <- tidy(ap_lda, matrix = "beta")
topics
ap_top_terms <- topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()

tdm <- TermDocumentMatrix(words.corpus)
tdm

inspect(tdm)
m = as.matrix(tdm)
wordCounts = rowSums(m)


#Step 1.A 
wordCounts <- sort(wordCounts, decreasing=TRUE)
View(wordCounts)


# a list of matched positive words 
# the numeric means a vector of the positions of (first) matches of its first argument in the file 
matchedP <- match(names(wordCounts), posWords, nomatch = 0) 
View(matchedP)
length(matchedP) #1211 positiv ewords
matchedN <- match(names(wordCounts), negWords, nomatch = 0) 


matchedP = wordCounts[matchedP != 0]
matchedDF = data.frame(count=matchedP,word=names(matchedP))

matchedDF %>% arrange(desc(count)) %>% 
  slice(1:30) %>% 
  ggplot() +
  geom_col(aes(y=count,x=reorder(word,count))) + 
  theme(axis.text.x = element_text(angle=90,hjust=1))

matchedN = wordCounts[matchedN != 0]
matchedDF.n = data.frame(count=matchedN,word=names(matchedN))

matchedDF.n %>% arrange(desc(count)) %>% 
  slice(1:20) %>% 
  ggplot() +
  geom_col(aes(y=count,x=reorder(word,count))) + 
  theme(axis.text.x = element_text(angle=90,hjust=1))

matchedDF %>% arrange(desc(count)) %>% 
  filter(count>1) %>%
  slice(1:20) %>% 
  ggplot() +
  geom_col(aes(y=count,x=reorder(word,count))) + 
  theme(axis.text.x = element_text(angle=90,hjust=1))

matchedDF.n %>% arrange(desc(count)) %>% 
  filter(count>1) %>%
  slice(1:20) %>% 
  ggplot() +
  geom_col(aes(y=count,x=reorder(word,count))) + 
  theme(axis.text.x = element_text(angle=90,hjust=1))

sum(matchedP)/sum(wordCounts) #0.09794582

sum(matchedN)/sum(wordCounts) #0.07546889
sum(matchedP)/sum(matchedN) #1.29783

#From the result,we can conclude the speech is a positive




matchedDF$word= as.character(matchedDF$word)
matched_order = c("word","count")
matchedDF = matchedDF[,matched_order]
View(matchedDF)
wordcloud2(data=matchedDF, color='random-dark')

matchedDF$word= as.character(matchedDF$word)

matchedDF.n = matchedDF.n[,matched_order]
View(matchedDF.n)
wordcloud2(data=matchedDF.n,  color="white", backgroundColor="pink")

