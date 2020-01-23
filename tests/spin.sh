spinner() {
# Courtesy https://github.com/adtac/climate/blob/master/climate
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
sh -c "sudo apt-get update >> one_installer.log & echo $! > pidfile;wait $!; echo $? > exit-status 2>&1" > /dev/null 2>&1 &
printf "Installing.."
spinner $(cat pidfile)
cat exit-status
