TERMAL_DIR="${HOME}/.termal"
CAUGHT_FILE="${TERMAL_DIR}/caught.txt"
CONFIG_FILE="${TERMAL_DIR}/config.txt"

declare -A TERMAL_ART

TERMAL_LIST=(
  "Vorbix" "Quelsh" "Drantu" "Fiznak" "Mopple"
  "Grubzel" "Snorvik" "Twemlo" "Blazzop" "Crumfish"
  "Yeldrop" "Huffnug" "Skvork" "Plontle" "Wazzit"
)

TERMAL_ART["Vorbix"]='
  .---.
 ( ^ ^ )
  )   (
 `-----'

TERMAL_ART["Quelsh"]='
  (o o)
  |---|
 /|   |\
| |___| |
 \|   |/'

TERMAL_ART["Drantu"]='
 )(o_o)(
 /|   |\
  |   |'

TERMAL_ART["Fiznak"]='
    -       -
  --  \   /  --
 /  -- (o) --  \
|  *    |    *  |
 \   ---+---   /
  --  /   \  --
    -       -'

TERMAL_ART["Mopple"]='
  .--.
 (o  o)
  \__/
  /\/\'

TERMAL_ART["Grubzel"]='
   ░░░░░░░
  ░ (°ω°) ░
  ░░     ░░
   ░░░░░░░'

TERMAL_ART["Snorvik"]='
        /\  /|
       /  \/  \
      | ^    ^ |
      |  ____  |
     /  / oo \  \
    /  /______\  \
   /__/   ||   \__\
          ||'

TERMAL_ART["Twemlo"]='
   ╔══════╗
   ║ zzZ  ║
   ║(•_• )║
   ╚══════╝'

TERMAL_ART["Blazzop"]='
  ) )   | |   ( (
 ) )  \ | | /  ( (
  \  --\   /--  /
   \  ( >_< )  /
    \_/  ___\_/
      | /   \ |
      |_\___/_|'

TERMAL_ART["Crumfish"]='
  .~~~.
 ( o o )
  `---'

TERMAL_ART["Yeldrop"]='
   ╭─────╮
   │ ~~~  │
   │(·‿·) │
   ╰─────╯'

TERMAL_ART["Huffnug"]='
        _____
    ___/     \___
   / .  z Z z  . \
  |  .  (- -)  .  |
  |  . (  ___) .  |
   \__|_/     \_|__/
      |  _____  |
      |_|     |_|'

TERMAL_ART["Skvork"]='
 \ | | /
  (o_o)
 / | | \'

TERMAL_ART["Plontle"]='
 o-o-o-o-o
(  . _ .  )
 o-o-o-o-o'

TERMAL_ART["Wazzit"]='
  ?  ?  ?  ?  ?
 ?  _________  ?
 ? / ??  ?? \ ?
?  |  ?    ?  | ?
?  |  ? __ ?  | ?
 ? \_??_??_??_/ ?
  ?     ???     ?
   ? ? ? ? ? ? ?'


_termal_init() {
  mkdir -p "${TERMAL_DIR}"
  [[ -f "${CAUGHT_FILE}" ]] || touch "${CAUGHT_FILE}"
  [[ -f "${CONFIG_FILE}" ]] || echo "enabled=true" > "${CONFIG_FILE}"
}

_termal_is_enabled() {
  grep -q "enabled=true" "${CONFIG_FILE}" 2>/dev/null
}

_termal_color() {
  echo -e "\033[${1}m${2}\033[0m"
}

_termal_is_caught() {
  grep -qx "$1" "${CAUGHT_FILE}" 2>/dev/null
}

_termal_encounter() {
  _termal_init
  _termal_is_enabled || return 0

  # ~15% chance per command
  (( RANDOM % 7 != 0 )) && return 0

  local name="${TERMAL_LIST[$(( RANDOM % ${#TERMAL_LIST[@]} ))]}"
  local art="${TERMAL_ART[$name]}"
  local already_caught=false

  _termal_is_caught "$name" && already_caught=true

  echo ""
  _termal_color "36" "=================================="
  _termal_color "96" "  * A wild Termal appeared! *"
  _termal_color "96" "  >>> ${name} <<<"
  _termal_color "36" "=================================="
  _termal_color "96" "${art}"
  echo ""
  if $already_caught; then
    _termal_color "36" "  [!] Already in your Termlist!"
  fi
  echo ""
  _termal_color "97" "  [c] Catch it    [r] Run away"
  echo -n "  > "

  local choice
  read -r -n1 choice
  echo ""

  case "${choice,,}" in
    c)
      if $already_caught; then
        _termal_color "36" "  You already have ${name}. It got away..."
      else
        echo "$name" >> "${CAUGHT_FILE}"
        local total
        total=$(wc -l < "${CAUGHT_FILE}")
        _termal_color "96" "  Yes! ${name} was caught!"
        _termal_color "96" "  Termlist: ${total}/15 termals caught"
      fi
      ;;
    r|*)
      _termal_color "31" "  Got away safely!"
      ;;
  esac

  _termal_color "36" "=================================="
  echo ""
}


