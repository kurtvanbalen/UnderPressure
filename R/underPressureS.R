pressureWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 1207)
{
  require(RMariaDB)
  require(DBI)
  require(xts)
  require(plotly)
  require(knitr)
  require(htmlwidgets)
  require(widgetframe)
  require(dygraphs)
  require(timetk)

  # Connect to my-db as defined in ~/.my.cnf
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

  # You can fetch all results
  querry <- paste(paste("SELECT Timestamp, Pressure from PressureData where SensorID =", sensorID, sep = " "),"AND Timestamp BETWEEN '" ,sep = " ")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  #querry1 <- paste("SELECT Timestamp, Pressure FROM PressureData WHERE SensorID =", sensorID, sep = " ")
  #uerry2 <- paste("SELECT Timestamp, Pressure FROM PressureData WHERE SensorID =", sensorID2, sep = " ")
  #querry3 <- paste0(paste0(paste0(paste0(paste0(paste0("SELECT * FROM (", querry1),") AS tabel1 LEFT JOIN ("),querry2),") AS tabel2 ON tabel1.Timestamp = tabel2.Timestamp UNION SELECT * FROM (",querry1),") AS t1 RIGHT JOIN (", querry2), ") AS t2 ON t1.Timestamp = t2.Timestamp;")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2
  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  PressureG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("V1",color = "green")
  htmlwidgets::saveWidget(widgetframe::frameableWidget(PressureG),'dygraph_pressure_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

tempWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30")
{
  require(RMariaDB)
  require(DBI)
  require(xts)
  require(plotly)
  require(knitr)
  require(htmlwidgets)
  require(widgetframe)
  require(dygraphs)
  require(timetk)

  # Connect to my-db as defined in ~/.my.cnf
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

  # You can fetch all results:
  querry <- paste(paste("SELECT Timestamp, Temperature from TempData where SensorID =", sensorID, sep = " "),"AND Timestamp BETWEEN '" ,sep = " ")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2

  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  TempG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("V1",color = "red")
  htmlwidgets::saveWidget(widgetframe::frameableWidget(TempG),'dygraph_temp_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

humidWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30")
{
  require(RMariaDB)
  require(DBI)
  require(xts)
  require(plotly)
  require(knitr)
  require(htmlwidgets)
  require(widgetframe)
  require(dygraphs)
  require(timetk)

  # Connect to my-db as defined in ~/.my.cnf
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

  # You can fetch all results:
  querry <- paste(paste("SELECT Timestamp, Humidity from HumidityData where SensorID =", sensorID, sep = " "),"AND Timestamp BETWEEN '" ,sep = " ")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2

  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  HumidG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("V1",color = "blue")
  htmlwidgets::saveWidget(widgetframe::frameableWidget(HumidG),'dygraph_humid_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

