#!/usr/bin/env bash


. .env


function usage(){
cat <<-EOF
repo-controller [options]

    -h| --help           this is some help text.
    -1|--first-option    this is my first option
    -2|--second-option   this is my second option
EOF
}


function exec_dir(){
	
	find /home/bane/work/git/src -maxdepth 1 -name "Sts.*" -type d -exec /bin/bash -c \
	"pushd {} >/dev/null 2>&1 && echo -e \"[{} :]\n\" &&  $@ 2>&1 ; popd > /dev/null 2>&1 ; echo -e '\n';" \; &
	wait

}


function main(){

	# [[  -z "$@" ]] || usage; return 1 
	exec_dir "$@"

}

main "$@"