termal-enable() {
  _termal_init
  echo "enabled=true" > "${CONFIG_FILE}"
  _termal_color "96" "[ON]  Termal encounters enabled!"
}

termal-disable() {
  _termal_init
  echo "enabled=false" > "${CONFIG_FILE}"
  _termal_color "31" "[OFF] Termal encounters disabled."
}

termal-list() {
  _termal_init
  local total="${#TERMAL_LIST[@]}"
  local caught_count=0
  [[ -f "${CAUGHT_FILE}" ]] && caught_count=$(grep -c . "${CAUGHT_FILE}" 2>/dev/null || echo 0)

  echo ""
  _termal_color "96" "  +========================+"
  _termal_color "96" "  |       TERMLIST         |"
  _termal_color "96" "  |  ${caught_count}/${total} termals caught   |"
  _termal_color "96" "  +========================+"
  echo ""

  local i=1
  for name in "${TERMAL_LIST[@]}"; do
    local num
    printf -v num "%02d" "$i"
    if _termal_is_caught "$name"; then
      _termal_color "96" "    [#${num}] ${name}"
    else
      _termal_color "90" "    [#${num}] ???"
    fi
    (( i++ ))
  done

  echo ""
  local status
  _termal_is_enabled \
    && status="$(_termal_color "96" "enabled")" \
    || status="$(_termal_color "31" "disabled")"
  echo -e "  Encounters: ${status}"
  echo ""
}

termal-help() {
  echo ""
  _termal_color "96" "  * Termal — Commands:"
  _termal_color "97" "  termal-enable   — Start wild encounters"
  _termal_color "97" "  termal-disable  — Stop wild encounters"
  _termal_color "97" "  termal-list     — View your Termlist"
  _termal_color "97" "  termal-help     — Show this help"
  echo ""
}

_termal_init

if [[ -n "${PROMPT_COMMAND}" ]]; then
  PROMPT_COMMAND="_termal_encounter; ${PROMPT_COMMAND}"
else
  PROMPT_COMMAND="_termal_encounter"
fi

echo ""
_termal_color "96" "  * Termal loaded!"
_termal_color "97" "  Type termal-help for commands."
echo ""

termal-help() {
  echo ""
  _termal_color "96" "  * Termal — Commands:"
  _termal_color "97" "  termal-enable   — Start wild encounters"
  _termal_color "97" "  termal-disable  — Stop wild encounters"
  _termal_color "97" "  termal-list     — View your Termlist"
  _termal_color "97" "  termal-help     — Show this help"
  echo ""
}

_termal_init

if [[ -n "${PROMPT_COMMAND}" ]]; then
  PROMPT_COMMAND="_termal_encounter; ${PROMPT_COMMAND}"
else
  PROMPT_COMMAND="_termal_encounter"
fi

echo ""
_termal_color "96" "  * Termal loaded!"
_termal_color "97" "  Type termal-help for commands."
echo ""