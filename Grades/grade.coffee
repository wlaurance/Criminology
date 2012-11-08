fs = require 'fs'

test_points = 150

fs.readFile __dirname + '/grades.json', (err, data)->
  throw err if err
  grades = JSON.parse data
  total_points = 0
  possible_points = 0
  for exam in grades.exams
    total_points += (exam.score / exam.max) * test_points
    possible_points += test_points
  for key,value of grades
    if typeof value is 'object'
      unless key is 'exams'
        total_points += value.score
        possible_points += value.max

  console.log "Total Points #{total_points}"
  console.log "Possible Points #{possible_points}"
  avg = (total_points / possible_points) * 100
  console.log "Average #{avg}"
  grade = ()->
    if avg > 90
      return 'A'
    if avg > 80
      return 'B'
    if avg > 70
      return 'C'
    else
      return 'FUCK'
  console.log "Grade #{grade()}"
