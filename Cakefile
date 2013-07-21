# Config ------------------------------------------------
cake = {}
cake.coffee = batch: {}  # Compiles and minifies each batch
cake.coffee.folders = ['.']
cake.template = batch: {} # Build JSON id:html Array from files in path
cake.less = batch: {}
# sbuild Task -------------------------------------------

fs     = require 'fs'
{exec} = require 'child_process'

task 'sbuild', 'Build single application file from source files', ->
  compile = (out, appFiles) ->
    appContents = new Array remaining = appFiles.length
    for file, index in appFiles then do (file, index) ->
      fileContents = fs.readFileSync "#{file}.coffee", 'utf8'
      appContents[index] = fileContents
      process out, appContents if --remaining is 0

  process = (out, appContents) ->
    fs.writeFileSync "#{out}-raw.coffee", appContents.join('\n\n'), 'utf8'
    exec "coffee --compile #{out}-raw.coffee", (err, stdout, stderr) ->
      throw err if err
      console.log stdout + stderr
      fs.unlink "#{out}-raw.coffee", (err) ->
        throw err if err
      exec "uglifyjs -o #{out}-min.js #{out}-raw.js", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink "#{out}-raw.js", (err) ->
          throw err if err
          console.log "#{out}-min.js compiled and minified."

  if cake.template and cake.template.batch
    for out, ini of cake.template.batch
      templates = []
      for tmpl in fs.readdirSync ini.path
        if /\.html?$/.test tmpl
          html = fs.readFileSync(ini.path + tmpl).toString()
          template =
            id: tmpl.replace(/\.html?$/i, "")
            html: html
          templates.push template
          fs.writeFileSync out, ini.prefix + JSON.stringify templates

  compileCSS = (out, lessFiles) ->
    lessContents = new Array remaining = lessFiles.length
    for file, index in lessFiles then do (file, index) ->
      fileContents = fs.readFileSync "#{file}.less", 'utf8'
      lessContents[index] = fileContents
      processCSS out, lessContents if --remaining is 0

  processCSS = (out, lessContents) ->
    fs.writeFileSync "#{out}-raw.less", lessContents.join('\n\n'), 'utf8'
    exec "lessc -x #{out}-raw.less #{out}-min.css", (err, stdout, stderr) ->
      throw err if err
      console.log stdout + stderr
      fs.unlink "#{out}-raw.less", (err) ->
        throw err if err

  if cake.less and cake.less.batch
    for out, lessFiles of cake.less.batch
      compileCSS out, lessFiles

  if cake.coffee and cake.coffee.batch
    for out, appFiles of cake.coffee.batch
      compile out, appFiles

  if cake.coffee and cake.coffee.folders
    for dir in cake.coffee.folders
      exec "coffee --compile #{dir}/*.coffee", (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
