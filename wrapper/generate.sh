#!/bin/bash

cd `dirname $0`
WEBPACK=../node_modules/webpack/bin/webpack.js
OUT=../src/DOM/Delegator/Foreign.purs

cat <<EOC > $OUT
module DOM.Delegator.Foreign (delegator) where

foreign import delegator """
if(typeof process !== 'undefined' && ({}).toString.call(process) === '[object process]'){
  // node
  var delegator = require('dom-delegator')();
} else {
EOC

$WEBPACK --output-library delegator delegator.js bundle.js 1>&2
cat bundle.js | tr -d '\r' >> $OUT

cat <<EOC >> $OUT
}
""" :: forall delegator. delegator
EOC
