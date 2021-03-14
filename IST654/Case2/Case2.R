#load the data
CAPM = read.csv("./Downloads/Case1CAPM.csv")

temp = read.csv("./Downloads/Market Factor.csv")
View(temp)
appleRET = temp$AppleRET
appleRF = temp$RF

appleEXERT = appleRET-appleRF

#dimension and names of the variables
dim(CAPM)
names(CAPM)

View(CAPM)

DATE = as.Date(as.character(temp$DATE),"%Y%m%d")
#excess returns of IBM
ibmRET = CAPM$IBMRET

RF = CAPM$RF
IBMEXERT = ibmRET-RF

jpeg(filename="Case_IBMEXERT.jpeg")

plot(DATE,temp$appleMEXERT,type="l",xlab="year",ylab="daily excess return(%)",main="IBM Excess Return(%)")
dev.off()
#compute the arithmetic mean of IBM excess return
appleMean = mean(appleEXERT)*252

#compute the standard deviation of IBM return
appleSTD = sd(appleEXERT)*sqrt(252)
appleSTD
#compute the sharp ratio of IBM excess return
appleSR = appleMean / appleSTD
appleSR
#compute the 5% value at risk of IBM excess return
IBMVaR = quantile(IBMEXERT,probs=c(0.05))
IBMVaR

#create a table to compare all the statistics 
comparison = data.frame(IBMMean,IBMSTD,IBMSR,IBMVaR)
View(comparison)

install.packages("PerformanceAnalytics")
install.packages("xts")
install.packages("zoo")
install.packages("e1071")
install.packages("tseries")
install.packages("nortest")
library(tseries)
library(xts)
library(zoo)
library(PerformanceAnalytics)
library(e1071)
library(nortest)
IBMEXERT_raw = IBMEXERT/100
IBMS_raw = ES(IBMEXERT_raw,p=.05,method="historical")
IBMES = IBMS_raw*100


#Boxplot of IBM excess return
boxplot(appleEXERT,main="Boxplot of IBM excess return",ylab="daily excess return(%)")
#histogram of IBM excess return
hist(IBMEXERT,main="Daily IBM Excess returns(percentage)",prob=TRUE,xlab="IBM Excess Return",ylab="Density",ylim=c(0,0.25),breaks=50)

appleMRET = temp$MarketRET
appleMRF = temp$RF

appleMEXERT = appleMRET-appleMRF
marketskew = skewness(appleMEXERT)
marketKur = kurtosis(appleMEXERT)
IBMskew = skewness(IBMEXERT)
IBMskew
IBMkurto = kurtosis(IBMEXERT)
IBMkurto 
#the results tell that p value less than 0.05 so we reject the numm hypothese
#in this case it does not follow a normal distribution
jarque.bera.test(IBMEXERT)
#same her the data is nor normally distrbuted
lillie.test(IBMEXERT)

as.numeric(CAPM$MarketEXERT)
temp = CAPM$MarketEXRET
marketEXERT = CAPM$MarketEXRET
MKTskew<-skewness(marketEXERT)

MKTkurto<-kurtosis(marketEXERT)
MKTsd<-sd(marketEXERT)*sqrt(252)

MKTsr<-MKTmean/MKTsd
Name<-c("Mean:", "Std:", "Skewness:", "Kurtosis:","Sharpe Ratio","Value at Risk","Expected Shortfall","Correlation:" )

IBM<-c(IBMMean, IBMSTD, IBMskew, IBMkurto, IBMsr, IBMVaR, IBMES, IBMcMarket)

Market<-c(MKTmean, MKTsd, MKTskew, MKTkurto, MKTsr,MKTVaR, MKTES, NA)

MKTmean<-mean(temp)*252
MKTmean
sd(appleEXERT)
sd(appleMEXERT)
MKTsd<-sd(marketEXERT)*sqrt(252)
#sharpe ratiop of IBM excess return 
IBMSR = IBMMean / IBMSTD

MKTsr<-MKTmean/MKTsd
MKTVaR = quantile(temp, probs = c(0.05))
MKT_raw<- temp/100

MKTES_raw<-ES(MKT_raw, p=.05,method="historical")

MKTES<-MKTES_raw*100

jarque.bera.test(appleEXERT)
lillie.test(appleEXERT)
