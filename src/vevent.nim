import std/times
import uuids
import strformat

proc veventFromString*(startDate: DateTime, summary: string, description: string = ""): string = 
  let dateStamp = startDate.format("YYYYMMdd") & "T" & startDate.format("HHmmss") & "Z"
  let dtStart = startDate.format("YYYYMMdd")
  let dtEnd = (startDate + 1.days).format("YYYYMMdd")
  result = fmt"""BEGIN:VEVENT
DTSTAMP:{dateStamp}
DTSTART;VALUE=DATE:{dtStart}
DTEND;VALUE=DATE:{dtEnd}
SUMMARY:{summary}
DESCRIPTION:{description}
UID:{$genUUID()}
END:VEVENT
"""

