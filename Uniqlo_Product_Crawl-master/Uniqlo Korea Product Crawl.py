# This Python file uses the following encoding: utf-8
import os
import openpyxl
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.alert import Alert
from openpyxl import workbook
import xlrd
import xlwt
from xlutils.copy import copy
from selenium.common.exceptions import NoSuchElementException,StaleElementReferenceException


wb = xlwt.Workbook(encoding='utf-8')
sheet = wb.add_sheet('write wb sheet name')


chrome_options = Options()
chrome_options.add_argument("disable-gpu")
chrome_options.add_argument("--disable-popup-blocking");
chrome_options.add_argument("test-type");
driver = webdriver.Chrome('chromedriver', chrome_options = chrome_options)


j=0

for startnum in range(startnumber, finishnubmer): # need to write number for set range
        driver.get("http://store-kr.uniqlo.com/display/showDisplayCache.lecs?goodsNo=NQ%d" % startnum)
        try:
            alert = driver.switch_to_alert()
            alert.accept()
        except:
            pass
        page_results = driver.find_elements_by_xpath('//*[@id="goodsNmArea"]')
        page_results
        

        for tit in page_results:
            print(tit.text) 
            sheet.write(j,1,tit.text) 
            j+=1 
            wb.save('2018_05_Uniqlo_Early_Link_Crawl_After_31100000_1.xls')