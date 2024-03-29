pressureWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 929)
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

  # Verbindt met opencpu via config files in /etc/mysql/
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )
  #query voor 1 sensor tegelijk
  #querry <- paste(paste("SELECT Timestamp, Pressure from PressureData where SensorID =", sensorID, sep = " "),"AND Timestamp BETWEEN '" ,sep = " ")
  #querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")

  #querry voor 2 sensors tegelijk binnen te halen
  querry <- paste0(paste0(paste0("Select * FROM (select *
                                 from (
                                 select Timestamp, GROUP_CONCAT(case when SensorID=", sensorID)," then Pressure end) as Sensor1, GROUP_CONCAT(case when SensorID=",sensorID2)," then Pressure end) as Sensor2
                   from PressureData
                   group by Timestamp
                                 ) as sub
                   where Sensor1 is not NULL
                   or Sensor2 is not NULL) as t1 WHERE Timestamp BETWEEN '")
  #between timestamp toevoegen
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  #querry uitvoeren
  res <- dbSendQuery(con, querry)
  #resultaat binnenhalen en omzetten (dit wordt een dataframe)
  res2 <-dbFetch(res)
  #data frame aanpassen/ xts objects nodig voor time
  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  # plot maken met verschillende opties
  PressureG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "red") %>% dyOptions(connectSeparatedPoints = TRUE)
  #interactieve widget maken
  htmlwidgets::saveWidget(widgetframe::frameableWidget(PressureG),'dygraph_pressure_self.html', selfcontained = TRUE)
  # Resultaat verwijderen
  dbClearResult(res)

  # Conncetie afsluiten
  dbDisconnect(con)
}

tempWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 929)
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

  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

  querry <- paste0(paste0(paste0("Select * FROM (select *
                                 from (
                                 select Timestamp, GROUP_CONCAT(case when SensorID=", sensorID)," then Temperature end) as Sensor1, GROUP_CONCAT(case when SensorID=",sensorID2)," then Temperature end) as Sensor2
                   from TempData
                   group by Timestamp
                                 ) as sub
                   where Sensor1 is not NULL
                   or Sensor2 is not NULL) as t1 WHERE Timestamp BETWEEN '")
  querry <- paste0(paste0(paste0(paste0(querry, dateFrom), "%' AND '"), dateTo),"%';")
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)

  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)
  TempG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "red") %>% dyOptions(connectSeparatedPoints = TRUE)
  htmlwidgets::saveWidget(widgetframe::frameableWidget(TempG),'dygraph_temp_self.html', selfcontained = TRUE)

  dbClearResult(res)
  dbDisconnect(con)
}

humidWidget <- function(sensorID = 929, dateFrom = "2019-09-01", dateTo = "2019-09-30",sensorID2 = 929)
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

  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

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

  res2 <- xts::xts(res2[,-1], order.by = res2$Timestamp)

  HumidG <- dygraph(res2) %>% dyRangeSelector()  %>% dySeries("Sensor1",color = "red") %>% dyOptions(connectSeparatedPoints = TRUE)
  htmlwidgets::saveWidget(widgetframe::frameableWidget(HumidG),'dygraph_humid_self.html', selfcontained = TRUE)

  dbClearResult(res)
  dbDisconnect(con)
}
getdata <- function(id=929)
{
  require(RMariaDB)
  con <- dbConnect(
    drv = RMariaDB::MariaDB(),
    db = 'Opencpu'
  )

  querry <- paste0("Select Timestamp, Pressure from PressureData WHERE SensorID = ", id)
  res <- dbSendQuery(con, querry)
  res2 <-dbFetch(res)
  return(res2)
}
