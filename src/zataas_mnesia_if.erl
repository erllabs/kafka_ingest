-module(zataas_mnesia_if).

-export([write/1,
         read/2,
         delete/2,
         delete_object/1,
         clear_table/1,
         select/2]).

select(Tab,MatchSpec) ->
                Sel = fun(Tab1,MatchSpec1) -> mnesia:select(Tab1,MatchSpec1) end,
                mnesia:activity(sync_dirty,Sel,[Tab,MatchSpec],mnesia_frag).
 
write(Rec)->
   Write = fun(Rec1) ->
             case mnesia:write(Rec1) of
                ok ->
                        {ok,updated};
                Res ->
                        {error,Res}
             end
   end,
   mnesia:activity(sync_dirty, Write,[Rec],mnesia_frag).
 
read(Tab,Key) ->
        Read = fun(Tab1,Key1) ->
                case mnesia:read({Tab1,Key1}) of
                  [ValList] ->
                        ValList;
                   Res ->
                        Res
                end
        end,
        ValList = mnesia:activity(sync_dirty, Read, [Tab,Key], mnesia_frag),
        ValList.

clear_table(Tab) ->
        Del = fun(Tab1) -> mnesia:clear_table(Tab1) end,
        mnesia:activity(sync_dirty, Del, [Tab], mnesia_frag).

delete_object(Rec) ->
        Del = fun(Rec1) -> mnesia:delete_object(Rec1) end,
        mnesia:activity(sync_dirty, Del, [Rec], mnesia_frag).
 
delete(Tab,Key)->
        Del = fun(Tab1,Key1) -> mnesia:delete({Tab1,Key1}) end,
        mnesia:activity(sync_dirty, Del, [Tab,Key], mnesia_frag).