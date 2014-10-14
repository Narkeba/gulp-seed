gulp = require 'gulp'
plugins = require('gulp-load-plugins')()
stylish = require 'jshint-stylish'
lazypipe = require 'lazypipe'
mainBowerFiles = require 'main-bower-files'

env = process.env.NODE_ENV || 'development'

paths =
	assets: 'assets/'
	build: 'build/'

parseBower = (files) ->
	parsed =
		js: []
		css: []

	for file in files
		ext = file.split(".").pop()
		parsed[ext] = file

	return parsed

bowerFiles = parseBower mainBowerFiles
	includeDev: true

scriptCompress = lazypipe()
	.pipe plugins.uglify
	.pipe plugins.newer, paths.build + 'scripts/all.js'
	.pipe plugins.concat, 'all.js'

styleCompress = lazypipe()
	.pipe plugins.cssmin, keepSpecialComments: 0
	.pipe plugins.newer, paths.build + 'scripts/all.css'
	.pipe plugins.concat, 'all.css'

gulp.task 'coffee', ->
	gulp.src paths.assets + 'coffee/**/*.coffee'
		.pipe plugins.coffee bare: true
		.pipe plugins.jshint()
		.pipe plugins.jshint.reporter(stylish)
		.pipe plugins.if env is 'production', scriptCompress()
		.pipe gulp.dest paths.build + 'scripts'
		.pipe plugins.connect.reload()

gulp.task 'less', ->
	gulp.src paths.assets + 'less/**/*.less'
		.pipe plugins.less()
		.pipe plugins.autoprefixer "> 1%"
		.pipe plugins.if env is 'production', styleCompress()
		.pipe gulp.dest paths.build + 'styles'
		.pipe plugins.connect.reload()

gulp.task 'jade', ->
	gulp.src paths.assets + 'jade/*.jade'
		.pipe plugins.jade()
		.pipe plugins.minifyHtml()
		.pipe gulp.dest paths.build
		.pipe plugins.connect.reload()

gulp.task 'image', ->
	gulp.src paths.assets + 'images/*'
		.pipe plugins.imagemin
			optimizationLevel: 4
		.pipe gulp.dest paths.build + 'images'

gulp.task 'bower-js', ->
	gulp.src bowerFiles.js
		.pipe plugins.newer paths.build + 'scripts/vendor.js'
		.pipe plugins.concat 'vendor.js'
		.pipe gulp.dest paths.build + 'scripts'

gulp.task 'bower-css', ->
	gulp.src bowerFiles.css
		.pipe plugins.cssmin keepSpecialComments: 0
		.pipe plugins.newer paths.build + 'scripts/vendor.css'
		.pipe plugins.concat 'vendor.css'
		.pipe gulp.dest paths.build + 'styles'

gulp.task 'connect', ->
	plugins.connect.server
		root: paths.build
		livereload: true

gulp.task 'clean', ->
	plugins.rimraf paths.build

gulp.task 'watch', ->
	gulp.watch paths.assets + 'coffee/**/*.coffee', ['coffee']
	gulp.watch paths.assets + 'less/**/*.less', ['less']
	gulp.watch paths.assets + 'jade/**/*.jade', ['jade']
	gulp.watch paths.assets + 'images/**/*', ['image']

gulp.task 'assets', ['image', 'less', 'coffee', 'jade', 'bower-js', 'bower-css']

gulp.task 'default', ['assets', 'watch', 'connect']

gulp.task 'build', ['clean', 'assets']