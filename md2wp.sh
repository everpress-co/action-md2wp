#!/bin/bash
# Convert Markdown to Wordpress blogging format

ls -a

# Display usage if no parameters given
if [[ -z "$@" ]]; then
  echo " ${0##*/} <file.md> - convert Markdown to Wordpress blogging format"
  exit
fi

# Check if selection exists
for f in "$@"; do
  [ ! -f "$f" ] && echo " Selection \""$f"\" does not exist." && exit
done

# Convert
for md in "$@"; do
  file_html="${md%.*}".htm
  file_wdpr="${md%.*}".wdp

  ## Convert to HTML
  pandoc "$md" -o /tmp/"$file_html"  && echo " Converted to HTML."

  ## Convert HTML entities to UTF8
  ascii2uni -a Y /tmp/"$file_html" -q > "$file_wdpr"  && \
  echo " Converted HTML entities to UTF8."

  # Clean up code
  code_clnp () {

  ## Code blocks

  # Remove four space after <code> and during code blocks (fix for Gedit
  # having to use eight spaces for syntax recognition of code lines)
  sed -i 's/<code>    /<code>/g' "$file_wdpr"
  sed -i 's/^    //g'            "$file_wdpr"

  # Only <pre> tags necessary (i.e. not <pre><code>)
  sed -i 's|\(<pre*>\)<code>|\1|g' "$file_wdpr"
  sed -i 's|</code></pre>|</pre>|g' "$file_wdpr"

  # Use custom pre tag
  #sed -i 's|<pre*>|<pre style="overflow:auto;width=auto;border:solid #A4DEA4;border-width:.1em .1em .1em .6em;padding:.2em .4em .2em .6em;background-color:#F0FAF0;font-size:1em;white-space:pre;">|g' "$file_wdpr"

  ## Newlines

  # Newline after pre
  #sed -i 's|</pre>|</pre>\n|g'     "$file_wdpr"

  # Ensure blankline after code blocks
  sed -i -e ':a;N;$!ba;s|</pre>*\n\(.\{1\}\)|</pre>\n\n\1|g' "$file_wdpr"

  # Newline after headers
  sed -i 's/\(^<h[1-5].*\)/\1\n/g' "$file_wdpr"

  # Remove paragraph tags, newline after
  sed -i 's/<p>//g'    "$file_wdpr"
  sed -i 's|</p>|\n|g' "$file_wdpr"

  # Remove breaks
  sed -i 's/<br>//g'   "$file_wdpr"

  # Ensure blankline after lists
  sed -i -e ':a;N;$!ba;s|</ol>*\n\(.\{1\}\)|</ol>\n\n\1|g' "$file_wdpr"
  sed -i -e ':a;N;$!ba;s|</ul>*\n\(.\{1\}\)|</ul>\n\n\1|g' "$file_wdpr"
  
  # Ensure blankline after tables
  sed -i -e ':a;N;$!ba;s|</table>*\n\(.\{1\}\)|</table>\n\n\1|g' "$file_wdpr"
  
  ## Cleanup

  # Remove vim settings
  sed -i '/^<!-- vim:/d' "$file_wdpr"

  # Delete first line if blank
  sed -i '1{/^$/d}' "$file_wdpr"

  # Remove trailing blank lines
  while [ "$(tail -n 1 "$file_wdpr")" == "" ]; do
    sed -i '$d'  "$file_wdpr"
  done

  # Delete final newline
  perl -i -e 'local $/; $_ = <>; s/\n$//; print' "$file_wdpr"
  }
  
  code_clnp && echo " Cleaned up formating."
done