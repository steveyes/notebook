# awk

[toc]



## formatted printing

```
awk 'BEGIN{
	x = 97
	printf "Prints numeric output as a string: %c\n", x
 	x = 100
 	printf "Prints an integer value: %d\n", x
	x = 100 * 100
 	printf "Prints scientific number: %e\n", x
 	x = 97 / 100
 	printf "Prints float values: %f\n", x
 	x = 97
 	printf "Prints an octal value: %o\n", x
 	x = "hello world"
 	printf "Prints a text string: %s\n", x 
}'
```



## the while loop

```
cat > data.csv << EOH
124,127,130
112,142,135
175,158,245
118,231,147
EOH

awk '{
    total = 0
    i = 1
    while ( i < 4 ){
    	total += $i
    	i++
    }
 	avg = total / 3
	print "Average:",avg 
}' data.csv
```



## the for loop

```
cat > data.csv << EOH
124,127,130
112,142,135
175,158,245
118,231,147
EOH

awk '{
    total = 0
    for (i = 1; i < 4; i++){
    	total += $i
    }
 	avg = total / 3
	print "Average:",avg 
}' data.csv
```



## scope

```
# 打印1至10行
awk 'NR==1,NR==10' $file

# 打印包含hello的行直到包含world的行之间的所有行
awk '/hello/,/world/' $file
```



## awk实现head

```
cat $file | head -10
awk 'NR <= 10' $file
```



## awk实现tail

```
cat $file | tail -10
awk '{buffer[NR%10]=$0;} END {for(i=0;i<10;i++) {print buffer[i]}}' $file
```



## awk实现tac

```
tac $file
awk '{buffer[NR]=$0} END {for(i=NR;i>0;i--){print buffer[i]}}' $file
```



## 与&或&非

```
# 与
ip -4 a s | awk '/inet/&&/ens/'

# 或
ip -4 a s | awk '/inet/||/ens/'
```



## 匹配

```
# 末列匹配 nologin
awk '$NF~/nologin/ {print}' /etc/passwd

# 末列不匹配 nologin
awk '{if($NF!~/nologin/) print}' /etc/passwd
```



## built-in variables

```
cat > data.csv << EOH
124,127,130
112,142,135
175,158,245
118,231,147
EOH

awk 'BEGIN{print ARGC,ARGV[0],ARGV[1]}' data.csv data.csv 
awk 'BEGIN{print ENVIRON["PATH"]}'
awk 'BEGIN{FS=","; OFS=":"} {print $1,$NF,"FNR="FNR}' data.csv

# The FNR variable becomes 1 when comes to the second file, but the NR variable keeps its value.
awk 'BEGIN {FS="," 
    }{ 
        print $1,
        "FNR(Number of Row which is being processed)="FNR,
        "NR(Number of Row which has been processed)="NR 
    } END { 
        "Total Number of Row",NR,"processed lines" 
}' data.csv data.csv 


# You need to set the FS to the newline (\n) and the RS to a blank text, so empty lines will be considered separators.
cat > person << EOF
Person Name
123 High Street
(222) 466-1234

Another person
487 High Street
(523) 643-8754
EOF

awk 'BEGIN{OFS=":"; FS="\n"; RS=""} {print $1,$2,$3}' person
```



## user defined strings

```
# variant1
awk 'BEGIN {
	x = "ebay";
	print toupper(x)
}'

# variant2
echo | awk -v home=$HOME '{print "My home is " home}'
```



## user defined functions

```
awk '
function myfunc() {
	printf "The user %s has home path at %s\n", $1, $6
}
BEGIN{FS=":"}
{
	myfunc()
}' /etc/passwd
```



## mathematical functions

```
awk 'BEGIN {
	x = exp(5);
	printf "%d\n", x;
	x = sin(1/2);
	printf "%f\n", x;
	x = cos(1/2);
	printf "%f\n", x;
	x = sqrt(9);
	printf "%f\n", x;
	x = rand();
	printf "%f\n", x;
}'
```



## make the record seperator in AWK not apply after the last record

```
# seq 5 | awk -v ORS=",\n" '{print $0}' # wrong, affected the last record
seq 5 | awk '{printf "%s%s",sep,$0; sep=",\n"} END{print ""}' # right
seq 5 | head -c -1 | awk -v ORS=",\n" '{printf "%s%s",$0,RT?ORS:""}' # right
```



## treat multiple delimiters as one excluding arbitrary number of space

```
awk -F'[:,]' '{print $2}'
```



## treat multiple delimiters as one including arbitrary number of space

```
awk -F'[:]| +' '{print $2}'
```



## print whole paragraphs of a text containing a specific keyword

```
awk '/keyword/' RS="\n\n" ORS="\n\n" input.txt
```



## grep whole paragraphs of a text containing a specific pattern instead of by line

```
dmidecode -t memory | awk 'BEGIN{RS=ORS="\n\n";FS=OFS="\n"}/32 GB/'
dmidecode -t memory | awk '/32 GB/' RS='\n\n' ORS='\n\n'
dmidecode -t memory | perl -00 -ne 'print if /32 GB/'
```

