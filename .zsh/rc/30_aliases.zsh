#unalias ctags
#unalias cp
#unalias find

alias ctags='/usr/local/Cellar/ctags/5.8_1/bin/ctags'
alias ll='ls -l'
alias tailf='tail -f'
alias mkdir='mkdir -p'
alias pp='popd'
alias be="bundle exec"
alias docc="docker-compose"
alias killspring="ps aux | grep spring | grep -v grep | awk '{print $2}' | xargs kill -9"

alias cc-barsion-start="aws ec2 start-instances --instance-ids i-0dc5a45427ad755ec && aws ec2 wait instance-running --instance-ids i-0dc5a45427ad755ec; aws ec2 describe-instances --instance-ids i-0dc5a45427ad755ec | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name, PublicDnsName, PublicIpAddress}'"
alias cc-barsion-stop="aws ec2 stop-instances --instance-ids i-0dc5a45427ad755ec && aws ec2 wait instance-stopped --instance-ids i-0dc5a45427ad755ec; aws ec2 describe-instances --instance-ids i-0dc5a45427ad755ec | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name}'"
alias cc-barsion="aws ec2 describe-instances --instance-ids i-0dc5a45427ad755ec | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name, PublicDnsName, PublicIpAddress}'"

alias project-barsion-start="aws ec2 start-instances --profile project --instance-ids i-03b9450a262b4c72f && aws ec2 wait instance-running --profile project --instance-ids i-03b9450a262b4c72f; aws ec2 describe-instances --profile project --instance-ids i-03b9450a262b4c72f | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name, PublicDnsName, PublicIpAddress}'"
alias project-barsion-stop="aws ec2 stop-instances --profile project --instance-ids i-03b9450a262b4c72f && aws ec2 wait instance-stopped --profile project --instance-ids i-03b9450a262b4c72f; aws ec2 describe-instances --profile project --instance-ids i-03b9450a262b4c72f | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name}'"
alias project-barsion="aws ec2 describe-instances --profile project --instance-ids i-03b9450a262b4c72f | jq '.Reservations[].Instances[] | {InstanceId, InstanceState: .State.Name, PublicDnsName, PublicIpAddress}'"

#anyframe alias
alias hcp=anyframe-widget-put-history
alias hrun=anyframe-widget-execute-history
alias hpath=anyframe-widget-cdr
alias gitbrcd=anyframe-widget-checkout-git-branch
alias gitbrselect=anyframe-widget-insert-git-branch
alias gitrepo=anyframe-widget-cd-ghq-repository
alias killselect=anyframe-widget-kill

