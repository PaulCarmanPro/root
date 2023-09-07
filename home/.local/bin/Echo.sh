#!/bin/bash

####################################
# root/Echo.sh
# This file is meant to be included by other bash sources

#################################### README
# NAMING CONVENTIONS:
#
#   VARIABLES are meant to be exported.
#     VARIABLES are not meant for internal initialization.
#     VARIABLES may be set externally.
#     Otherwise, VARIABLES are handled like dGlobals.
#   dGlobals are global variables.
#     dGlobals represent dFlags, dOptions, dModes etc.
#     dGlobals are specific purpose variables.
#     dGlobals are set in one area and may have a setter.
#     dGlobals are meant to be read by every routine in the program.
#     dGlobals should not be casually modified.
#     dGlobals are declared when sourcing information from VARIABLES.
#     dGlobals are declared for hard coded determination.
#   aArguments are argument (parameter) variables.
#     aArguments are not to be read by subroutines.
#     aArguments are local if inside a function.
#     aArguments are not general purpose variables.
#     aArguments are, once defined, are constant.
#   zWorkers are working, local, temporary variables.
#     zWorkers are not to be read by subroutines.
#     zWorkers are local if inside a function.
#     zWorkers are loop variables (often just z).
#     zWorkers are calculation and accumulation variables.
#   eEnumerations are constant integer values for linear array access.
#   kKeys are constant string values for associative array access.
#
#   FunctionNames are camel case.
#   __FunctionNames are internal use.
#   executablefiles are meant for user use.
#   ExecutableFiles are not meant for user use.
#
#   Do NOT create names that differ only in prefix or case.
#     It is easy to error between variables dThis, aThis, and zThis.
#     It is also easy to error between functions/executables this and This.
#     The purpose of a prefix is mental organization and understanding.
#     A prefix should NOT unique a variable.
#     USE UNIQUE NAMES.
####################################

# Echo message as an error
####################################
declare -i dError # error count accumulator
declare -i dEchoErr_color=9 # bright red
EchoErr() { # ERROR...
   dError+=1
   __Echo "${FUNCNAME[2]}" "$dEchoErr_color" '!!!' "$@" >&2
}

# Echo message as a note
####################################
declare -i dEchoHeader_color=229 # bright yellow
EchoHeader() { # HEADER...
   __Echo '' "$dEchoHeader_color" '' "$@"
}

# Echo message as a note
####################################
declare -i dEchoNote_color=13 # bright purple
EchoNote() { # NOTE...
   __Echo '' "$dEchoNote_color" '###' "$@"
}

# Affect used colors
####################################
declare dEchoUseColor
EchoUseColor() { # [always|auto|never]
   case "${dEchoUseColor:-auto}" in
      always|auto|never) dEchoUseColor="$1" ;;
      *) EchoErr "Illegal usecolor specification ${1@Q}."
   esac
}

# Internal use Echo Routines
####################################
declare dEchoMsg_Past
declare dEchoMsg_Present
__Echo() { # FROM COLOR PREFIX MESSAGE...
   # will not echo multiple identical messages in a row
   dEchoMsg_Past="$dEchoMsg_Present"
   local zColor
   local zFrom="$1"
   case "${dEchoUseColor:-auto}" in
      always) zColor="$2" ;;
      auto) [[ "$TERM" = *color ]] && zColor="$2" ;;
      never) ;;
      *) echo "!!! __Echo illegal EchoUseColors ${dEchoUseColor@Q} !!!" >&2
   esac
   local zPrefix="$3"
   local zMessage="$4"
   local -i zRest=5
   dEchoMsg_Present="$zFrom $*"
   [[ "$dEchoMsg_Present" = "$dEchoMsg_Past" ]] && return
   if [[ "$zPrefix" ]]; then
      [[ "$zColor" ]] && tput setaf "$zColor"
      printf '%s' "$zPrefix"
      [[ "$zColor" ]] && tput sgr0
      printf ' '
   fi
   [[ "$zFrom" ]] \
      && printf "%s.%s: " \
                 "$(basename -- "${BASH_SOURCE[0]}")" \
                 "$zFrom"
   [[ "$zColor" ]] && tput setaf "$zColor"
   printf '%s\n' "${zMessage:-Empty/Unspecified}"
   [[ $zRest -le "$#" ]] \
      && printf '%s\n' "${@:$zRest}"
   [[ "$zColor" ]] && tput sgr0
}
