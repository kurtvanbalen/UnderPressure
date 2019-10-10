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
  #query voor 1 sensor tegelijk
  #querry <- paste(paste("SELECT Timestamp, Pressure from PressureData where SensorID =", sensorID, sep = " "),"AND Timestamp BETWEEN '" ,sep = " ")
  #querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")

  #querry voor 2 sensors tegelijk
  querry <- paste0(paste0(paste0("Select * FROM (select *
                                 from (
                                 select Timestamp, GROUP_CONCAT(case when SensorID=", sensorID)," then Humidity end) as Sensor1, GROUP_CONCAT(case when SensorID=",sensorID2)," then Humidity end) as Sensor2
                   from HumidityData
                   group by Timestamp
                                 ) as sub
                   where Sensor1 is not NULL
                   or Sensor2 is not NULL) as t1 WHERE Timestamp BETWEEN '")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2
  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  PressureG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "green") %>% dyOptions(connectSeparatedPoints = TRUE)
  htmlwidgets::saveWidget(widgetframe::frameableWidget(PressureG),'dygraph_pressure_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

tempWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 1207)
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
  querry <- paste0(paste0(paste0("Select * FROM (select *
                                 from (
                                 select Timestamp, GROUP_CONCAT(case when SensorID=", sensorID)," then Humidity end) as Sensor1, GROUP_CONCAT(case when SensorID=",sensorID2)," then Humidity end) as Sensor2
                   from HumidityData
                   group by Timestamp
                                 ) as sub
                   where Sensor1 is not NULL
                   or Sensor2 is not NULL) as t1 WHERE Timestamp BETWEEN '")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2

  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  TempG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "red")
  htmlwidgets::saveWidget(widgetframe::frameableWidget(TempG),'dygraph_temp_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

humidWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 1207)
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
  querry <- paste0(paste0(paste0("Select * FROM (select *
                                 from (
                                 select Timestamp, GROUP_CONCAT(case when SensorID=", sensorID)," then Humidity end) as Sensor1, GROUP_CONCAT(case when SensorID=",sensorID2)," then Humidity end) as Sensor2
                   from HumidityData
                   group by Timestamp
                                 ) as sub
                   where Sensor1 is not NULL
                   or Sensor2 is not NULL) as t1 WHERE Timestamp BETWEEN '")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  #res2

  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken
  HumidG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "blue")
  htmlwidgets::saveWidget(widgetframe::frameableWidget(HumidG),'dygraph_humid_self.html', selfcontained = TRUE)
  # Clear the result
  dbClearResult(res)

  # Disconnect from the database
  dbDisconnect(con)
}

