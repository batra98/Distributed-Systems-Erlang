%%% Author:  Leonardo Giordani <giordani.leonardo@gmail.com>
%%% Description: Implements a simple ring of processes with a single
%%%              message traveling once through the ring.
%%% Created: Jun 2013 by Leonardo Giordani

-module(tried).

%% Include some debug macros
% -define(debug, true).
% -include("debug.hrl").

%% User interface
-export([start/2]).

%% Private exports
-export([create/2, create/3, loop/1]).

%% This version of the processes ring program uses the first process as a
%% master that spawns all other processes. It links to each process it spawns,
%% but processes are not linked each other.
%% The first process then injects a single message in the ring, sending it to
%% the second process.

%% This spawns the first process. There is no need to register the process.
start(NumberProcesses, Message) ->
    spawn(tried, create, [NumberProcesses, Message]).

%% Function create/2 needs to be defined so that the first process can call
%% create/3 passing its pid through self().
create(NumberProcesses, Message) ->
    io:format("Original = ~p\n",[self()]),
    create(NumberProcesses, self(), Message).

%% Function create/3 manages the single process creation; in this version the
%% master process spawns each process and links to it. Then each process starts
%% a loop. When the ring is completed the first process injects the message and
%% terminates.
create(1, NextProcess, Message) ->
    io:format("Process ~p connected with ~p~n", [self(), NextProcess]),
    io:format("Process ~p injects message ~p~n", [self(), Message]),
    NextProcess ! Message;
create(NumberProcesses, NextProcess, Message) ->
    Prev = spawn_link(tried, loop, [NextProcess]),
    io:format("Process ~p created and connected with ~p~n", [Prev, NextProcess]),
    create(NumberProcesses - 1, Prev, Message).

%% Now loop/1 blocks each process making it wait for a message to pass along.
loop(NextProcess) ->
    receive
        Msg ->
            io:format("Process ~p got message ~p, passing it to ~p~n", [self(),Msg, NextProcess]),
            NextProcess ! Msg,
            ok
    end.