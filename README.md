# conway-life-exercises

Conway's Game of Life wikipedia @ https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

Key ideas:

- Keep a "before" and "after" data structure
- Be explicit in what you do on the edges (wrap or edge-of-world)
- The data structure does not need to be a grid. An infinite (sparse)
  structure can be built on top of string-to-bool hash/map table,
  where the coordinates are encoded into the string (if you have a
  predictable way to refer to the coordinates of your neighbors).
