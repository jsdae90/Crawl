library(data.table)
library(XML)

#대기오염정보조회 서비스 URL
url <- "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?"
sido_name <- "sidoName="
city <- "서울"
sido <- "&pageNo=1&numOfRows=10&ServiceKey="
ServiceKey <- "Your Service Key"
ver <- "&ver=1.3"

api_url <- paste(url,sido_name,city,sido,ServiceKey,ver,sep="")

api_url

#stationName만을 추출
read_xml(api_url) %>%
  xml_nodes('item') %>%
  xml_node('stationName') %>%
  xml_text()

#mangName만을 추출
read_xml(api_url) %>%
  xml_nodes('item') %>%
  xml_node('mangName') %>%
  xml_text()

#반복되는 부분을 items에 할당
items <- api_url %>% read_xml() %>% xml_nodes('item')

#필요 항목만 추출하는 사용자정의 함수를 생성
getXmlText <- function(x, var){
  result <- x %>% xml_node(var) %>% xml_text()
  return(result)
}

#사용자 정의 함수로 텍스트 데이터를 얻기 예제
측정소명 <- getXmlText(items, 'stationName')

#결과 확인
print(측정소명)

#전체 변수들의 정보를 얻기 위해 데이터프레임으로 정리
#stationName = 측정소(측정소 이름)
#mangName = 측정망 정보(국가배경, 교외대기, 도시대기, 도로변대기)
#dataTime = 측정일시(연.월.일.시간.분)
#so2Value = 아황가스 농도(단위:ppm)
#coValue = 일산화탄소 농도(단위:ppm)
#o3Value = 오존 농도(단위:ppm)
#no2Value = 이산화질소 농도(단위:ppm)
#pm10Value = 미세먼지(PM10) 농도(단위:㎍/㎥))
#pm10Value24 = 미세먼지(PM10) 24시간예측이동농도(단위:㎍/㎥))
#pm25Value = 미세먼지(PM2.5) 농도(단위:㎍/㎥))
#pm25Value24 = 미세먼지(PM2.5) 24시간예측이동농도(단위:㎍/㎥))
#khaiValue = 통합대기환경수치
#khaiGrade = 통합대기환경지수
#so2Grade = 아황산가스 지수
#coGrade = 일산화탄소 지수
#o3Grade = 오존지수
#no2Grade = 이산화질소 지수
#pm10Grade = 미세먼지(PM10) 24시간 등급자료
#pm25Grade = 미세먼지(PM2.5) 24시간 등급자료
#pm10Grade1h = 미세먼지(PM10) 1시간 등급
#pm25Grade1h = 미세먼지(PM2.5) 1시간 등급

#변수별 데이터를 추출하는 코드를 모아 df에 저장
df <- data.frame(
  측정소명 = getXmlText(items, 'stationName'),
  측정망정보 = getXmlText(items, 'mangName'),
  측정일시 = getXmlText(items, 'dataTime'),
  아황산가스농도 = getXmlText(items, 'so2Value'),
  일산화탄소농도 = getXmlText(items, 'coValue'),
  오존농도 = getXmlText(items, 'o3Value'),
  이산화질소농도 = getXmlText(items, 'no2Value'),
  미세먼지PM10농도 = getXmlText(items, 'pm10Value'),
  미세먼지PM10_24시간농도 = getXmlText(items, 'pm10Value24'),
  미세먼지PM2.5_농도 = getXmlText(items, 'pm25Value'),
  미세먼지PM2.5_24시간농도 = getXmlText(items, 'pm25Value24'),
  통합대기환경수치 = getXmlText(items, 'khaiValue'),
  통합대기환경지수 = getXmlText(items, 'khaiGrade'),
  아황산가스지수 = getXmlText(items, 'so2Grade'),
  일산화탄소지수 = getXmlText(items, 'coGrade'),
  오존지수 = getXmlText(items, 'o3Grade'),
  이산화질소지수 = getXmlText(items, 'no2Grade'),
  미세먼지PM10_24시간등급 = getXmlText(items, 'pm10Grade'),
  미세먼지PM2.5_24시간등급 = getXmlText(items, 'pm25Grade'),
  미세먼PM10_1시간등급 = getXmlText(items, 'pm10Grade1h'),
  미세먼지PM2.5_1시간등급 = getXmlText(items, 'pm25Grade1h')
)


#최종 결과 객체를 생성
compList <- data.frame()

#rbind를 이용하여 데이터를 추출
compList <- rbind(compList, df)

class(compList)

str(object = compList)
compList



#참고자료 : https://statkclee.github.io/data-product/dp-airquality-proto.html
#참고자료 : https://mrkevinna.github.io/R-Crawler-6/