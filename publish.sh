#!/bin/bash
npm run build &&
git add -A &&
git commit -m "Publishing to gh-pages" &&
git checkout gh-pages &&
git merge master &&
git push origin gh-pages &&
git checkout master
