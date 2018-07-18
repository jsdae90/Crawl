# 임대주택모집공고 Crawl
library(sendmailR)
library(XML)
library(httr)
library(stringr)
library(mailR)
library(lubridate)
library(data.table)
library(rvest)
#Rselenium이 isntall.packages로 현재 설치가 되지 않아 
#아래와 같은 방식으로 설치해야 함.
#library(devtools)
#install_version("binman", version = "0.1.0")
#install_version("wdman", version = "0.2.2")
#install_version("RSelenium", version = "1.7.1")
#                   or
#devtools::install_github("johndharrison/binman")
#devtools::install_github("johndharrison/wdman")
#devtools::install_github("ropensci/RSelenium")

#cmd창에 적어줄 코드
#java -Dwebdriver.gecko.driver="geckodriver.exe" -jar 
#selenium-server-standalone-3.12.0.jar -port 4445

setwd("c://Rselenium")

require(RSelenium)

driver <- rsDriver()
#창이 뜨면 그다음부터 단계 진행

remDr <- driver[["client"]]

remDr$navigate("https://www.myhome.go.kr/hws/portal/sch/selectRsdtRcritNtcView.do")

html <- remDr$getPageSource()[[1]]
html <- read_html(html)
html

#######xpath 이용

#row별 테스트
firstlinexp = "//*[@id='schTbody']/tr[1]"
secondlinexp = "//*[@id='schTbody']/tr[2]"
thirdlinexp = "//*[@id='schTbody']/tr[3]"
fourthlinexp = "//*[@id='schTbody']/tr[4]"
fifthlinexp = "//*[@id='schTbody']/tr[5]"
sixthlinexp = "//*[@id='schTbody']/tr[6]"
seventhlinexp = "//*[@id='schTbody']/tr[7]"
eighthlinexp = "//*[@id='schTbody']/tr[8]"
ninthlinexp = "//*[@id='schTbody']/tr[9]"
tenthlinexp = "//*[@id='schTbody']/tr[10]"


#xpath 이용한 row별 데이터 crawl
first <- html_children(html) %>% 
  html_nodes(xpath = firstlinexp) %>%
  as.character() %>%
  gsub(pattern = "<.*?>", replacement = "") %>%
  strsplit(split = "\n") %>%
  unlist() %>%
  .[. != ""]

first

# 사용자 정의 함수를 통해 코드 간소화
myhome = function(x){
      html_children(html) %>% 
      html_nodes(xpath = x) %>%
      as.character() %>%
      gsub(pattern = "<.*?>", replacement = "") %>%
      strsplit(split = "\n") %>%
      unlist() %>%
      .[. != ""]
}

# 1페이지의 1 to 10 공고글의 정보를 가져옴
first <- myhome(firstlinexp)
second <- myhome(secondlinexp)
third <- myhome(thirdlinexp)
fourth <- myhome(fourthlinexp)
fifth <- myhome(fifthlinexp)
sixth <- myhome(sixthlinexp)
seventh <- myhome(seventhlinexp)
eighth <- myhome(eighthlinexp)
ninth <- myhome(ninthlinexp)
tenth <- myhome(tenthlinexp)
tenth

table <- rbind(first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth)
table

# 변수명 작성
colname = c("공급유형", "진행상태", "지역", "공고명", "모집공고일자", "공급기관")

colnames(table) = colname

table


# 결과 table을 png이미지로 저장
library(gridExtra)
#800x400, 뒷배경  흰색의 'result.png'로 저장
png(filename = "result.png", width = 800, height = 400, bg = "white") 
# table에 선을 그림
grid.table(table)
# 파일로 생성
dev.off()

#이메일 전송
send.mail(from = "from email address",
          to = c("to email address"),
          subject = "Result of MyHome Crawl",
          body =  '<p> Result of MyHome Crawl </p>
                  <img src = "Path of Image">',
          html = TRUE,
          inline = TRUE,
          smtp = list(host.name = "smtp.gmail.com", port = 465, user.name = "your gmail", passwd = "email passwd", ssl = TRUE),
          authenticate = TRUE,
          attach.files=c("C://Rselenium//result.png"),
          send = TRUE
)

