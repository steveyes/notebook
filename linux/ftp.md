# ftp



## ftp自动传输脚本

```
#!/bin/bash
# Filename: auto_ftp_.sh

HOST="domain.com"
USER="foo"
PASSWORD="password"


ftp -i -n $HOST << EOF
user ${USER} ${PASSWORD}
binary
cd ...
put ...
quit
EOF
```

