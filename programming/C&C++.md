# C/C++



## How to install gcc compiler 

for ubuntu

```
sudo apt update
sudo apt upgrade
sudo apt install build-essential
sudo apt install cmake
sudo apt install manpages-dev
which gcc && gcc --version
which g++ && g++ --version
which gdb && gdb --version
which make && make --version
which cmake && cmake --version

```



## compiler gcc for c

alternative 1

```
echo | gcc -v -x c -E -
```

- -v : verbose mode.  In the preprocessor’s case, print the final form of the include path, among other things. 
- -x c : Tells GCC that the input is to be treated as C source code. To find the G++ include path, substitute -x c++. You should be able to do the same for all the other languages supported by your GCC installation, assuming those languages support the concept of preprocessing. 
- -E Stop after preprocessing (it’s an empty source file, after all). 
- \- : The infile is from stdin which is from echo in this case.

alternative 2

```
gcc -v -x c++ -E /dev/null
```

- -v : verbose mode.  I
- -x c : Tells GCC that the input is to be treated as C++ source code. 
- -E Stop after preprocessing (it’s an empty source file, after all). 
- /dev/null : The infile is from /dev/null.



## compiler clang for c++

```
echo | clang -v -E -x c++ -
```





## source code of *The Linux Programming Interface*

https://man7.org/tlpi/code/online/all_files_by_chapter.html