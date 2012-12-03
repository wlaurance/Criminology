fs = require 'fs'
colors = require 'colors'

fs.readdir __dirname, (err, files)->
  has_no_files = []
  checked_dirs = 0
  for file in files
    if (fs.statSync __dirname + "/#{file}").isDirectory()
      checked_dirs++
      journals = fs.readdirSync __dirname + "/#{file}"
      has_no_files.push file if journals.length < 1

  console.log "#{checked_dirs} have been checked"
  if has_no_files.length > 0
    console.log "Some journal entries are missing".red
    console.log String(has_no_files.length).red + "/" + String(checked_dirs).green

