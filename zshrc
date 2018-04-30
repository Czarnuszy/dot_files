# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/gedaj/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="risto"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

plugins=(fzf-git)
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



export EDITOR='vim'
export VISUAL='vim'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LTE_AGINOODLE_BACKUP_LOCATION="durszlak:/home/lte/aginoodle/backups/global_backup/aginoodle.tar.gz"
export LTE_AGINOODLE_GZIPED_BACKUP_FILE="aginoodle.tar.gz"
export LTE_AGINOODLE_UNPACKED_BACKUP_FILE="aginoodle.sql"

export K3_AGINOODLE_BACKUP_LOCATION="glonull:/cplane/www/aginoodle_sites/k3/backups/global_backup/aginoodle-k3.tar.gz"
export K3_AGINOODLE_GZIPED_BACKUP_FILE="aginoodle-k3.tar.gz"
export K3_AGINOODLE_UNPACKED_BACKUP_FILE="aginoodle-k3.sql"
export WORKSPACE="$HOME/aginoodle"


function getagibackup() {
	BACKUP_LOCATION=$1
	GZIPED_BACKUP_FILE=$2
	UNPACKED_BACKUP_FILE=$3
	DB_PASSWORD="haslo"

	echo "DROP DATABASE aginoodle" | \mysql -u root --password=$DB_PASSWORD
	echo "CREATE DATABASE IF NOT EXISTS aginoodle CHARACTER SET=utf8;" | \mysql -u root --password=$DB_PASSWORD
	cd $WORKSPACE/backups
	scp $BACKUP_LOCATION ./
	tar -xzf $GZIPED_BACKUP_FILE
	/usr/bin/mysql -u root --password=$DB_PASSWORD aginoodle < $UNPACKED_BACKUP_FILE
	backlog migrate
	echo "from django.contrib.auth.models import User; User.objects.create_superuser(username='jarzyna', password='admin', email='krzysztof.jarzyna@szczecin.pl', id=0xDEAD)" | backlog shell > /dev/null
	echo "from backlog.items.models import PBItem, Tag; PBItem.objects.get(item_id='992.3').tags = Tag.objects.all()" | backlog shell > /dev/null
	echo "from datetime import timedelta; from django.contrib.sessions.models import Session; from django.utils import timezone; Session.objects.create(session_key='0xdeadbeef', session_data='MmMxZjdkZDI3ZDBhYmRkN2E4YTI2ZmNhMDZiNTUyMzdkY2U3ZTVmMTp7Il9hdXRoX3VzZXJfaGFzaCI6IjNiMzg3ZDkzM2NmNmQ1MjJlYzllN2Y1ZTJmMzg3ZmQ0MGExOGZmODIiLCJfYXV0aF91c2VyX2lkIjoiNTcwMDUiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsImhhc19wZXJtX3RvX3NlZV90ZWFtX2NhcGFjaXR5IjpbIkZUSzEiLCJGVEsxMCIsIkZUSzExIiwiRlRLMTIiLCJGVEsxMyIsIkZUSzE0IiwiRlRLMTUiLCJGVEsxNiIsIkZUSzIiLCJGVEszIiwiRlRLNCIsIkZUSzUiLCJGVEs2IiwiRlRLNyIsIkZUSzgiLCJGVEs5IiwiRlRXMSIsIkZUVzEwIiwiRlRXMTEiLCJGVFcxMiIsIkZUVzEzIiwiRlRXMTQiLCJGVFcxNSIsIkZUVzE2IiwiRlRXMTciLCJGVFcxOCIsIkZUVzE5IiwiRlRXMiIsIkZUVzIwIiwiRlRXMjEiLCJGVFcyMiIsIkZUVzI5IiwiRlRXMyIsIkZUVzMwIiwiRlRXMzEiLCJGVFczMiIsIkZUVzQiLCJGVFc1IiwiRlRXNiIsIkZUVzciLCJGVFc4IiwiRlRXOSJdfQ==', expire_date=timezone.now() + timedelta(days=30))" | backlog shell > /dev/null
	echo "from backlog.aginoodle_shared.models import Attachment; Attachment.objects.all()" | backlog shell
	BACKUP_TIME=$(stat -c %y $UNPACKED_BACKUP_FILE)
	echo "Got backup from: $BACKUP_TIME"
	rm $UNPACKED_BACKUP_FILE
	cd - > /dev/null
}

function getltebackup() {
	getagibackup $LTE_AGINOODLE_BACKUP_LOCATION $LTE_AGINOODLE_GZIPED_BACKUP_FILE $LTE_AGINOODLE_UNPACKED_BACKUP_FILE
}

function getk3backup() {
	getagibackup $K3_AGINOODLE_BACKUP_LOCATION $K3_AGINOODLE_GZIPED_BACKUP_FILE $K3_AGINOODLE_UNPACKED_BACKUP_FILE
}

function getteamcalbackup() {
	DB_NAME=$1
	DB_USER=$2
	DB_PASS=$3
	DB_PASSWORD=""

	cd $WORKSPACE/backups
	ssh glonull "mysqldump -u $DB_USER --password=$DB_PASS $DB_NAME > /tmp/teamcal_backup.sql"
	scp glonull:/tmp/teamcal_backup.sql ./
	/usr/bin/mysql -u root $DB_NAME --password=$DB_PASSWORD < teamcal_backup.sql
	BACKUP_TIME=$(stat -c %y teamcal_backup.sql)
	echo "Got backup from: $BACKUP_TIME"
	ssh glonull "rm /tmp/teamcal_backup.sql"
	cd - > /dev/null
}

function getwrocteamcalbackup() {
	getteamcalbackup $WROC_TEAMCAL_DB_NAME $WROC_TEAMCAL_USER $WROC_TEAMCAL_PASSWORD
}

function getkrkteamcalbackup() {
	getteamcalbackup $KRK_TEAMCAL_DB_NAME $KRK_TEAMCAL_USER $KRK_TEAMCAL_PASSWORD
}

alias python="python3"
alias clr="clear"
alias gs="git status"
alias gpr="git pull --rebase"
alias gps="git push"
alias dup="docker-compose up"

alias glut='cd ~/gluten'
alias one='cd ~/one-lte-backlog'
alias marta='cd ~/marta-3'
alias nudle='cd ~/aginoodle'
alias jasmine='(cd $WORKSPACE/src/backlog/; ../../bin/jasmine; cd -)'
alias agijt='(cd $WORKSPACE/src/backlog/; PATH=$HOME/firefox:$PATH http_proxy= https_proxy= ../../bin/jasmine-ci; cd -)'
