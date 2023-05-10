# Zombies

- Find zombie processes: `ps afuwwx | less +u -p'^(\S+\s+){7}Z.*'`