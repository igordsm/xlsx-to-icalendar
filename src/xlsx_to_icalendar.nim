import xl
import os
import times
import strformat
import strutils
import uuids

proc eventsInFile(fname: string): string =
  result = ""
  try:
    let xlxsFile = xl.load(fname)
    let firstSheet = xlxsFile.sheet(0)

    for c in firstSheet.rows():
      try:
        var eventDate = c[0].date  # workaround for bug in xl
        eventDate = dateTime(eventDate.year, eventDate.month, eventDate.monthday, 0, 0, 0, 0, local())
        var dateStamp = eventDate.format("YYYYMMdd") & "T" & eventDate.format("HHmmss") & "Z"
        let dtStart = eventDate.format("YYYYMMdd")
        let dtEnd = (eventDate + 1.days).format("YYYYMMdd")
        let summary = $c[2].value
        let description = $c[3].value.replace("\n", "\\n")

        var vevent = fmt"""BEGIN:VEVENT
DTSTAMP:{dateStamp}
DTSTART;VALUE=DATE:{dtStart}
DTEND;VALUE=DATE:{dtEnd}
SUMMARY:{summary}
DESCRIPTION:{description}
UID:{$genUUID()}
END:VEVENT
"""
        result &= vevent
      except ValueError:
        discard
 
  except OSError:
    discard


proc main() = 
  if paramCount() < 1:
    echo("Usage: xlsx-to-icalendar file.xlsx")
    quit()

  var icsText = """
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//xlsx-to-icalendar v1.0//EN
"""

  for i in 1 .. paramCount():
    let fname = paramStr(i)
    icsText &= eventsInFile(fname)
  
  icsText = icsText.replace("\n", "\r\n")
  icsText &= "END:VCALENDAR"
  echo icsText

when isMainModule:
  main()
