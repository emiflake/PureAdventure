#!/usr/bin/env sh

mkdir -p out/tmp

npx pulp build --optimise > out/out.js
tail -1 out/out.js > out/tmp/mainCall.js
head -n -1 out/out.js > out/tmp/out.js
cat shim.js >> out/tmp/out.js
cat out/tmp/mainCall.js >> out/tmp/out.js
mv out/tmp/out.js out/out.js
rm -fr out/tmp