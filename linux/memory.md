



## terms

**Page Table**

A page table is the data structure of a virtual memory system in an operating system to store the mapping between virtual addresses and physical addresses. This means that on a virtual memory system, the memory is accessed by first accessing a page table and then accessing the actual memory location implicitly.

**TLB**

A Translation Lookaside Buffer (TLB) is a buffer (or cache) in a CPU that contains parts of the page table. This is a fixed size buffer being used to do virtual address translation faster.

**hugetlb** 

This is an entry in the TLB that points to a HugePage (a large/big page larger than regular 4K and predefined in size). HugePages are implemented via hugetlb entries, i.e. we can say that a HugePage is handled by a "hugetlb page entry". The 'hugetlb" term is also (and mostly) used synonymously with a HugePage (See Note 261889.1). In this document the term "HugePage" is going to be used but keep in mind that mostly "hugetlb" refers to the same concept.

**hugetlbfs** 

This is a new in-memory filesystem like tmpfs and is presented by 2.6 kernel. Pages allocated on hugetlbfs type filesystem are allocated in HugePages.



## commands

get the size of page table

```
grep PageTables /proc/meminfo
```

get ths hugepages total

```
grep -i HugePages_Total /proc/meminfo 
```

get the size of huge pages

```
grep Hugepagesize /proc/meminfo
```




https://manybutfinite.com/post/anatomy-of-a-program-in-memory/

https://manybutfinite.com/post/how-the-kernel-manages-your-memory/

