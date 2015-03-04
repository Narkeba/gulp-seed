gulp = require 'gulp'
plugins = require('gulp-load-plugins')()
stylish = require 'jshint-stylish'
del = require 'del'
mainBowerFiles = require 'main-bower-files'

env = process.env.NODE_ENV || 'development'

paths =
	assets: 'assets'
	build: 'build'

src =
	coffee: paths.assets + '/coffee/**/*.coffee'
	images: paths.assets + '/images/*'
	less: paths.assets + '/less/style.less'
	jade: paths.assets + '/jade/*.jade'

dist =
	coffee: paths.build + '/js/'
	images: paths.build + '/img/'
	less: paths.build + '/css/'
	jade: paths.build + '/'

watch =
	coffee: paths.assets + '/coffee/**/*.coffee'
	images: paths.assets + '/images/**/*.*'
	fonts: paths.assets + '/fonts/**/*.*'
	less: paths.assets + '/less/**/*.less'
	jade: paths.assets + '/jade/**/*.jade'

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

gulp.task 'coffee', 'clean', ->
	gulp.src src.coffee
		.pipe plugins.coffee bare: true
		.pipe plugins.jshint()
		.pipe plugins.jshint.reporter(stylish)
		.pipe plugins.uglify
		.pipe plugins.concat 'bundle.js'
		.pipe gulp.dest dist.coffee
		.pipe plugins.connect.reload()

gulp.task 'less', 'clean', ->
	gulp.src src.less
		.pipe plugins.less()
		.pipe plugins.autoprefixer "> 1%"
		.pipe plugins.cssmin, keepSpecialComments: 0
		.pipe gulp.dest dist.less
		.pipe plugins.connect.reload()

gulp.task 'jade', ->
	gulp.src src.jade
		.pipe plugins.jade()
		.pipe plugins.minifyHtml()
		.pipe gulp.dest dist.jade
		.pipe plugins.connect.reload()

gulp.task 'bower-js', ->
	gulp.src bowerFiles.js
		.pipe plugins.newer paths.build + 'scripts/vendor.js'
		.pipe plugins.concat 'vendor.js'
		.pipe gulp.dest dist.coffee

gulp.task 'bower-css', ->
	gulp.src bowerFiles.css
		.pipe plugins.cssmin keepSpecialComments: 0
		.pipe plugins.newer paths.build + 'scripts/vendor.css'
		.pipe plugins.concat 'vendor.css'
		.pipe gulp.dest dist.less

gulp.task 'connect', ->
	plugins.connect.server
		root: paths.build
		livereload: true

gulp.task 'clean', (cb) ->
	del [
		paths.build
	], cb

gulp.task 'watch', ->
	gulp.watch watch.coffee, ['coffee']
	gulp.watch watch.less, ['less']
	gulp.watch watch.jade, ['jade']
	gulp.watch watch.images, ['image']
	gulp.watch watch.jade, ['jade']

gulp.task 'assets', ['image', 'less', 'coffee', 'jade', 'bower-js', 'bower-css']

gulp.task 'default', ['assets', 'watch', 'connect']

gulp.task 'build', ['clean', 'assets']