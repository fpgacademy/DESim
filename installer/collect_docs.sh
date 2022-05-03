#!/bin/bash
#
# This scripts collects the documentation for release.
# It creates 1 directories
# - dist/docs

if [ -d dist/docs ]
then
	rm -r dist/docs
fi

mkdir -p dist/docs

cp ../documentation/installation/*.pdf ./dist/docs/
cp ../documentation/tutorial/*.pdf ./dist/docs/

