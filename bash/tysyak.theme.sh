SCM_THEME_PROMPT_PREFIX=""
SCM_THEME_PROMPT_SUFFIX=""

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✗${normal}"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✓${normal}"
SCM_GIT_CHAR="${bold_cyan}±${normal}"
SCM_SVN_CHAR="${bold_green}⑆${normal}"
SCM_HG_CHAR="${bold_red}☿${normal}"

#Mysql Prompt
export MYSQL_PS1="(\u@\h) [\d]> "

case $TERM in
        xterm*)
        TITLEBAR="\[\033]0;\w\007\]"
        ;;
        *)
        TITLEBAR=""
        ;;
esac

PS3=">> "

__my_rvm_ruby_version() {
    local gemset=$(echo $GEM_HOME | awk -F'@' '{print $2}')
  [ "$gemset" != "" ] && gemset="@$gemset"
    local version=$(echo $MY_RUBY_HOME | awk -F'-' '{print $2}')
    local full="$version$gemset"
  [ "$full" != "" ] && echo "[$full]"
}

__my_venv_prompt() {
  if [ ! -z "$VIRTUAL_ENV" ]
  then
    echo "[${blue}@${normal}${VIRTUAL_ENV##*/}]"
  fi
}

is_vim_shell() {
        if [ ! -z "$VIMRUNTIME" ]
        then
                echo "[${cyan}vim shell${normal}]"
        fi
}

modern_scm_prompt() {
        CHAR=$(scm_char)
        if [ $CHAR = $SCM_NONE_CHAR ]
        then
                return
        else
                echo "($(scm_char) $(scm_prompt_info))"
        fi
}

prompt() {

   case $HOSTNAME in
    "clappy"* ) my_ps_host="${green}\h${normal}";
            ;;
    "icekernel") my_ps_host="${red}\h${normal}";
            ;;
    * ) my_ps_host="\[\033[38;5;69m\]\h${normal}";
            ;;
    esac

    my_ps_user="\[\033[38;5;63m\]\u\[\033[00m\]";
    my_ps_root="\[\033[01;31m\]\u\[\033[00m\]";
    my_ps_path="\[\033[01;36m\]\w\[\033[00m\]";
    num_terminal="\[\033[01;36m\]pt/\l->\[\033[00m\]"

    # nice prompt
    case "`id -u`" in
        0) PS1="${TITLEBAR}[$my_ps_root][$my_ps_host]$(modern_scm_prompt)$(__my_rvm_ruby_version) [${cyan}$my_ps_path${normal}]/(\[\033[0;31m\]\$?\[\[\033[00m\]\])$(is_vim_shell)
$ "
        ;;
      *) PS1="${TITLEBAR}$my_ps_user@$my_ps_host $num_terminal$(modern_scm_prompt)$(__my_rvm_ruby_version)$(__my_venv_prompt) [${cyan}$my_ps_path${normal}]-(\[\033[0;31m\]\$?\[\[\033[00m\]\])$(is_vim_shell)
$ "
        ;;
    esac
}

PS2="> "
safe_append_prompt_command prompt
