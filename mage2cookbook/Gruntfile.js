/*
 * grunt-uncss
 * https://github.com/addyosmani/grunt-uncss
 *
 * Copyright (c) 2016 Addy Osmani
 * Licensed under the MIT license.
 */

'use strict';

/* jshint indent: 2 */

module.exports = function(grunt) {

  require('load-grunt-tasks')(grunt, {scope: 'devDependencies'});
  require('time-grunt')(grunt);

  // Project configuration.
  grunt.initConfig({
    jshint: {
      options: {
        jshintrc: '.jshintrc'
      },
      all: [
        'Gruntfile.js',
        'tasks/*.js',
        '<%= simplemocha.test.src %>'
      ]
    },

    // Before generating any new files, remove any previously-created files.
    clean: {
      tests: ['tmp', 'dist', 'css/output.css']
    },

    uncss: {
      dist: {
        src: ['index.html'],
        dest: 'css/tidy.css'
      },
      test: {
        files: {
          'css/output.css': 'index.html'
        },
        options: {
          report: 'gzip'
        }
      },
      testMany: {
        files: {
          'css/output.css': 'index.html',
        },
        options: {
          report: 'gzip'
        }
      },
      testUncssrc: {
        files: {
          'css/output.css': 'index.html'
        },
        options: {
          uncssrc: 'tests/.uncssrc'
        }
      }
    },

    processhtml: {
      dist: {
        files: {
          'index.html': 'index.html'
        }
      }
    },

    cssmin: {
      dist: {
        options: {
          compatibility: 'chrome',
          keepSpecialComments: 0
        },
        files: {
          '<%= uncss.dist.dest %>': '<%= uncss.dist.dest %>'
        }
      }
    },

    copy: {
      dist: {
        files: [{
          expand: true,
          cwd: '/',
          src: ['images/**', 'js/**', '*.png', '*.xml', '*.txt', '*.ico', '!*.html'],
          dest: '/'
        }]
      }
    },

    // Unit tests.
    simplemocha: {
      test: {
        src: 'tests/selectors.js'
      }
    },

    connect: {
      server: {
        options: {
          base: 'tests',
          port: 3000
        }
      }
    },

    watch: {
      files: ['Gruntfile.js', 'tasks/**/*.js', 'test/**/*.*'],
      tasks: ['jshint', 'test']
    }

  });

  // Actually load this plugin's task(s).
  grunt.loadTasks('tasks');

  grunt.registerTask('test', [
    'jshint',
    'uncss:test',
    'uncss:testMany',
    'uncss:testUncssrc',
    'simplemocha'
  ]);

  grunt.registerTask('dev', [
    'test',
    'connect',
    'watch'
  ]);

  // By default, lint and run all tests.
  grunt.registerTask('default', [
    'clean',
    'copy',
    'uncss:dist',
    'cssmin',
    'processhtml'
  ]);

};
