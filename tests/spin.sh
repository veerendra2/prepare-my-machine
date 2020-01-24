spinner() {
    spin="\\|/-"
    i=0
    tput civis
    while sudo kill -0 $1 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\b${spin:$i:1}"
        sleep 0.07
    done
    tput cnorm
}
# TODO https://stackoverflow.com/questions/9261397/how-can-i-get-both-the-process-id-and-the-exit-code-from-a-bash-script

install(){
    { sh -c "$1 > logs 2>&1 &"'
    echo $! > pidfile
    wait $!
    echo $? > exitcode
    ' & }
    printf $2
    spinner "$(cat pidfile)"
    if [ "$(cat exitcode)" != "0" ]; then
      printf "\b[FAILED]"
    else
      printf "\b[DONE]"
    fi
}

install "sudo apt-get updae" "Updating... "
