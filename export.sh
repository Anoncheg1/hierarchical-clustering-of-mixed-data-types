#!/bin/sh

for filename in $(find ./sources/ -maxdepth 1 -type f \
		       -not -name '*.html' -not -name '.nojekyll' \
		       -not -name '*.md' -not -name '*.png' -not -name 'export.sh' \
		       -not -name '.*.sh'); do
    echo "put ${filename}";
    newfn=$(basename $filename)
    cat ${filename}  | sed -e 's&^#+RESULTS:&/results/:&' -e 's/^-\*-.*//' > $newfn
    emacs "${newfn}" --eval "(progn (org-md-export-to-markdown) (save-buffers-kill-emacs))"
done
