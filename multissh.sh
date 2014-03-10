#!/usr/bin/expect
#usage - [script] hostFile userName Password commandFile
#---------CONFIG------------
set PASSWORD_PROMPT_PATTERN "*?assword"
set SHELL_PATTERN "-bash-4.1$ "


set timeout 2

set f1 [open [lindex $argv 3]]
set commands [split [read $f1] "\n"]
close $f1

set user [lindex $argv 1]
set password [lindex $argv 2]

set output [lindex $argv 4]

set fd [open $output "w"]
puts $fd "---Process started---\n"
close $fd

set fd [open $output "a"]

proc check_host {hostname} {
    global PASSWORD_PROMPT_PATTERN SHELL_PATTERN
    global user password fd commands
    spawn ssh $user@$hostname
    sleep 5

    expect {
        eof { puts "\nSSH failure for $hostname\n"; exit 1 }
        "*yes/no" { 
            send "yes\n";
            expect $PASSWORD_PROMPT_PATTERN { send "$password\n" }
        } 
    }

    expect $PASSWORD_PROMPT_PATTERN { send "$password\n" }

    expect {
        $PASSWORD_PROMPT_PATTERN { puts "\nIncorrect credentials.\n";exit 1}
        -re $SHELL_PATTERN
    }

    sleep 1


    foreach command $commands {
        send "$command\n"
        expect -re {.*} {}
        sleep 1
        expect "*\n"
        puts $fd "From $hostname:\n $expect_out(0,string)"
        expect -re {.*} {}
    }
 
    send "logout\r"
    expect eof
}


set fp [open [lindex $argv 0]]
while {[gets $fp line] != -1} {
    check_host $line
}
close $fp
close $fd