module.exports = (grunt) ->

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')
        coffee:
            src:
                options:
                    bare:    yes
                expand:  yes
                flatten: yes
                src: ['*.coffee']
                cwd:  'src'
                ext:  '.js'
                dest: '.'
        browserify:
            events:
                options:
                    debug:yes
                    transform: ['coffeeify']
                files:
                    'events.browser.js': ['src/events.coffee']
        uglify:
            'events.browser':
                files:
                    'events.browser.min.js': ['events.browser.js']

    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-browserify'

    grunt.registerTask 'default', [
        'coffee'
        'browserify'
        'uglify'
    ]
