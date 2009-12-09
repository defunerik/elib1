%% Copyright (c) 2006-2009 Joe Armstrong
%% See MIT-LICENSE for licensing information.

-module(decode).

-compile(export_all).

-import(lists, [reverse/1, seq/2, sum/1]).

zigzag([X1, X2, X3, X4, X5, X6, X7, X8,
       X9, X10,X11,X12,X13,X14,X15,X16,
       X17,X18,X19,X20,X21,X22,X23,X24,
       X25,X26,X27,X28,X29,X30,X31,X32,
       X33,X34,X35,X36,X37,X38,X39,X40,
       X41,X42,X43,X44,X45,X46,X47,X48,
       X49,X50,X51,X52,X53,X54,X55,X56,
       X57,X58,X59,X60,X61,X62,X63,X64]) ->
    [X1,X2,X9,X17,X10,X3,X4,X11,X18,
     X25,X33,X26,X19,X12,X5,X6,X13,
     X20,X27,X34,X41,X49,X42,
     X35,X28,X21,X14,X7,X8,X15,X22,X29,
     X36,X43,X50,X57,X58,X51,X44,X37,X30,X23,X16,X24,X31,X38,
     X45,X52,X59,X60,X53,X46,X39,X32,X40,X47,
     X54,X61,X62,X55,X48,X56,X63,X64].

data1() ->
    {139,144,149,153,155,155,155,155,
     144,151,153,156,159,156,156,156,
     150,155,160,163,158,156,156,156,
     159,161,162,160,160,159,159,159,
     159,160,161,162,162,155,155,155,
     161,161,161,161,160,157,157,157,
     162,162,161,163,162,157,157,157,
     162,162,161,161,163,158,158,158}.

quant() ->
    [16,11,10,16,24,40,51,61,
     12,12,14,19,26,58,60,55,
     14,13,16,24,40,57,69,56,
     14,17,22,29,51,87,80,62,
     18,22,37,56,68,109,103,77,
     24,35,55,64,81,104,113,92,
     49,64,78,87,103,121,120,101,
     72,92,95,98,112,100,103,99].

test1() ->
    D1 = data1(),
    D2 = list_to_tuple([I-128 || I <- tuple_to_list(D1)]),
    DCT = dct(D2),
    Q = quant(DCT,quant()),
    f8(Q).

quant([H1|T1],[QH|QT]) ->
    [iround(H1/QH)|quant(T1, QT)];
quant([], []) ->
    [].

iround(X) when X > 0 -> trunc(X+0.5);
iround(X) -> trunc(X-0.5).

dct(T) ->
    [bigF(U,V,T) || U <- seq(0,7), V <- seq(0,7)].

-define(Pi1, 0.19634954084936207). %% Pi/16

bigF(U,V,T) ->
    0.25 * c(U) * c(V) *
	sum([f(X,Y,T) * 
	     math:cos((2*X+1)*U*?Pi1) *
	     math:cos((2*Y+1)*V*?Pi1) || X <- seq(0,7), Y <- seq(0,7)]).

f(X,Y,T) ->
    element(8*X+Y+1, T).

c(0) -> 0.7071067811865475;
c(_) -> 1.0.
    
f8([]) ->
    [];
f8(L) ->
    {H,T} = take(8, L, []),
    [H|f8(T)].
	
take(0, L, L1) ->
    {reverse(L1), L};
take(N, [H|T], L) ->
    take(N-1, T, [H|L]).