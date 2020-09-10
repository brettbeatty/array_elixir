# Array
Array is an implementation of Arrays in Elixir using tuples to store the contents. It was intended more as a learning exercise than anything useful. I wanted to experiment with some of the protocols available in Elixir by default as well as the Access behaviour. There is no relation to the [`:array` library](https://hex.pm/packages/array) published to hex.

## What I Like
I like how well things build on each other. Take, for example, the implementation of the `Inspect` protocol: it relies on `Array.to_list/1`, which relies on the implementation of the `Enumerable` protocol, which relies on `Array.shift/1`, which relies on the private `element_position/2`. Both `element_position/2` and another private function `normalize_index/2` are fundamental building blocks to the module.

I'm also pretty inexperienced with typespecs. I'm sure I've made plenty of mistakes with them, but it was interesting to learn more about them.

I think my favorite thing, though, is how arrays end up feeling less like a struct and more like their own data structure. Playing with this code in `IEx`, the implemented protocols give the appearance of polish.

## What I Don't Like
I wasn't sure what to name functions. I ended up drawing mostly on JavaScript array functions and Elixir Map functions for names, but I felt like I should have drawn more on Elixir List function names.

There are some style questions I wasn't quite sure about too. Do I include `@spec` typespecs on functions already tagged with `@impl`? Do I tag protocol implementations with `@impl`? Where do I put shared private functions? I normally like to put private functions under the public ones which call them (which are ordered alphabetically), but I have yet to find a preference for shared ones. I ended up putting them where they would be if public.

## What To Do
I don't know if I'll ever do these, but I'll note some things I might do later.
1. Implement a JSON encoder protocol to see it encode properly.
2. Name public functions more consistently.
3. Set up static analysis (credo & dialyxir, probably).
4. Figure out my typespec questions.
