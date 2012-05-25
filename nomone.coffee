fs      = require 'fs'
xml2js  = require 'xml2js'

filesParsed = 0
filesToParse = 0

parsedEntries = []

homeDirectoryEnvName = if process.platform is 'win32' then 'USERPROFILE' else 'HOME'
userHomeDirectory = process.env[homeDirectoryEnvName]
entriesDir = userHomeDirectory + '/Dropbox/Journal.dayone/entries/'

parseData = (data) ->
  content = data.toString()
  parser = new xml2js.Parser
  parser.addListener 'end', (result) ->
    filesParsed++
    parsedEntries.push {
      date: result.dict.date,
      body: result.dict.string[0]
    }
    console.log "res", result
    console.log parsedEntries if filesParsed is filesToParse
  parser.parseString content
  

readFile = (fullPath) ->
  fs.readFile fullPath, (err, data) -> parseData data 

fs.readdir entriesDir, (err, fileNames) ->
    throw err if err
    filesToParse = fileNames.length
    for fileName in fileNames
      readFile entriesDir + fileName
      


