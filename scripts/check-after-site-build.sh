#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -n $TRAVIS && $CI_TASK != build* ]]; then
  echo "check-all: nothing to check since this isn't a build task."
  exit 0;
fi

travis_fold start check_links
(set -x; ./scripts/shared/check-links.sh)
travis_fold end check_links

# Check output from Jekyll plugin
travis_fold start check_for_bad_filenames
if [[ -e code-excerpt-log.txt ]]; then
  (set -x; grep 'BAD FILENAME' code-excerpt-log.txt && exit 1)
fi
travis_fold end check_for_bad_filenames

travis_fold start check_for_code_excerpt_misformatting_in_html
(set -x; ./scripts/check-for-code-excerpt-misformatting.sh)
travis_fold end check_for_code_excerpt_misformatting_in_html

travis_fold start check_for_numbered_files_in_html
(set -x; ./scripts/check-for-numbered-files-in-html.sh)
travis_fold end check_for_numbered_files_in_html
