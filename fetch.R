library(quantmod)
library(zoo)

# I don't know that I can get quantmod on shiny.io, so suck up the data here
# and put it in a standard data frame for processing by a shiny app. 

# Sucks up data
setDefaults(getSymbols,src='FRED')
if(!exists('GDPPOT')){
    getSymbols('GDPPOT')
}
if(!exists('GDPC1')){
    getSymbols('GDPC1')
}
if(!exists('CPIAUCSL')){
    getSymbols('CPIAUCSL')
}
if(!exists('FEDFUNDS')){
    getSymbols('FEDFUNDS')
}
F<-data.frame(date=index(FEDFUNDS),F=coredata(FEDFUNDS))

# convert to data frames for fiddling. 
CPI <- data.frame(date=index(CPIAUCSL),CPI=coredata(CPIAUCSL))
P<-data.frame(date=index(GDPPOT),P=coredata(GDPPOT))
# Inflation: CPI of each month minus the CPI of one year earlier. 

I <- data.frame(date=CPI[,1][13:nrow(CPI)],
                I=(CPI[,2][13:nrow(CPI)]-CPI[,2][1:(nrow(CPI)-12)]))
O<-data.frame(date=index(GDPC1),O=coredata(GDPC1))
# Start and end dates I have to work with. 
beg_date<-max(O[1,1], I[1,1],P[1,1],F[1,1])
end_date<-min(O[nrow(O),1], I[nrow(I),1], P[nrow(P),1], F[nrow(F),1])

# Create splines so I can get data that I can plot all on one graph. Some data
# is collected quarterly or monthly, but we will plot weekly. 
fI<-splinefun(I[,1],I[,2])
fO<-splinefun(O[,1],O[,2])
fP<-splinefun(P[,1],P[,2])
fF<-splinefun(F[,1],F[,2])

dates<-seq(beg_date,end_date,by='week')

S<-data.frame(Date=dates, I=fI(dates), O=fO(dates), P=fP(dates),F=fF(dates))

S$N<-S$I + 2 + .5 * ( 2-S$I) + 50*(log(S$P)-log(S$O))
saveRDS(S,'econ.rds')
