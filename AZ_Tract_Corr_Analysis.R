library(RPostgreSQL)

tryCatch({
  drv <- dbDriver("PostgreSQL")
  print("Connecting to Database…")
  connec <- dbConnect(drv, 
                      dbname = "djlittle",
                      host = "postgis.rc.asu.edu", 
                      port = 5432,
                      user = "djlittle", 
                      password = "coda")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})

df <- dbGetQuery(connec, "SELECT 
                    EP_POV as \"Poverty\",
                 EP_UNEMP as \"Unemployed\",
                 EP_NOHSDP as \"No_Diploma\",
                 EP_AGE65 as \"Age_65\",
                 EP_AGE17 as \"Age_17\",
                 EP_DISABL as \"Disability\",
                 EP_SNGPNT as \"Single_Parent\",
                 ep_minrty as \"Minority\",
                 EP_MUNIT as \"Housing_10_Units\",
                 EP_MOBILE as \"Mobile_Homes\",
                 EP_CROWD as \"More_PPL_VS_Rooms\",
                 EP_NOVEH as \"No_Vehicle\",
                 EP_GROUPQ as \"Group_Quarters\"
                 FROM public.az_svi_tract;
                 ")

res <- cor(df)

library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

library("PerformanceAnalytics")
chart.Correlation(df, histogram=TRUE, pch=19)
