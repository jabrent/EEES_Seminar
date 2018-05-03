library(tidyverse)
library(sf)
library(rgdal)
library(maps)

#make adjustments to the column types
l_records <- read_csv("./data/processed_data/lrecordscombined.csv", col_types = cols(
  INDH_NR = col_character(),
  INDHANDL_DATO = col_character(),
  YEAR = col_integer(),
  LANDINGSDATO = col_character(),
  SAELGER_JUR_PERS_ID = col_integer(),
  KOEBER_JUR_PERS_ID = col_integer(),
  KOEBER_BY_BYGD = col_character(),
  KOEBER_POSTNR = col_character(),
  SAELGER_BY_BYGD = col_character(),
  SAELGER_POSTNR = col_integer(),
  FARTOEJ_KATEGORI = col_character(),
  MOTOR_HK = col_double(),
  FTJ_LAENGDE_DANGEROUS = col_double(),
  KVOTE_TYPE_KODE = col_character(),
  ANVENDELSE_KODE = col_character(),
  ANVENDELSE_TEKST = col_character(),
  ART_KODE = col_character(),
  ART_DK = col_character(),
  ART_UK = col_character(),
  ART_LATIN = col_character(),
  BEHGRD_KODE = col_character(),
  MAENGDE = col_double(),
  LEV_VAEGT = col_double(),
  INDH_ANTAL_TJEK_JN = col_character(),
  ANTAL_INDIVIDER = col_character(),
  STOERRELSE_KODE = col_character(),
  VAERDI = col_double(),
  FISKERITIMER = col_double(),
  FISTRAWLTYPE_TYPE = col_character(),
  TTYPEUK = col_character(),
  TTYPEDK = col_character(),
  ANTAL_REDSKABER = col_integer(),
  BREDDEGRAD = col_character(),
  LAENGDEGRAD = col_character(),
  FANGSTFELT = col_character(),
  LOGBOGSNR = col_character()
))

#read in centroids 
centroids <- rgdal::readOGR("./data/GIS/FIeld Codes/Field Code Centroids/field_code_centroids.shp")

codes <- as.data.frame(centroids)

#read in all of the locations where people live, and add a dummy variable that says 
#whether people live above or below 68 degrees
geocoded <- read_csv("./data/GIS/Basemaps/Placenames/geocoded_with_missing_lat_longs.csv") %>%
  select(city = cities, lat, lon) %>%
  mutate(arctic = ifelse(lat >= 68, "Northerners", "Southerners")) %>%
  select(-lat, -lon)

#read in all of the catch records
md <- l_records %>%
  filter(ART_KODE == "GHL") %>%
  group_by(date = LANDINGSDATO, year = YEAR, seller_loc = SAELGER_BY_BYGD, buyer_loc = KOEBER_BY_BYGD, boat_cat = FARTOEJ_KATEGORI, field_code = FANGSTFELT) %>%
  summarize(weight = sum(LEV_VAEGT), count = n()) %>%
  left_join(geocoded, by = c("seller_loc" = "city")) %>%
  left_join(codes, by = c("field_code" = "name")) %>%
  rename(lat = coords.x2, lng = coords.x1)

#create a new data frame that filters the catch records to just small boats, a.k.a. jolle
df <- md %>%
  filter(boat_cat == "JOLLE", year != 2017) %>%
  group_by(arctic, lat, lng, year) %>%
  summarize(weight = sum(weight)) %>%
  mutate(weight_scale = log10(weight))

#bring in some map data
greenland <- map_data("world") %>%
  filter(region == "Greenland")

#produce one map with part of Greenland cut horizontally
ggplot(df) +
  geom_polygon(data = greenland, color = "black", fill = "white", aes(x = long, y = lat, group = group)) +
#  stat_density2d(aes(x = lng, y = lat, z = weight, fill = ..level..), geom = "polygon", n = 100) +
  geom_contour(aes(x = lng, y = lat, z = weight_scale, color = arctic)) +
  scale_y_continuous(limits = c(59, 80)) +
  scale_x_continuous(limits = c(-75, -35))

#produce 3 maps of Greenland, one for each variable type (people from north, south, and NAs)
ggplot(df) +
  geom_polygon(data = greenland, color = "black", fill = "white", aes(x = long, y = lat, group = group)) +
  geom_point(aes(x = lng, y = lat, size = weight, color = arctic), alpha = 0.5) + 
  geom_hline(yintercept = 68) +
  facet_grid(.~arctic) +
  labs(x = "", y = "") +
  scale_x_continuous(limits = c(-75, -35)) +
  scale_size_continuous(name = "Weight of Fish (kg)") +
  scale_color_discrete(name = "Home Region of Sellers") +
  theme_minimal()

#save maps as PNGs
ggsave("./region.png", dpi = 900, width=  12, height = 6)
ggsave("./years_region.png", dpi = 900, width = 12, height = 6)





