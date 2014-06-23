path = require 'path'
fs = require 'fs'
es = require 'event-stream'
File = require 'vinyl'

# automatic coffeescript compiling
coffeescript = require 'coffee-script'
require.extensions['.coffee'] ?= (module, filename) ->
  content = coffeescript.compile fs.readFileSync filename, 'utf8', {filename}
  module._compile content, filename

packagePath = (file_path) ->
  paths = file_path.split('node_modules')
  paths.push("#{paths.pop().split('/').slice(0,2).join('/')}/package.json")
  return paths.join('node_modules')

createFile = (module_name, options) ->
  file_path = require.resolve(module_name)
  file = {cwd: __dirname, contents: new Buffer(fs.readFileSync(file_path, 'utf8'))}
  file.path = file_path.replace(__dirname, '')
  file.base = path.dirname(file.path)

  pkg = require(packagePath(file_path))
  file.path = file.path.replace(path.basename(file.path), "#{pkg.name}#{if options.version then '-'+pkg.version else ''}#{path.extname(file.path)}")
  return new File(file)

module.exports = (module_names, options={}) -> es.readArray(createFile(module_name, options) for module_name in module_names)
