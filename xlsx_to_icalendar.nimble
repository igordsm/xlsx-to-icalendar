# Package

version       = "0.1.0"
author        = "Igor Montagner"
description   = "Create .ics files from Excel spreadsheets"
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["xlsx_to_icalendar", "tag_to_calendar"]


# Dependencies

requires "nim >= 2.0.0"
requires "xl"
requires "uuids == 0.1.12"
