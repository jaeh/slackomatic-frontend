#!/bin/bash

set -eu

PATH=$(pwd)/node_modules/.bin/:$PATH

DIST_DIR=dist/
SRC_DIR=src/
APPCACHE_FILE=slackomatic.appcache
CONFIG_FILE=config.js
TMP_DIR=.tmp/
SERVER_DIR=/server/slackomatic-frontend

function clean() {
  echo 'clean dist/'
  rm -rf dist/
  mkdir -p dist/js
}

# install installs dev npm modules, fonts, icons, and sets up the dist/ directory
function install() {
  mkdir -p dist/

  echo 'installing npm dependencies'
  npm install

  echo 'install a google webfont for local use and serving'
  node_modules/.bin/webfont-dl \
    https://fonts.googleapis.com/css?family=Ubuntu+Mono:400 \
    --font-out=src/font \
    --out src/css/include/font.styl \
    --css-rel=/font \
    --eot omit \
    --svg omit \
    --ttf omit \
  ;

  echo 'installing fontello icons'
  mkdir -p ${TMP_DIR}
  node_modules/.bin/fontello-cli install \
  --css ${TMP_DIR} \
  --font ${TMP_DIR} \
  --config ${SRC_DIR}fontello.json \
  ;

  mv ${TMP_DIR}slackomatic-embedded.css ${SRC_DIR}css/include/icons.styl

  mv \
    ${TMP_DIR}slackomatic.svg \
    ${TMP_DIR}slackomatic.eot \
    ${SRC_DIR}font/ \
  ;

  #~ rm -rf ${TMP_DIR}


  echo 'install app npm dependencies'
  cp package.json ${DIST_DIR}
  cd ${DIST_DIR}
  npm install --production
  cd ../
}

function build() {
  echo "create dist, ${DIST_DIR}css, ${DIST_DIR}js, ${DIST_DIR}log"
  mkdir -p ${DIST_DIR}css ${DIST_DIR}js

  echo "copy static files to dist"
  cp -rf \
    ${SRC_DIR}img/ \
    ${CONFIG_FILE} \
    ${SRC_DIR}favicon.ico \
    ${SRC_DIR}run.sh \
    ${DIST_DIR} \
  ;
  chmod +x ${SRC_DIR}run.sh

  echo "compile client side js"
  node_modules/.bin/browserify \
    ${SRC_DIR}js/index.js \
    --outfile ${DIST_DIR}js/slackomatic.js \
    -t babelify \
    --source-maps-inline \
  ;

  #~ echo 'uglify javascript source'
  #~ uglify \
    #~ --source ${DIST_DIR}js/slackomatic.js \
    #~ --output ${DIST_DIR}js/slackomatic.js \
  #~ ;

  echo "compile css files"
  node_modules/.bin/stylus \
    ${SRC_DIR}css/slackomatic.styl \
    --out ${DIST_DIR}css/slackomatic.css \
    --import node_modules/nib \
  ;

  echo "compile html files"
  node_modules/.bin/jade \
    ${SRC_DIR}html/home.jade \
    --out ${DIST_DIR} \
  ;

  # echo "html-inline the source (NOT WORKING - CSS IS MISSING)"
  # node_modules/.bin/html-inline \
  #   -i ${DIST_DIR}home.html \
  #   -o ${DIST_DIR}index.html \
  #   -b ${DIST_DIR} \
  # ;

  mv ${DIST_DIR}/home.html ${DIST_DIR}/index.html
  cp server.js ${DIST_DIR}/

  mkdir ${DIST_DIR}/node_modules
  cp -r node_modules/mime ${DIST_DIR}/node_modules

  # echo 'babelify the server.js'
  # node_modules/.bin/babel \
  #   server.js \
  #   --out-file dist/server.js \
  # ;
}

function upload() {
  echo 'create dist directory and prebuild app there'
  build;

  # echo 'remove all files from the source directory'
  # ssh pi@10.20.30.90 'rm -rf /home/pi/nodejs/* -r'
  # ssh pi@10.20.30.90 'rm -rf /server/screeninvader/*'

  echo 'copy the prebuilt dist directory to the production root'
  # scp -r ./dist/* pi@10.20.30.90:/home/pi/nodejs/
  rsync -rzvh dist/* pi@10.20.30.90:${SERVER_DIR}/

  # echo 'call killkillkill to kill the app and force respawn by inittab'
  # curl http://10.20.30.90/killkillkill
  echo 'all done'
 }

function run() {
  # echo 'start watchify and push it to background'
  # node_modules/.bin/watchify \
  #   src/js/main.js -t babelify -o dist/js/bundle.js \
  #   -- 1> ./watchify.log 2> ./watchify.log &

  # echo 'starting app with nodemon on port 1337'
  node_modules/.bin/nodemon dist/server.js 1337
}

if [ $1 ]
then
  function=$1
  shift
  $function $@
fi
