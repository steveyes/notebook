

# python3 



## sys.path



### incode

add temporary 

```
import sys
pythonpath='/path/to/project'
sys.path.append(pythonpath)
```



### copy to dir ...

copy project to the path which is in the $PYTHONPATH



### set PYTHONPATH

set PYTHONPATH, not recommended in multiple version



#### set `PYTHONPATH` in linux per process

```
pythonpath=/path/to/project1:/path/to/project2

# check sys.path
PYTHONPATH=$pythonpath python -c 'import sys; [print(repr(p)) for p in sys.path]'

# run apps
main_module=run.py
PYTHONPATH=$pythonpath python $main_module
```



#### set `PYTHONPATH` in linux per session

```
pythonpath=/path/to/project1:/path/to/project2

# export 
export PYTHONPATH=$pythonpath

# check sys.path
python -c 'import sys; [print(repr(p)) for p in sys.path]'

# run apps
main_module=run.py
main_module=run2.py
python $main_module
python $main_module2
```



#### set `PYTHONPATH` in linux per session from dump file (recommended)

```
pythonpath=/home/runzhao/lib:/home/runzhao/bin

# dump PYTHONPATH
nlines=$(grep "$pythonpath" ~/.pythonrc | wc -l)
if [[ 0 -eq $nlines ]]; then
cat > ~/.pythonrc << EOF
export PYTHONPATH=$pythonpath
EOF
elif [[ 1 -eq $lines ]]; then
    echo "PYTHONPATH has been configured"
    # return 0
else
    echo "error in ~/.pythonrc"
    # return -1
fi

# soruce PYTHONPATH
source ~/.pythonrc 

# check sys.path
python -c 'import sys; [print(repr(p)) for p in sys.path]'

# run app
main_module=run.py
python $main_module
```



#### set `PYTHONPATH` in linux permanently

```
### >>> run this snippets once >>>
pythonpath=/path/to/project1:/path/to/project2

# dump PYTHONPATH
nlines=$(grep "$pythonpath" ~/.pythonrc | wc -l)
if [[ 0 -eq $nlines ]]; then
cat > ~/.pythonrc << EOF
export PYTHONPATH=$pythonpath
EOF
elif [[ 1 -eq $lines ]]; then
    echo "PYTHONPATH has been configured"
    # return 0
else
    echo "error in ~/.pythonrc"
    # return -1
fi

# source from ~/.bashrc
nlines=$(grep "pythonrc initialize" ~/.bashrc | wc -l)
if [[ 0 -eq $nlines ]]; then
cat >> ~/.bashrc << EOF

# >>> pythonrc initialize >>>
source ~/.pythonrc
# <<< pythonrc initialize <<<
EOF
elif [[ 1 -eq $nlines ]]; then
    echo "format error"
    # return -1
elif [[ 2 -eq $nlines ]]; then
    echo "pythonrc has already been configured"
    # return 0
else
    echo "error in ~/.bashrc"
fi

# source PYTHONPATH
source ~/.bashrc 

### <<< run this snippets once <<<

# check sys.path
python -c 'import sys; [print(repr(p)) for p in sys.path]'

# run apps
main_module=run.py
python $main_module

```



#### set PYTHONPATH in pycharm 

File --> Settings... --> Project: <Your Project Name> --> Project Structure 

> select <root path of your project>  and Mark as: `Source`
>



#### set `PYTHONPATH` in windows

My Computer --> Properties --> Advanced System Settings --> Environment Variables --> New...

> Variable name: `PYTHONPATH`
> Variable name: <root path of your project1>;<root path of your project2>;

get the <current PYTHONPATH> 

```
python -c 'import sys; [print(repr(p)) for p in sys.path]
```





## debug 

### 1 install

```
# Fedora
sudo yum install gdb python-debuginfo

# ubuntu
sudo apt-get install gdb python3.8-dbg python3.8-dev
```



### 2.1 run gdb interactively

```
sudo gdb $(which python) 
(gdb) run <module>.py <arguments>
```



### run gdb automatically

```
gdb -ex r --args $(which python) <module>.py <arguments>
```



### attach to a running pid

```
sudo gdb $(which python) -p <pid>
```



### py-bt

```
source_file=$(dpkg -L python3.8-dbg | egrep 'python3.8-gdb.py')

sudo gdb $(which python) -p <pid>
(gdb) source $source_file
(gdb) py-bt
```



### 3.2 get the stack of a hunging thread

````
sudo gdb $(which python) -p <pid>
(gdb) info threads
(gdb) cont
(gdb) (press)<Ctrl> + C
(gdb) info threads
(gdb) py-list

````







## keyword

```
import keyword
keyword.kwlist
```



## docstring

```
def SumOf(ints):
    '''
    1. this function is to sum up all the numbers in ints
    2. parameters: (list)
    3. return: (int)
    '''
    s = 0
    for i in ints:
        s = s + i
    return s
```

```
SumOf?
```