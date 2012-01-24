GSMetrics is a simple Gem to help you with pushing data into Google Spreadsheets.

You can install it by calling

```gem install gsmetrics```

Development was started so we could run a cron job in regular intervals and push metrics data about Railsonfire to a Google Spreadsheet.

To start using it simply run

``` gsmetrics ```

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

Every row is added in one batch call, so only one HTTP request is sent for every row.

You can also set the exact row in the worksheet the data should be saved into. This is very handy if you have a worksheet that you need to update repeatedly.

The following example saves the worksheet to row nr 1. The rows start with 1 in Googledocs.
```ruby
worksheet.save_row 5
```

The following example sets the number of rows in the worksheet beforehand and then disables the check if there is still a free row. By default gsmetrics checks
if there is a free row at the end of the worksheet and if not adds one. If you know beforehand the number of rows you need (e.g. daily updated list of users) you can
set the worksheet size and disable the check. This makes the upload process much faster, as the check doesn't have to be made before every new row is added.
```ruby
set_worksheet_size 5
worksheet.check_worksheet_size = false
worksheet << 1
worksheet.save_row
```

After saving a row all appended data is removed and you can start with a new row.
Please make sure there are only empty lines at the end of the spreadsheet as the first empty line is used to write the data.


### Worksheet ID

You can find out what your worksheet_id is by going to

https://spreadsheets.google.com/feeds/worksheets/#{your_document_id}/private/full

For every worksheet there will be an <entry> element which has an id. The last part of the id (something like od6) is the worksheet_id you have to provide.
If you find a better way to get that information or would implement an extension to the executable to go over the api and get that information you are very welcome.

Copyright (c) 2011 Florian Motlik
Based on the gem template by https://github.com/goncalossilva/gem_template