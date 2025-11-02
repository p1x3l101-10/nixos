#!/usr/bin/env bash

# Unset the usually good checks
set +o errexit
set +o nounset
set +o pipefail

HEADPHONES_NAME="alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.iec958-stereo"
HEADPHONES_MIC_NAME="alsa_input.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.mono-fallback"
HMD_NAME="wivrn.sink"
HMD_MIC_NAME="wivrn.source"

function getPWNameFromNick() {
  local nodeNick="$1"
  pw-cli ls | \
    grep -B 5 "node.nick = \"${nodeNick}\"" | \
    grep node.name | \
    head -n 1 | \
    awk '{gsub(/"/, ""); print $3}'
}

function getPWIDFromName() {
  local nodeName="$1"
  pw-cli info "${nodeName}" | \
    head -n 1 | \
    awk '{print $2}'
}

function getDefaultSinkName() {
  wpctl status -n | \
    tail -n 2 | \
    grep "Audio/Sink" | \
    awk '{print $3}'
}

function getDefaultSourceName() {
  wpctl status -n | \
    tail -n 2 | \
    grep "Audio/Source" | \
    awk '{print $3}'
}

echo "Getting pipewire IDs for headphones"
headset_id="$(getPWIDFromName "${HEADPHONES_NAME}")"
headset_mic_id="$(getPWIDFromName "${HEADPHONES_MIC_NAME}")"
echo "Getting pipewire IDs for HMD"
hmd_id="$(getPWIDFromName "${HMD_NAME}")"
hmd_mic_id="$(getPWIDFromName "${HMD_MIC_NAME}")"
echo "Getting pipewire IDs for defaults"
default_id="$(getPWIDFromName "$(getDefaultSinkName)")"
# Unused, but keep for later
#default_mic_id="$(getPWIDFromName "$(getDefaultSourceName)")"

# Check if we are set to the HMD's output
if [[ "${default_id}" -eq "${hmd_id}" ]]; then
  # Set the output to headphones
  wpctl set-default "$headset_id"
  wpctl set-default "$headset_mic_id"
else
  # Set the output to hmd
  wpctl set-default "$hmd_id"
  wpctl set-default "$hmd_mic_id"
fi
