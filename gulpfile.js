/* Gulp configuration file */

// add gulp packages
var gulp  = require('gulp'),
    gutil = require('gulp-util'),
    // coffee = require('gulp-coffee'),
    // jshint = require('gulp-jshint'),
    jade = require('gulp-jade'),
    sass = require('gulp-sass'),
    prettify = require('gulp-html-prettify'),
    server = require('gulp-server-livereload');

var spawn = require('child_process').spawn;
/* Add tasks */

// setup server and watch for changes
gulp.task('default', ['server', 'watch']);

// build, setup server, and watch for changes
gulp.task('test', ['build', 'server', 'watch']);

// build to ./test/
gulp.task('build', ['jade', 'sass']);

// watch for changes and compile them
gulp.task('watch', function() {
  gutil.log('Gulp is running!');

  var jadew = gulp.watch('./src/jade/*.jade', ['jade']);
  jadew.on('change', function(event) {
    gutil.log('File ' + event.path.substr(event.path.lastIndexOf('/')+1) + ' was ' + event.type + ', compiling jade...');
  });

  var sassw = gulp.watch('./src/sass/*.sass', ['sass']);
  sassw.on('change', function(event) {
    gutil.log('File ' + event.path.substr(event.path.lastIndexOf('/')+1) + ' was ' + event.type + ', compiling sass...');
  });

  var gulpw = gulp.watch('./gulpfile.js', ['reload-gulp']);
  gulpw.on('change', function(event) {
    gutil.log('File ' + event.path.substr(event.path.lastIndexOf('/')+1) + ' was ' + event.type + ', reloading gulp...');
  });

});

// run livereloading server at test/
gulp.task('server', function() {
  return gulp.src('./test/')
    .pipe(server({
      livereload: true
    }));
});

gulp.task('jade', function() {
  return gulp.src('./src/jade/[^_]*.jade')
    .pipe(jade())
    .pipe(prettify())
    .pipe(gulp.dest('./test/'));
});

gulp.task('sass', function () {
  return gulp.src('./src/sass/[^_]*.sass')
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./test/css'));
});

// gulp.task('coffee', function () {
//   return gulp.src('./src/coffee/[^_]*.coffee')
//     .pipe(coffee())
//     .pipe(gulp.dest('./test/js'));
// });

gulp.task('reload-gulp', function() {
  spawn('gulp', [], {stdio: 'inherit'});
  process.exit();
});
