# Explanation

## Copyright

This explanation is originally Copyright © 2014 Brian Picciano.

## License

This explanation file is distributed under the [Eclipse Public License](https://www.eclipse.org/org/documents/epl-2.0/EPL-2.0.txt).  A copy of the license should be included with this file.

## Not a derivative work

The rest of the diamond square project is not licensed under EPL 2.0(originally created & Copyright © 2020 Sean Esopenko).  This is not a derivative work, as the diagrams below were only used as a reference for unit testing funcionality.

## Original Explanation by Brian Piccanio

```
A pass is defined as a square step followed by a diamond step. The next pass will be the square/dimaond steps on all the smaller squares generated in the pass. It works out that the number of passes required to fill in the grid is the same as the degree of the grid, where the first pass is 1.

So we can easily find patterns in the coordinates for a given degree/pass,
I've laid out below all the coordinates for each pass for a 3rd degree grid (which is 9x9).

Degree 3 Pass 1 Square
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . 1 . . . .] (4,4)
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]

Degree 3 Pass 1 Diamond
[. . . . 2 . . . .] (4,0)
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[2 . . . . . . . 2] (0,4) (8,4)
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . 2 . . . .] (4,8)

Degree 3 Pass 2 Square
[. . . . . . . . .]
[. . . . . . . . .]
[. . 3 . . . 3 . .] (2,2) (6,2)
[. . . . . . . . .]
[. . . . . . . . .]
[. . . . . . . . .]
[. . 3 . . . 3 . .] (2,6) (6,6)
[. . . . . . . . .]
[. . . . . . . . .]

Degree 3 Pass 2 Diamond
[. . 4 . . . 4 . .] (2,0) (6,0)
[. . . . . . . . .]
[4 . . . 4 . . . 4] (0,2) (4,2) (8,2)
[. . . . . . . . .]
[. . 4 . . . 4 . .] (2,4) (6,4)
[. . . . . . . . .]
[4 . . . 4 . . . 4] (0,6) (4,6) (8,6)
[. . . . . . . . .]
[. . 4 . . . 4 . .] (2,8) (6,8)

Degree 3 Pass 3 Square
[. . . . . . . . .]
[. 5 . 5 . 5 . 5 .] (1,1) (3,1) (5,1) (7,1)
[. . . . . . . . .]
[. 5 . 5 . 5 . 5 .] (1,3) (3,3) (5,3) (7,3)
[. . . . . . . . .]
[. 5 . 5 . 5 . 5 .] (1,5) (3,5) (5,5) (7,5)
[. . . . . . . . .]
[. 5 . 5 . 5 . 5 .] (1,7) (3,7) (5,7) (7,7)
[. . . . . . . . .]

Degree 3 Pass 3 Diamond
[. 6 . 6 . 6 . 6 .] (1,0) (3,0) (5,0) (7,0)
[6 . 6 . 6 . 6 . 6] (0,1) (2,1) (4,1) (6,1) (8,1)
[. 6 . 6 . 6 . 6 .] (1,2) (3,2) (5,2) (7,2)
[6 . 6 . 6 . 6 . 6] (0,3) (2,3) (4,3) (6,3) (8,3)
[. 6 . 6 . 6 . 6 .] (1,4) (3,4) (5,4) (7,4)
[6 . 6 . 6 . 6 . 6] (0,5) (2,5) (4,5) (6,5) (8,5)
[. 6 . 6 . 6 . 6 .] (1,6) (3,6) (5,6) (7,6)
[6 . 6 . 6 . 6 . 6] (0,7) (2,7) (4,7) (6,7) (8,7)
[. 6 . 6 . 6 . 6 .] (1,8) (3,8) (5,8) (7,8)
```