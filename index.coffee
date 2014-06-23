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

createFile = (module_name) ->
  file_path = require.resolve(module_name)
  file = {cwd: __dirname, contents: new Buffer(fs.readFileSync(file_path, 'utf8'))}
  file.path = file_path.replace(__dirname, '')
  file.base = file.path.replace(path.basename(file.path), '')

  package_info = require(path.resolve(packagePath(file_path)))
  file_name = "#{package_info.name}#{if options.version then '-'+package_info.version else ''}#{path.extname(file.path)}"
  file.path = path.join(file.path.replace(path.basename(file.path), ''), file_name)
  return new File(file)

module.exports = (module_names, options={}) -> es.readArray(createFile(module_name) for module_name in module_names)
