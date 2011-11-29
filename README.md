GSMetrics is a simple Gem to help you with pushing data into Google Spreadsheets.

Development was started so we could run a cron job in regular intervals and push metrics data about Railsonfire to a Google Spreadsheet.

To start using it simply run

gsmetrics

and follow the instructions given. You will have to create a new google API Project and after
finishing all steps get code you can simply paste into your codebase.

## Usage

Create a new GSMetrics Session and a worksheet, then append to it and save the row:

```ruby
session = GSMetrics::Session.new(client_id, client_secret, refresh_token)
worksheet = session.worksheet document_id, worksheet_id
worksheet << 1
worksheet.append(5)
worksheet.save_row
```

You can find out what your worksheet_id is by going to

https://spreadsheets.google.com/feeds/worksheets/#{your_document_id}/private/full

For every worksheet there will be an <entry> element which has an id. The last part of the id (something like od6) is the worksheet_id you have to provide.
If you find a better way to get that information or would implement an extension to the executable to go over the api and get that information you are very welcome.

Copyright (c) 2011 Florian Motlik
Based on the gem template by https://github.com/goncalossilva/gem_template