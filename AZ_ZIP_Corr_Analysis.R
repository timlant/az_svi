library(RPostgreSQL)

tryCatch({
  drv <- dbDriver("PostgreSQL")
  print("Connecting to Database…")
  connec <- dbConnect(drv, 
                      dbname = "census",
                      host = "postgis.rc.asu.edu", 
                      port = 5432,
                      user = "djlittle", 
                      password = "coda")
  print("Database Connected!")
},
error=function(cond) {
  print("Unable to connect to Database.")
})

df <- dbGetQuery(connec, "select 
                 cast(DEATHS as float)/cast(POPULATION as float) as death_rate, 
                 cast(s2201_c01_021e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as poverty_rate,
                 cast(s2201_c01_025e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as white_rate,
                 cast(s2201_c01_026e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as african_american_rate,
                 cast(s2201_c01_027e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as american_indian_rate,
                 cast(s2201_c01_028e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as asian_rate,
                 cast(s2201_c01_029e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as hawaiian_rate,
                 cast(s2201_c01_030e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as other_race_rate,
                 cast(s2201_c01_031e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as two_or_more_races_rate,
                 cast(s2201_c01_032e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as hispanic_rate,
                 cast(s2201_c01_033e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as not_hispanic_rate,
                 --s2201_c01_034e as median_income,
                 s2201_c02_023e/100 as disability_rate,
                 cast(s2201_c03_001e as float) /cast(public.acs_2019_snap_w_race.s2201_c01_001e as float) as snap_rate
                 from 
                 public.zip_code_deaths
                 left join 
                 public.population_by_zip
                 on 
                 RIGHT(public.population_by_zip.geoid , 5) = text(public.zip_code_deaths.zipcode )
                 left join 
                 public.acs_2019_snap_w_race
                 on 
                 RIGHT(public.acs_2019_snap_w_race.geo_id , 5) = text(public.zip_code_deaths.zipcode )
                 where 
                 public.population_by_zip.geoid is not null
                 and public.acs_2019_snap_w_race.s2201_c01_001e>0
                 ")

res <- cor(df)

library(corrplot)
corrplot(res, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)


model = lm(death_rate~
             poverty_rate 
           , data=df)

summary(model)