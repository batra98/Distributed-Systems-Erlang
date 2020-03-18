-module('20171114_2').
-import(lists,[nth/2]).
-export([main/1]).
-export([create/4,create/3,mergesort/3,ms/1,print/1]).

main(Args) ->
	Input_file = nth(1,Args),
	Output_file = nth(2,Args),
	% {ok,File} = file:open(Input_file,[read]),
	{ok,File} = file:read_file(Input_file),
	% file:close(Input_file),
	L = string:tokens(erlang:binary_to_list(File)," "),
	Numbers=lists:map(fun(X) -> list_to_integer(X) end,L),

	Process_num = 7,
	if
		(length(Numbers) rem Process_num) == 0 ->
			Chunks = (length(Numbers) div Process_num);
		true ->
			Chunks = (length(Numbers) div Process_num)+1
	end,

	% Numbers = [element(1, string:to_integer(Substr)) || Substr <- string:tokens(erlang:binary_to_list(File)," ")],
	A=[lists:sublist(Numbers, X, Chunks) || X <- lists:seq(1,length(Numbers),Chunks)],
	% A = n_length_chunks(Numbers,2),
	% io:format("~w\n",[A]),
	% Numbers = [ element(1, string:to_integer(Substr)) || Substr <- string:tokens(Txt, ", ")],
	F_pid = spawn('20171114_2',print,[Output_file]),
	spawn('20171114_2',create,[A,length(A),F_pid]).
	


print(Output_file) ->
	receive
		{L} ->
			% io:format("receive"),
			{ok,Out_File} = file:open(Output_file,[write]),
			X=lists:flatten([io_lib:format("~p ",[V]) || V<-L]),
			io:format(Out_File,"~s",[X]),
			file:close(Output_file)
	end.	

	

create(_,_,0,_) ->
	[];

create(Index,X,N,Parent) ->
	A = nth(Index,X),
	% io:format("~p\n",[A]),
	Pid = spawn('20171114_2',mergesort,[Parent,A,N-1]),
	create(Index+1,X,N-1,Pid).

create(X,N,Parent) ->
	Index = 1,
	% io:format("~p\n",[X]).
	create(Index,X,N,Parent).



mergesort(Parent,A,N) ->
	B=ms(A),
	% io:format("~w ~w ~w ~w\n",[Parent,B,N,self()]),

	if
		N == 0 ->
			% io:format("~w send to ~w\n",[self(),Parent]),
			Parent ! {B};

		N /= 0 ->
			receive
				{L} ->
					% io:format("~w send to ~w\n",[self(),Parent]),
					X = lists:merge(B,L),
					% io:format("~w\n",[X]),
					Parent ! {X}
			end
	end.


ms([L]) -> [L]; 

ms(L) ->
    {L1,L2}=lists:split(length(L) div 2, L),
    lists:merge(ms(L1), ms(L2)).
