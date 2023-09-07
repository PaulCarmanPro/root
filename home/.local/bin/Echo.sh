#!/bin/bash root/Echo.sh

# This file is meant to be included by other bash sources

# Echo a message as an error
####################################
define -i dError # error count accumulator
define -i dEchoErr_Color=9
EchoErr() { # ERROR...
   dError+=1
   __EchoMsg "$dEchoErr_Color" '!!!' "$@" >&2
}

# Echo a message as a note
####################################
define -i dEchoNote_Color=13
EchoNote() { # NOTE...
   __EchoMsg "$dEchoNote_Color" '###' "$@"
}

# Internal use Echo Routines
####################################
define -a dEchoMsg_Past
define -a dEchoMsg_Present
__EchoMsg() { # COLOR PREFIX MESSAGE...
   # will not echo multiple identical messages in a row
   dEchoMsg_Past="$dEchoMsg_Present"
   local zColor="$1"
   local zPrefix="$2"
   local zMessage="$3"
   local -i zRest=4
   local zFunction="${FUNCNAME[2]}"
   dEchoMsg_Present="$zFunction $*"
   [[ "$dEchoMsg_Preset" = "$dEchoMsg_Past" ]] && return
   [[ "$zColor" ]] && tput setaf "$zColor"
   printf '%s' "$zPrefix"
   [[ "$zColor" ]] && tput sgr0
   printf '%s.%s: ' \
          "$(basename -- "${BASH_SOURCE[0]}")" \
          "$zFunction"
   [[ "$zColor" ]] && tput setaf "$zColor"
   printf '%s\n' "$zMessage"
   [[ $zRest -le "$#" ]] \
      && printf '%s\n' "${@:$zRest}"
   [[ "$zColor" ]] && tput sgr0
}
