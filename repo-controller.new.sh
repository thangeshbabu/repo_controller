#!/usr/bin/env bash



_INTERACTIVE_MODE=0
_PATH='/home/bane/work/git/src/'
_PATTERN='Sts.*'
_MAX_DEPTH=1


function usage(){
cat <<-EOF

Bulk execute commands in all the folders that matches the pattern !

repo-controller [options]

    -i| --interative     Interactively select the folder  
    -p|--path 		 Change the path  
    -P|--pattern 	 Change the existing Pattern
    -d|--depth 	         Change the Depth of find

EOF
}


function exec_dir(){

	_ARRAYofFOLDERS=` find "${_PATH}" -maxdepth $_MAX_DEPTH -name "${_PATTERN}" -type d  | fzf --multi `
	
	[[ _INTERACTIVE_MODE == 1 ]]  && _ARRAYofFOLDERS=` print "$s\n" "${_ARRAYofFOLDERS[@]}" | fzf `

	for folder in ${_ARRAYofFOLDERS[@]}; do 
		 { pushd "${folder}" >/dev/null 2>&1 && echo -e "[${folder} :]\n" && bash -c "${_COMMANDS}" 2>&1 ; popd > /dev/null 2>&1 ; echo -e '\n'; } 
		
	done 
	wait

}

function ARG_PARSE(){

	while [[ $# -gt 0 ]];
	do
		case $1 in 
			-i|--interactive) 
				_INTERACTIVE_MODE=1 ;;
			-p|--path)  
				shift; 
				_PATH="$1" ;;
			-P|--pattern)  
				shift;
				_PATTERN="$1" ;;
			-d|--depth)  
				shift;
				_MAX_DEPTH="$1" ;;
			-c|--commands)  
				shift;
				_COMMANDS="$1" ;;
			    -*|--*)
			      	echo "Unknown option $1"
			      	exit 1
			      	;;
			    *)
				usage 
			      	exit 1
			      	# _POSITIONAL_ARGS+=("$1") # save positional arg
			      	;;
			  esac
	  shift 
			
	done



}


function main(){

	[[ $# == 0 ]] && usage && return 1

	echo "$@"

	ARG_PARSE "$@"



	exec_dir 

}

main "$@"



# comment 

	# -exec /bin/bash -c \
	# "pushd {} >/dev/null 2>&1 && echo -e \"[{} :]\n\" &&  $@ 2>&1 ; popd > /dev/null 2>&1 ; echo -e '\n';" \; &
