express = require 'express'
app = express()
fs = require 'fs'

app.use express.logger()
app.use express.static(__dirname+'/static')

app.get '/', (request, response) ->
  buffer = fs.readFileSync "index.html"
  response.header "Content-Type", "text/html"
  response.send buffer.toString()

port = process.env.PORT || 8080

app.listen port, ->
  console.log "Listening on #{port}"