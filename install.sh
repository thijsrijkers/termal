INSTALL_DIR="${HOME}/.termal"
SCRIPT_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/termal.sh"
SCRIPT_DEST="${INSTALL_DIR}/termal.sh"

if [[ -n "${ZSH_VERSION}" ]] || [[ "$(basename "$SHELL")" == "zsh" ]]; then
  RC_FILE="${HOME}/.zshrc"
else
  RC_FILE="${HOME}/.bashrc"
fi

COLOR_TEAL="\033[36m"
COLOR_CYAN="\033[96m"
COLOR_RED="\033[31m"
COLOR_WHITE="\033[97m"
COLOR_RESET="\033[0m"

ok()   { echo -e "  ${COLOR_CYAN}[OK]${COLOR_RESET}  $1"; }
err()  { echo -e "  ${COLOR_RED}[ERR]${COLOR_RESET} $1"; }
info() { echo -e "  ${COLOR_TEAL}[..]${COLOR_RESET}  $1"; }

echo ""
echo -e "${COLOR_CYAN}  =================================="
echo -e "        TERMAL  INSTALLER"
echo -e "  ==================================${COLOR_RESET}"
echo ""

if [[ ! -f "${SCRIPT_SRC}" ]]; then
  err "termal.sh not found next to this installer."
  err "Make sure install.sh and termal.sh are in the same folder."
  echo ""
  exit 1
fi

info "Creating ${INSTALL_DIR} ..."
mkdir -p "${INSTALL_DIR}"
ok "Directory ready"

info "Copying termal.sh to ${SCRIPT_DEST} ..."
cp "${SCRIPT_SRC}" "${SCRIPT_DEST}"
chmod +x "${SCRIPT_DEST}"
ok "termal.sh installed"

SOURCE_LINE="source \"${SCRIPT_DEST}\""

if grep -qF "${SCRIPT_DEST}" "${RC_FILE}" 2>/dev/null; then
  ok "Source line already in ${RC_FILE} — skipping"
else
  info "Adding source line to ${RC_FILE} ..."
  echo "" >> "${RC_FILE}"
  echo "# Termal — wild encounters in your terminal" >> "${RC_FILE}"
  echo "${SOURCE_LINE}" >> "${RC_FILE}"
  ok "Source line added to ${RC_FILE}"
fi

echo ""
echo -e "${COLOR_CYAN}  =================================="
echo -e "       TERMAL INSTALLED!"
echo -e "  ==================================${COLOR_RESET}"
echo ""
echo -e "  ${COLOR_WHITE}Restart your terminal or run:${COLOR_RESET}"
echo -e "  ${COLOR_TEAL}source ${RC_FILE}${COLOR_RESET}"
echo ""
echo -e "  ${COLOR_WHITE}Then type  ${COLOR_TEAL}termal-help${COLOR_RESET}  ${COLOR_WHITE}to get started.${COLOR_RESET}"
echo ""