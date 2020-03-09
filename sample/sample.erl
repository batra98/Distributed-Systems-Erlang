-module(sample).
-import(lists,[nth/2]).
-export([main/1]).
-export([create/3, create/6, loop/4]).


main(Args) ->
	Input_file = nth(1,Args),
	Output_file = nth(2,Args),
	{ok, File} = file:open(Input_file,[read]),
	{ok, Txt} = file:read(File,1024*1024),
	file:close(Input_file),
	{ok, Out_File} = file:open(Output_file,[write]),
	

	% io:format("~p\n",[Txt]),
	Numbers = [ element(1, string:to_integer(Substr)) || Substr <- string:tokens(Txt, ", ")],

	N = nth(1,Numbers),
	Token = nth(2,Numbers),

	% io:format("Original = ~p\n",[self()]),

	spawn(sample,create,[Out_File,N,Token]).

	% io:format("~p ~p\n",[Token,N]).
	% {Input_file,Output_file}.

create(Out_File,N,Token) ->
	% io:format("Original = ~p\n",[self()]),
	Id = N,
	Total = N,
	create(Total,Out_File,Id,N,self(),Token).

create(Total,Out_File,1,1,Next,Token) ->
	% io:format("Process 0 received token ~p from")
	Next ! Token,
	io:format("Process ~p received token ~p from process ~p\n",[1 rem Total,Token,0 rem Total]);

create(Total,Out_File,Id,N,Next,Token) ->
	Prev = spawn_link(sample,loop,[Total,Out_File,Id,Next]),
	% io:format("~p ~p~n",[Prev,Next]),
	create(Total,Out_File,Id-1,N-1,Prev,Token).

loop(Total,Out_File,Id,Next) ->
	receive
		Token ->
			% io:format("~p\n",[(Total-N+1) rem Total]),
			io:format("Process ~p received token ~p from process ~p\n",[Id rem Total,Token,(Id-1) rem Total]),
			Next ! Token,
			ok
	end.
