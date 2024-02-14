import std/[os, times]
import strutils
import re
import vevent

when isMainModule:
  var icsText = """
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//xlsx-to-icalendar v1.0//EN
"""

  for fname in walkDirRec(paramStr(1)):
    if fname.endsWith("md"):
      var st = readFile(fname)
      for line in st.split("\n"):
        if line =~ re"(?m)^(- \[(.)\]|#+)?(.*)#(\d\d\d\d-\d\d-\d\d).*$":
          if matches[1] == "X" or matches[1] == "x":
            continue
          let d = parse(matches[3], "yyyy-MM-dd")
          let rr = veventFromString(d, matches[2])
          icsText &= rr

  icsText = icsText.replace("\n", "\r\n")
  icsText &= "END:VCALENDAR"
  echo icsText

