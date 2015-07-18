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
gulp.task('default', ['server', 'watch']);
gulp.task('test', ['jade', 'sass', 'server', 'watch']);

gulp.task('watch', function() {
  gutil.log('Gulp is running!');

  var jadew = gulp.watch('./src/jade/*.jade', ['jade']);
  jadew.on('change', function(event) {
    gutil.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
  });

  var sassw = gulp.watch('./src/sass/*.sass', ['sass']);
  sassw.on('change', function(event) {
    gutil.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
  });

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
  gulp.src('./test/')
    .pipe(server({
      livereload: true
    }));
});
