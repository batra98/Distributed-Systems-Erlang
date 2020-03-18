-module(mergesort).
-export([mergesort/1]).
-import(lists,[nth/2]). 

mergesort([]) -> [];
mergesort([E]) -> [E];
mergesort(L) ->
  {A, B} = lists:split(trunc(length(L)/2), L),
lists:merge(mergesort(A), mergesort(B)).