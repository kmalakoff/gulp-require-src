gulp-module-system
==================

Gulp plugin to create a file stream of required sources

```
gulp = require 'gulp'
requireSrc = require 'gulp-require-src'

gulp.task 'build', ->
  requireSrc(_.keys(require('./package.json').dependencies), {version: true}) # append the version
    .pipe(gulp.dest('vendor'))
```
