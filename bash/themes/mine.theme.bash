#!/bin/bash

SCM_THEME_PROMPT_DIRTY=" ${bold_red}✘"
SCM_THEME_PROMPT_CLEAN=" ${bold_green}✔"
SCM_THEME_PROMPT_PREFIX=" "
SCM_THEME_PROMPT_SUFFIX=" "
SCM_NONE_CHAR=""
RVM_THEME_PROMPT_PREFIX="${red}⟐ "
RVM_THEME_PROMPT_SUFFIX=" ${reset_color}"
ERROR="${bold_red}❌  Error \n${normal}"
EXIT_STATUS="if [ \$? = 0 ]; then echo \"\"; else echo \"${ERROR}\"; fi"

rvmrc_version_prompt () {
  if [ -f .rvmrc ] || [ -f .ruby\-version ] || [ -f Gemfile ]; then
    if which rvm &> /dev/null; then
      rvm=$(rvm tools identifier) || return
      clean=${rvm//ruby-/}
      echo -e "$RVM_THEME_PROMPT_PREFIX$clean$RVM_THEME_PROMPT_SUFFIX"
    fi
  fi
}

aws_saml_prompt () {
  local now=$( date -u +%s )
  local remain=$(( EXPIRE - now ))
  if [ -n "$AWS_ROLE" ] && [ -n "$EXPIRETIME" ] && [ $remain -gt 0 ]; then
    echo -e "${cyan}[${AWS_ROLE} $(($remain/60))m]${reset_color} "
  fi
}

prompt_left () {
  LEFT_PROMPT="\[\033[G\]\`${EXIT_STATUS}\`\[${yellow}\]\w \[\$(aws_saml_prompt)\]\[\$(rvmrc_version_prompt)\]\[${blue}\]\[\$(scm_char)\]\[\$(scm_prompt_info)\]\[${normal}\]\[${reset_color}\]\[$(date "+%_I:%M:%S %P")\]"
  echo -e "${LEFT_PROMPT}"
}

prompt () {
  [ -n "$TERM_PROGRAM" ] && __iterm_tab_title
  PS2="\[${yellow}\]‣\[${normal}\]\[${reset_color}\] "
  PS1="$(prompt_left)\n${PS2}"
}

PROMPT_COMMAND=prompt


