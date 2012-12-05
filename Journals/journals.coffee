fs = require 'fs'
colors = require 'colors'

fs.readdir __dirname, (err, files)->
  has_no_files = []
  has_files = []
  checked_dirs = 0
  for file in files
    unless file in ['node_modules']
      if (fs.statSync __dirname + "/#{file}").isDirectory()
        checked_dirs++
        journals = fs.readdirSync __dirname + "/#{file}"
        if journals.length < 1
          has_no_files.push file
        else
          has_files.push file

  console.log "#{checked_dirs} have been checked"
  console.log String(checked_dirs - has_no_files.length).green + "/" + String(checked_dirs).green + ' complete'
  console.log "Some journal entries are missing".red
  for journal in has_no_files
    console.log journal.blue
  console.log "These are complete".green.bold
  for journal in has_files
    console.log journal.green


