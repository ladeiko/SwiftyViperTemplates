#!/usr/bin/env bash

DST="${HOME}/.viperaptor/catalogs/SwiftyViperTemplates"

rm -rf "${DST}"
mkdir -p "${DST}"
cp -R ./* "${DST}/"
