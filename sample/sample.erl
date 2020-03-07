-module(sample).
-import(lists,[nth/2]).
-export([main/2]).
-export([create/2, create/4, loop/2]).


main(Input_file, Output_file) ->
	{ok, File} = file:open(Input_file,[read]),
	{ok, Txt} = file:read(File,1024*1024),
	

	% io:format("~p\n",[Txt]),
	Numbers = [ element(1, string:to_integer(Substr)) || Substr <- string:tokens(Txt, ", ")],

	N = nth(1,Numbers),
	Token = nth(2,Numbers),

	% io:format("Original = ~p\n",[self()]),

	spawn(sample,create,[N,Token]).

	% io:format("~p ~p\n",[Token,N]).
	% {Input_file,Output_file}.

create(N,Token) ->
	io:format("Original = ~p\n",[self()]),
	Id = N,
	create(Id,N,self(),Token).

create(1,1,Next,Token) ->
	% io:format("Process 0 received token ~p from")
	Next ! Token,
	io:format("Process ~p received token ~p from ~p\n",[1,Token,6]);

create(Id,N,Next,Token) ->
	Prev = spawn_link(sample,loop,[Id,Next]),
	create(Id-1,N-1,Prev,Token).

loop(Id,Next) ->
	receive
		Token ->
			% io:format("~p\n",[(Total-N+1) rem Total]),
			io:format("Process ~p received token ~p from process ~p\n",[Id,Token,Id-1]),
			Next ! Token,
			ok
	end.
