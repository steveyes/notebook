# golang notebook



## help

### as a web page

```bash
godoc -http=localhost:8000
godoc -http :8000
```

> runs as a web server and presents the documentation as a web page

## operators

| +    | addition       |
| ---- | -------------- |
| -    | subtraction    |
| *    | multiplication |
| /    | division       |
| %    | remainder      |
| &&   | and            |
| \|\| | or             |
| !    | not            |

## types



## Tips & Tricks

### +=

```go
x := "first "
x += "second"
```

When we see `x = x + "second"`we should read it as “assign the concatenation of the value of the variable x and the string literal second to the variable x.” The right side of the `=` is done first and the result is then assigned to the left side of the `=`.

The `x = x + y` form is so common in programming that Go has a special assignment statement: `+=`. We could have written `x = x + "second"` as `x += "second"` and it would have done the same thing. (Other operators can be used the same way)

Another difference between Go and algebra is that we use a different symbol for equality: `==`. (Two equal signs next to each other) `==` is an operator like `+` and it returns a boolean. For example:





# Control Structures

### For

```go
package main

import "fmt"

func for01() {
    i := 1
    for i <= 10 {
        fmt.Println(i)
        i = i + 1
    }
}

func for02() {
    for i:=1; i<=10; i++ {
        fmt.Println(i)
    }
}


```

> the `for statement` in func for01  is similar with `while statement` which is in other general program language



## install go on ubuntu18

 https://www.codeooze.com/ubuntu/ubuntu-18-golang-snap/ 