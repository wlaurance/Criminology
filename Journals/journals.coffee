fs = require 'fs'
colors = require 'colors'
async = require 'async'
{wc} = require 'wc'

WC_LINE_LIMIT = process.env.WC_LINE_LIMIT || 60

fs.readdir __dirname, (err, files)->
  has_no_files = []
  has_files = []
  checked_dirs = 0
  iterator = (file, cb)->
    unless file in ['node_modules']
      if (fs.statSync __dirname + "/#{file}").isDirectory()
        checked_dirs++
        journals = fs.readdirSync __dirname + "/#{file}"
        if journals.length < 1
          has_no_files.push file
          cb()
        else
          fs.readFile __dirname + "/#{file}/journal.md", (err, data)->
            has_files.push
              wc_data:wc data.toString()
              file_path:"#{file}/journal.md"
            cb()
      else
        cb()
    else
      cb()

  async.forEach files, iterator, (err)->
    console.log "#{checked_dirs} have been checked"
    console.log String(checked_dirs - has_no_files.length).green + "/" + String(checked_dirs).green + ' complete'
    console.log "Some journal entries are missing".red if has_no_files.length > 0
    for journal in has_no_files
      console.log journal.blue
    for journal in has_files
      console.log journal.file_path.green
      switch journal.wc_data[0] < WC_LINE_LIMIT
        when true
          console.log "Needs more lines #{journal.wc_data[0]} / #{WC_LINE_LIMIT}".red
        else
          console.log "Has enough enough lines #{journal.wc_data[0]} / #{WC_LINE_LIMIT}".green


