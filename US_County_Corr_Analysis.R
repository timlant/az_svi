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
                 EP_PCI as \"Per_Cap_Income\",
                 EP_NOHSDP as \"No_Diploma\",
                 EP_AGE65 as \"Age_65\",
                 EP_AGE17 as \"Age_17\",
                 EP_DISABL as \"Disability\",
                 EP_SNGPNT as \"Single_Parent\",
                 EP_AIAN as \"AIAN\",
                 EP_ASIAN as \"Asian\",
                 EP_AFAM as \"AFAM\",
                 EP_NHPI as \"Hawaiian\",
                 EP_HISP as \"Hispanic\",
                 EP_OTHER as \"Other_Race\",
                 EP_SPAN as \"Spanish_Speakers\",
                 EP_CHIN as \"Chinese_Speakers\",
                 EP_VIET as \"Vietnamese_Speakers\",
                 EP_KOR as \"Korean_Speakers\",
                 EP_RUS as \"Russian_Speakers\",
                 EP_MUNIT as \"Housing_10_Units\",
                 EP_MOBILE as \"Mobile_Homes\",
                 EP_CROWD as \"More_PPL_VS_Rooms\",
                 EP_NOVEH as \"No_Vehicle\",
                 EP_GROUPQ as \"Group_Quarters\",
                 R_HOSP as \"Hospitals\",
                 R_URG as \"Urgent_Care\",
                 R_PHARM as \"Pharmacies\",
                 R_PCP as \"PCPs\",
                 EP_UNINSUR as \"Uninsured\",
                 ER_CARDIO as \"Cardio_Death_Rate\",
                 ER_DIAB as \"Diabetes\",
                 ER_OBES as \"Obesity\",
                 ER_RESPD as \"Respiratory\",
                 EP_NOINT as \"No_Internet\"
                 FROM public.mh_svi_county_2018;
                 ")

res <- cor(df)

library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

