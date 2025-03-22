if status is-interactive

    atuin init fish | source # this helps make atuin work

    # Commands to run in interactive sessions can go here
end

# creating a function for stargate and aws

function stargate
    set ssh_address "rdhakal@stargate.datasci.danforthcenter.org" # replace with your actual SSH address
    if set -q argv[1]
        mosh --ssh="ssh -L $argv[1]:localhost:$argv[1]" $ssh_address
    else
        mosh $ssh_address
    end
end

function ddpsc_aws
    set ssh_address "rdhakal@3.140.76.124" # replace with your actual SSH address
    if set -q argv[1]
        ssh -i ~/.ssh/rdhakal_soca_privatekey.pem -L 8080:localhost:8080 rdhakal@3.140.76.124
        #mosh --ssh="ssh -i ~/.ssh/rdhakal_soca_privatekey.pem -L $argv[1]:localhost:$argv[1]" $ssh_address
    else
        ssh -i ~/.ssh/rdhakal_soca_privatekey.pem rdhakal@3.140.76.124
        #mosh --ssh="ssh -i ~/.ssh/rdhakal_soca_privatekey.pem" $ssh_address
    end
end

# function to make the use of VPN easier
function uahvpn
    sudo openconnect --protocol=nc -C "DSID="$argv[1] psvpn.uah.edu
end

# gloabl varibles

set -gx EDITOR hx

set -gx CDPATH $CDPATH . ~ $HOME/work_in_progress

set -U fish_user_paths /home/rijan/executables $fish_user_paths
