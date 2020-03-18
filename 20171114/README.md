                                                     Assignment-IV
                                                  Distributed Systems
                                                     Gaurav Batra
                                                      20171114

Using Erlang to implement a simple token passing architecture and parallelized version of mergesort.
 
# Run
**Compile** : 
```
erlc <File>.erl
```

**Run**
```
erl -noshell -s <File> main input.txt output.txt -s init stop

```

# Files 
──> README.md       // Instructions

──> 20171114_1.erl     // Integer Token Passing 

──> 20171114_2.erl // Parallelized version of mergesort

## Token Passing:

1. The initiator process forms a chain of processes and passes the token through the chain in a ring like fashion.
2. After using `spawn_link` to form a chain of processes, the initiator passes the token to the last process of the chain.
3. The program is terminated when the token reaches the initiator again.

## Parrallel Merge-Sort:
1. We divide the array of Integers into 8 processes.
2. All the processes sort the processes locally and return the result to their parent for merging.
3. Eventually, the initiator receives the sorted Array,which it prints to output file. 