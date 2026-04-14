#!/bin/bash

#timestamp
dt=$(date +%Y%m%d%H%M%S)

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# CSS
cd $DIR/css
java -jar /usr/share/yui-compressor/yui-compressor.jar style.css -o style.min.css
java -jar /usr/share/yui-compressor/yui-compressor.jar custom.css -o custom.min.css
java -jar /usr/share/yui-compressor/yui-compressor.jar magnific.css -o magnific.css.min.css
java -jar /usr/share/yui-compressor/yui-compressor.jar normalize.css -o normalize.css.min.css

cat *min.css > $dt.css
echo $dt.css
#JS - is al minified
cd $DIR/js
cat *.js > $dt.js
echo $dt.js
#einde

