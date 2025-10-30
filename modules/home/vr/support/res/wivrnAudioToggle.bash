#!/usr/bin/env bash


HEADPHONES_NICKNAME="USB Audio Device"
HEADPHONES_MIC_NICKNAME="${HEADPHONES_NICKNAME}"
HMD_NICKNAME="WiVRn"
HMD_MIC_NICKNAME="WiVRn(microphone"

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
    grep "alsa_output" | \
    awk '{print $3}'
}

function getDefaultSourceName() {
  wpctl status -n | \
    tail -n 2 | \
    grep "alsa_input" | \
    awk '{print $3}'
}

headset_id="$(getPWIDFromName "$(getPWNameFromNick "${HEADPHONES_NICKNAME}")")"
headset_mic_id="$(getPWIDFromName "$(getPWNameFromNick "${HEADPHONES_MIC_NICKNAME}")")"
hmd_id="$(getPWIDFromName "$(getPWNameFromNick "${HMD_NICKNAME}")")"
hmd_mic_id="$(getPWIDFromName "$(getPWNameFromNick "${HMD_MIC_NICKNAME}")")"
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
