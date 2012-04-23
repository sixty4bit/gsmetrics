GSMetrics is a simple Gem to help you with pushing data into Google Spreadsheets.

You can install it by calling

```gem install gsmetrics```

Development was started so we could run a cron job in regular intervals and push metrics data about Railsonfire to a Google Spreadsheet.

## Usage

Create a new GSMetrics Session and a worksheet, then append to it and create as many rows as you like:

```ruby
session = GSMetrics::Session.new("YOUR_GOOGLE_USERNAME, "YOUR_GOOGLE_PASSWORD")
session.worksheet "SPREADSHEET_TITLE, "WORKSHEET_TITLE"
worksheet << 1
worksheet.append(5)
worksheet.next_row
worksheet.append(10)
worksheet.save
```

You simply add to the current row with either ***<<*** or ***.append()***. When calling ***next_row*** the current data is stored away for later saving and you can start adding new items again.

The whole worksheet is updated in one batch call, so only one HTTP request is sent.

You can also set the exact row in the worksheet the data should be saved into. This is very handy if you have a worksheet that you need to update completely.

The following example saves all rows you added starting with the row id of 5. So if you added 2 rows to the worksheet the rows 5 and 6 will be added/overwritten in the spreadsheet.

```ruby
worksheet.save 5
```
When you do not specify any row it will be automatically added to the end.

After saving a row all appended data is removed and you can start with a new row.


###Authentication
GSMetrics doesn't suppot OAUTH login with Google any more, as it was painful to implement and not worthwile for us. If you are interrested in having this we gladly accept a pull request.

Copyright (c) 2011-2012 Florian Motlik, licensed under MIT License

Based on the gem template by https://github.com/goncalossilva/gem_template