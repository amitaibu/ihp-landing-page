CSS_FILES += ${IHP}/static/vendor/flatpickr.min.css
CSS_FILES += static/app.css

JS_FILES += ${IHP}/static/vendor/jquery-3.6.0.slim.min.js
JS_FILES += ${IHP}/static/vendor/timeago.js
JS_FILES += ${IHP}/static/vendor/flatpickr.js
JS_FILES += ${IHP}/static/helpers.js
JS_FILES += ${IHP}/static/vendor/morphdom-umd.min.js
JS_FILES += ${IHP}/static/vendor/turbolinks.js
JS_FILES += ${IHP}/static/vendor/turbolinksInstantClick.js
JS_FILES += ${IHP}/static/vendor/turbolinksMorphdom.js

include ${IHP}/Makefile.dist

tailwind-dev: node_modules
	node_modules/.bin/tailwind -c tailwind/tailwind.config.js -i ./tailwind/app.css -o static/app.css --watch

node_modules:
    NODE_ENV=production npm ci

static/app.css: node_modules
	NODE_ENV=production npm ci
	NODE_ENV=production node_modules/.bin/tailwind -c tailwind/tailwind.config.js -i ./tailwind/app.css -o static/app.css --minify