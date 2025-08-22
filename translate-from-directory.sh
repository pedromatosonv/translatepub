mkdir -p translated
for f in text/*.html; do
  base="$(basename "$f")"
  echo "Translating $base"
  gemini -m $MODEL -p "$(< $TRANSLATOR_PROMPT)" < "$f" > "translated/$base"
done