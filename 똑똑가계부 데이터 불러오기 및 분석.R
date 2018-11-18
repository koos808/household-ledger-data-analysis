library(RSQLite) # RSQLite 패키지 사용
# connect to the sqlite file
connection <- dbConnect(drv=SQLite(), dbname="spendmoney20180214.db")
dbDisconnect(connection) # 디스커넥트

# get a list of all tables
alltables = dbListTables(connection)
alltables
#쿼리로 가져오기
spend <- dbGetQuery(connection, "SELECT * FROM spendinglist;")
class(T)
#DB SELECT
dbGetQuery(connection, "SELECT * FROM spendinglist;") #지출내역
dbGetQuery(connection, "SELECT * FROM earninglist;") # 수입내역
dbGetQuery(connection, "SELECT * FROM cardlist;") # 카드리스트
dbGetQuery(connection, "SELECT * FROM budget;") # 예산
dbGetQuery(connection, "SELECT * FROM catelist;") #카테고리 리스트
dbGetQuery(connection, "SELECT * FROM ecatelist;") # 고정수입
# 고정지출

#보류
dbGetQuery(connection, "SELECT * FROM balacntlist;")
dbGetQuery(connection, "SELECT * FROM baldatalist;")
dbGetQuery(connection, "SELECT * FROM lastdatelist;")

head(dbGetQuery(connection, "SELECT * FROM spendinglist;")) #지출내역

library(dplyr)

write.csv(spend,'spend20180214.csv',row.names = F)

spend %>% arrange(s_date)

class(spend$s_date)
str(spend)


# 열형식과 필요없는 열 제거
ncol(spend)
spend<-spend[,-c(6,7,8,10,11,12)]

spend$s_date<-as.Date(spend$s_date)
spend$s_price<-as.numeric(spend$s_price)
str(spend)

k<-spend %>% filter(substr(s_date,1,4)==2017 & substr(s_date,6,7) %in% c("10","11"))
k

write.csv(spend,'spend20180214.csv',row.names = F)

install.packages('ggmap')
library(ggmap)
geocode(k$s_where)

#특정 단어를 제외하고 가져오기. grep 함수로 가능함.
# | 이용시 여러 단어 동시에 가능
index<-grep(c("버스|지하철"),k$s_where)
k<-k[-index,]

sampleindex<-grep("PC방|꼬치|한신|제주몬트락|단국신화|전설의 곱창|맥도날드|단대|단국|죽전",k$s_where)
a<-k[sampleindex,]
b<-geocode(unique(a$s_where))
b
geocode("보광 훼미리마트 단대보람점")

c<-data.frame(s_where=unique(a$s_where),lon=NA,lat=NA)
c[c(4,6,10,11,12,15,16,17),c(2,3)]<-b[c(4,6,10,11,12,15,16,17),]

s<-a %>% left_join(c,by='s_where')
write.csv(s,'s.csv',row.names = F)

install.packages('leaflet')
library(leaflet)
?leaflet
p<-na.omit(s)
leaflet() %>%
  addTiles() %>%
  addMarkers(lat = p$lat, lng = p$lon,popup=paste("장소 : ", p$s_where,"<br>","금액 : ",p$s_price))
m





