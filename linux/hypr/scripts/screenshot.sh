#!/usr/bin/env bash
# Uso: screenshot.sh [full|window|region]
case "${1:-region}" in
  full)   args=(full);   title="Pantalla completa" ;;
  window) args=(window); title="Ventana" ;;
  *)      args=();       title="Región" ;;
esac

# dms imprime la ruta del archivo guardado
f=$(dms screenshot "${args[@]}" --no-notify | tail -n1)
[ -f "$f" ] || exit 0   # cancelado: no notificar

notify-send -t 1500 -a Captura -h "string:image-path:$f" "$title" "Copiada y guardada"
