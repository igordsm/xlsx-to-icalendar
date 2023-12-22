import xl
import os
import times
import strformat
import strutils
import uuids

proc main() = 
  if paramCount() < 1:
    echo("Usage: xlsx-to-icalendar file.xlsx")
    quit()

  let xlxsFile = xl.load(paramStr(1))
  let firstSheet = xlxsFile.sheet(0)

  var icsText = """
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//xlsx-to-icalendar v1.0//EN
"""


  for c in firstSheet.rows():
    try:
      var eventDate = c[0].date - 2.days # workaround for bug in xl
      eventDate = dateTime(eventDate.year, eventDate.month, eventDate.monthday, 0, 0, 0, 0, local())
      var dateStamp = eventDate.format("YYYYMMdd") & "T" & eventDate.format("HHmmss") & "Z"
      var dtStart = eventDate.format("YYYYMMdd")
      var dtEnd = (eventDate + 1.days).format("YYYYMMdd")
      var descrMaxSize = min(($c[3].value).len() - 1, 15)
      let summary = $c[2].value &  " (" & $c[3].value[0 .. descrMaxSize] & ")"

      var vevent = fmt"""BEGIN:VEVENT
DTSTAMP:{dateStamp}
DTSTART;VALUE=DATE:{dtStart}
DTEND;VALUE=DATE:{dtEnd}
SUMMARY:{summary}
UID:{$genUUID()}
END:VEVENT
"""

      icsText &= vevent


    except ValueError:
      discard
   
  icsText = icsText.replace("\n", "\r\n")
  icsText &= "END:VCALENDAR"

  echo icsText
when isMainModule:
  main()
