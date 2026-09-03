#!/usr/bin/env bash
# Agent-readiness checks: fails the build if the machine-readable surface regresses.
# Run after `jekyll build`. Usage: bin/check-agent-ready.sh [site_dir]
set -euo pipefail
SITE="${1:-_site}"
fail=0
check() { # check <description> <grep-pattern> <file>
  if grep -q "$2" "$SITE/$3" 2>/dev/null; then
    echo "ok   $1"
  else
    echo "FAIL $1 (pattern '$2' not in $SITE/$3)"
    fail=1
  fi
}

check "404 page points agents at llms.txt"        'href="/llms.txt"'        404.html
check "404 page points agents at sitemap"          'href="/sitemap.xml"'     404.html
check "llms.txt has when-to-use guidance"          '## When to use'          llms.txt
check "llms-full.txt has when-to-use guidance"     '## When to use'          llms-full.txt
check "Organization JSON-LD has contactPoint"      '"contactPoint"'          index.html
check "Organization JSON-LD has PostalAddress"     '"PostalAddress"'         index.html
check "privacy page exists"                        'Privacy Policy'          privacy/index.html
check "footer links to privacy page"               'href="/privacy"'         index.html
check "about.md twin exists"                       'Ray Bogman'              about.md

# Trust anchor pages must have substantial content (>=500 chars of text).
for p in about contact privacy; do
  chars=$(sed -e 's/<[^>]*>//g' "$SITE/$p/index.html" | tr -d '[:space:]' | wc -c)
  if [ "$chars" -ge 500 ]; then
    echo "ok   /$p has ${chars} chars of content"
  else
    echo "FAIL /$p has only ${chars} chars (need >=500)"
    fail=1
  fi
done

exit $fail
