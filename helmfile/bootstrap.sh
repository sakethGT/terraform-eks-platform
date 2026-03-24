#!/usr/bin/env bash
set -e

#===============================================================================
# Defaults that can be overridden as required

# Turn on/off debug logging
log_debug=${SDP_HELM_BSTRAP_LOG_DEBUG:-true} 

# Deploy support tooling in addition to core cluster components
# Curretly the support tooling list consists of: weave-scope
deploy_sdp_support_tooling=${SDP_SUPPORT_TOOLS:-false}

#===============================================================================
# Misc helpers - no need to edit
source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do
  dir="$( cd -P "$( dirname "$source" )" && pwd )"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$dir/$source"
done
work_dir="$( cd -P "$( dirname "$source" )" && pwd )"


#===============================================================================

# 
# custom exit
# 
function error_exit(){
    printf "%s ERROR %s \n"  $(date "+%y/%m/%d-%H:%M:%S-%Z") " $1" 
    exit 1
}


# 
# console log
# 
function log_msg_debug(){
    printf "%s DEBUG %s \n"  $(date "+%y/%m/%d-%H:%M:%S-%Z") " $1" 
}


# 
# tool check
# 
function tool_available() {
    if hash $1 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# 
# usage
# 
function print_usage()
{
  printf "%s %s\n" "Usage:" "bootstrap.sh <</path/to/helmfile>>"
  exit 1
}

# 
# main
# 
function main() {
    if $log_debug; then
      log_msg_debug "Starting bootstrap"
    fi

    setup_core_components $1
}

# 
# helmfile
# 
function setup_core_components() {
  if $log_debug; then
      log_msg_debug "Deploying core components using helmfile $1"
  fi
  
  setup_helmfile_helpers

  # actually deploy via helmfile
  if $deploy_sdp_support_tooling; then
    if $log_debug; then
      log_msg_debug "Deploying SDP support tools in addition to core components"
    fi

    helmfile -f ${work_dir}/helmfile.yaml apply
    if [ $? -ne 0 ]; then
      error_exit " error applying helmfile"
    fi

  else
    if $log_debug; then
      log_msg_debug "Deploying core components only"
    fi

    helmfile -l component!=sdp_support_tooling -f ${work_dir}/helmfile.yaml apply
    if [ $? -ne 0 ]; then
      error_exit " error applying helmfile"
    fi
  fi

}

# 
# helmfile - helpers
# 
function setup_helmfile_helpers() {

  # prep plugin - todo, fold this into the tooling container once workflow has been validated
  if !  helm plugin list | grep 'diff' &> /dev/null; then
    helm plugin install https://github.com/databus23/helm-diff
    if [ $? -ne 0 ]; then
      error_exit " error installing helm diff plugin"
    fi
  fi

  # sync repos ; don't suppres output so we have available for inspection post run
  helmfile  repos
  if [ $? -ne 0 ]; then
    error_exit " error syncing repos"
  fi

}

#=================================================================================
# 
# Entry: check args incl file existence and the presence of the core tools we need.

if [ "$#" -ne 1 ]; then
    print_usage
fi

if ! tool_available "kubectl"; then
  error_exit "kubectl is required however I wasn't able to find it on the available script path. PATH was: $PATH"
elif ! tool_available "helm"; then
  error_exit "helm is required however I wasn't able to find it on the available script path. PATH was: $PATH"
elif ! tool_available "helmfile"; then
  error_exit "helmfile is required however I wasn't able to find it on the available script path. PATH was: $PATH"
else
  if [ -e $1 ]; then
      main $1
  else
      error_exit "$1 wasn't found, please check. Script ran from $work_dir"
  fi
fi