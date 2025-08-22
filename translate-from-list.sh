FILES_LIST=(
  # ...
)

mkdir -p translated
for f in "${FILES_LIST[@]}"; do
  base="$(basename "$f")"
  echo "Translating $f"
  gemini -m $MODEL -p "$(< $TRANSLATOR_PROMPT)" < "$f" > "translated/$base"
done