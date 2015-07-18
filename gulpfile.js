/* Gulp configuration file */

// add gulp packages
var gulp  = require('gulp'),
    gutil = require('gulp-util'),
    coffee = require('gulp-coffee'),
    jshint = require('gulp-jshint'),
    jade = require('gulp-jade'),
    sass = require('gulp-sass'),
    prettify = require('gulp-html-prettify'),
    server = require('gulp-server-livereload');

// create a default task and just log a message
gulp.task('log', function() {
  return gutil.log('Gulp is running!');
});

gulp.task('jade', function() {
  return gulp.src('./src/jade/[^_]*.jade')
    .pipe(jade())
    .pipe(prettify())
    .pipe(gulp.dest('./test/'));
});

gulp.task('sass', function () {
  gulp.src('./src/sass/[^_]*.sass')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./test/css'));
});

gulp.task('server', function() {
  gulp.src('test')
    .pipe(server({
      livereload: true
    }));
});
