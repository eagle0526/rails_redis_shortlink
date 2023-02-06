## 利用rails、redis打造短連結系統


練習實作一個短連結系統，用到的工具有Rails、Redis、TailWind CSS

### 此專案做到了哪些事情  
(1) 使用者新增的網址，可以生成一段短網址(短網址後段是亂數生成)   
(2) 生成的短網址會先存進資料庫   
(3) 再來存一份到Redis裡面  
(4) 使用者點擊短連結，會先從redis找該筆資料  
(5) 如果今天redis沒有該筆資料，而使用者還是點擊了，會去資料庫找連結，並且寫一份到redis裡面   
(6) 使用者點擊短連結後，會增加點擊次數       
(7) UTM功能  


### 實作心得

此專案是為了熟練redis而做的，其中用到的語法有hset、hget、hincrby、expire......等等語法，也讓我熟悉redis跟資料庫相比的優點，就是操作點擊增加次數、撈出數據都不用SQL語法就可以操作這些資料，如果今天數據量很大的話，不會影響到速度快慢(雖然現在沒有足夠的測試到XD)     

### 圖片範例

1、資料庫的資料
![image](/app/assets/images/database.png)

2、redis的資料
![image](/app/assets/images/redis.png)

3、新增link、UTM的欄位
![image](/app/assets/images/newlink.png)





## 完整短連結實作文章
[Rails、Redis實作短連結系統](https://eagle0526.github.io/rails%E3%80%81redis/2022-09-21-Rails-Redis%E5%AF%A6%E4%BD%9C%E7%9F%AD%E9%80%A3%E7%B5%90%E7%B3%BB%E7%B5%B1.html)




