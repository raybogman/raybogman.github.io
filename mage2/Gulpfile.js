var gulp = require('gulp');
var uncss = require('gulp-uncss');
var cssMinify = require('gulp-minify-css');

gulp.task('uncss', function() {
  return gulp.src(['css/tmp/*.css'])
    .pipe(uncss({
      html: [
        'index.html'
      ]
    }))
    .pipe(cssMinify())
    .pipe(gulp.dest('css/'));
});
