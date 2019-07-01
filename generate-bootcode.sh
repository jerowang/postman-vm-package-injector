#!/bin/bash

packages=$(cat packages.config | sed -e "s/,/ /g" | sed -e ':a;N;$!ba;s/\n//g')

if [ -d "postman-sandbox" ]; then
	rm -rf postman-sandbox
fi

git clone --depth=1 --single-branch --branch master https://github.com/postmanlabs/postman-sandbox.git
cd postman-sandbox

npm i -D $packages
cd lib/
mv environment.js environment.orig.js

cp ../../environment.js ./
cp -r ../../packages/* vendor/
node environment.js

cd ..
npm run cache

cd ..
if [ ! -d "_out" ]; then
	mkdir _out
elif [ "$(ls -A _out/)" ]; then
	rm _out/*
fi

cp postman-sandbox/.cache/* _out/

if [ -f app.asar ]; then
	if [ -d "asar_temp" ]; then
		rm -rf asar_temp
	fi

	asar e app.asar ./asar_temp
	rm asar_temp/node_modules/postman-sandbox/.cache/*
	cp _out/* asar_temp/node_modules/postman-sandbox/.cache/
	mv app.asar app.old.asar
	asar p ./asar_temp app.asar
	
	#rm -rf asar_temp
fi

#rm -rf postman-sandbox