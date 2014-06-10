var config       = require('./config.json');

var gulp         = require('gulp');
var sass         = require('gulp-ruby-sass');
var autoprefixer = require('gulp-autoprefixer');
var csscomb      = require('gulp-csscomb');
var minify       = require('gulp-minify-css');
var rename       = require('gulp-rename');
var concat       = require('gulp-concat');
var jshint       = require('gulp-jshint');
var uglify       = require('gulp-uglify');
var imagemin     = require('gulp-imagemin');
var clean        = require('gulp-clean');
var pngcrush     = require('imagemin-pngcrush');
var newer        = require('gulp-newer');
var plumber      = require('gulp-plumber');
var browserSync  = require('browser-sync');
var notify       = require('gulp-notify');


var onError = function (err) {
  console.log(err);
};


gulp.task('styles', function() {
    return gulp.src(config.devPath.sass)
        .pipe(plumber({
            errorHandler: onError
        }))
        .pipe(sass({
            style: 'expanded',
            compass: true
        }))
        .pipe(autoprefixer('last 2 version'))
        .pipe(csscomb())
        .pipe(gulp.dest(config.buildPath.styles))
        .pipe(minify())
        .pipe(rename({suffix: ".min"}))
        .pipe(gulp.dest(config.buildPath.styles))
        .pipe(browserSync.reload({stream:true, once: true}))
        // .pipe(livereload())
        .pipe(notify({ message: 'Styles task complete' }));
});


gulp.task('scripts', function() {
    return gulp.src(config.devPath.scripts)
        .pipe(plumber({
            errorHandler: onError
        }))
        .pipe(jshint('./.jshintrc'))
        .pipe(jshint.reporter('jshint-stylish'))
        .pipe(jshint.reporter('fail'))
        .pipe(concat('index.js'))
        .pipe(gulp.dest(config.buildPath.scripts))
        .pipe(rename({suffix: ".min"}))
        .pipe(uglify())
        .pipe(gulp.dest(config.buildPath.scripts))
        .pipe(notify({ message: 'Scripts task complete' }));
});


gulp.task('images', function () {
    return gulp.src(config.devPath.images)
        .pipe(plumber({
            errorHandler: onError
        }))
        .pipe(imagemin({
            optimizationLevel: 7,
            progressive: true,
            interlaced: true
        }))
        .pipe(gulp.dest(config.buildPath.images))
        .pipe(notify({ message: 'Images task complete' }));
});


gulp.task('clean', function() {
  return gulp.src([config.buildPath.styles, config.buildPath.scripts, config.buildPath.images], {read: false})
    .pipe(clean());
});


gulp.task('default', ['clean'], function() {
    gulp.start('styles', 'scripts', 'images');
});


gulp.task('browser-sync', function() {
    browserSync.init(null, {
      proxy: "127.0.0.1"
    });
});


gulp.task('watch', ['browser-sync'], function() {
    gulp.watch(config.devPath.scripts, ['scripts']);
    gulp.watch(config.devPath.sass, ['styles']);
});
