module Set10a where

import Data.Char
import Mooc.Todo

------------------------------------------------------------------------------
-- Ex 1: Given a list, produce a new list where each element of the
-- original list repeats twice.
--
-- Make sure your function works with infinite lists.
--
-- Examples:
--   doublify [7,1,6]          ==>  [7,7,1,1,6,6]
--   take 10 (doublify [0..])  ==>  [0,0,1,1,2,2,3,3,4,4]

doublify :: [a] -> [a]
doublify [] = []
doublify (x : xs) = x : x : doublify xs

------------------------------------------------------------------------------
-- Ex 2: Implement the function interleave that takes two lists and
-- produces a new list that takes elements alternatingly from both
-- lists like this:
--
--   interleave [1,2,3] [4,5,6] ==> [1,4,2,5,3,6]
--
-- If one list runs out of elements before the other, just keep adding
-- elements from the other list.
--
-- Make sure your function also works with infinite lists.
--
-- Examples:
--   interleave [1,2,3] [4,5,6]            ==> [1,4,2,5,3,6]
--   interleave [1,2] [4,5,6,7]            ==> [1,4,2,5,6,7]
--   take 10 (interleave [7,7,7] [1..])    ==> [7,1,7,2,7,3,4,5,6,7]
--   take 10 (interleave [1..] (repeat 0)) ==> [1,0,2,0,3,0,4,0,5,0]

interleave :: [a] -> [a] -> [a]
interleave = interleaveA
  where
    interleaveA [] ys' = ys'
    interleaveA (x : xs') ys' = x : interleaveB xs' ys'

    interleaveB xs' [] = xs'
    interleaveB xs' (y : ys') = y : interleaveA xs' ys'

------------------------------------------------------------------------------
-- Ex 3: Deal out cards. Given a list of cards (strings), and a list
-- of players (strings), deal out the cards to the players in a cycle.
--
-- Make sure your function works with infinite inputs as well!
--
-- Example:
--   deal ["Hercule","Ariadne"] ["Ace","Joker","Heart"]
--     ==> [("Ace","Hercule"),("Joker","Ariadne"),("Heart","Hercule")]
--   take 4 (deal ["a","b","c"] (map show [0..]))
--     ==> [("0","a"),("1","b"),("2","c"),("3","a")]
--   deal ("you":(repeat "me")) ["1","2","3","4"]
--     ==> [("1","you"),("2","me"),("3","me"),("4","me")]
--
-- Hint: remember the functions cycle and zip?

deal :: [String] -> [String] -> [(String, String)]
deal players cards = zip cards $ cycle players

------------------------------------------------------------------------------
-- Ex 4: Given two lists, xs and ys, and an element z, generate an
-- infinite list that consists of
--
--  * the elements of xs
--  * z
--  * the elements of ys
--  * z
--  * the elements of xs
--  * ... and so on
--
-- Examples:
--   take 20 (alternate "abc" "def" ',') ==> "abc,def,abc,def,abc,"
--   take 10 (alternate [1,2] [3,4,5] 0) ==> [1,2,0,3,4,5,0,1,2,0]

alternate :: [a] -> [a] -> a -> [a]
alternate xs ys z = cycle $ xs ++ [z] ++ ys ++ [z]

------------------------------------------------------------------------------
-- Ex 5: Check if the length of a list is at least n. Make sure your
-- function works for infinite inputs.
--
-- Examples:
--   lengthAtLeast 2 [1,2,3] ==> True
--   lengthAtLeast 7 [1,2,3] ==> False
--   lengthAtLeast 10 [0..]  ==> True

lengthAtLeast :: Int -> [a] -> Bool
lengthAtLeast n = len 0
  where
    len n' [] = n' >= n
    len n' (_ : xs') = n' >= n || len (n' + 1) xs'

------------------------------------------------------------------------------
-- Ex 6: The function chunks should take in a list, and a number n,
-- and return all sublists of length n of the original list.
--
-- Make sure your function works with infinite inputs. The function
-- lengthAtLeast can help with this.
--
-- Examples:
--   chunks 2 [1,2,3,4] ==> [[1,2],[2,3],[3,4]]
--   take 4 (chunks 3 [0..]) ==> [[0,1,2],[1,2,3],[2,3,4],[3,4,5]]

chunks :: Int -> [a] -> [[a]]
chunks n xs = if lengthAtLeast n xs then take n xs : chunks n (tail xs) else []

------------------------------------------------------------------------------
-- Ex 7: Define a newtype called IgnoreCase, that wraps a value of
-- type String. Define an `Eq` instance for IgnoreCase so that it
-- compares strings in a case-insensitive way.
--
-- To help the tests, also implement the function
--   ignorecase :: String -> IgnoreCase
--
-- Hint: remember Data.Char.toLower
--
-- Examples:
--   ignorecase "abC" == ignoreCase "ABc"  ==>  True
--   ignorecase "acC" == ignoreCase "ABc"  ==>  False

newtype IgnoreCase = IgnoreCase String

instance Eq IgnoreCase where
  (IgnoreCase a) == (IgnoreCase b) = map toLower a == map toLower b

ignorecase :: String -> IgnoreCase
ignorecase = IgnoreCase

------------------------------------------------------------------------------
-- Ex 8: Here's the Room type and some helper functions from the
-- course material. Define a cyclic Room structure like this:
--
--  * maze1 has the description "Maze"
--    * The direction "Left" goes to maze2
--    * "Right" goes to maze3
--  * maze2 has the description "Deeper in the maze"
--    * "Left" goes to maze3
--    * "Right" goes to maze1
--  * maze3 has the description "Elsewhere in the maze"
--    * "Left" goes to maze1
--    * "Right" goes to maze2
--
-- The variable maze should point to the room maze1.
--
-- Examples:
--   play maze ["Left","Left","Left"]
--      ==> ["Maze","Deeper in the maze","Elsewhere in the maze","Maze"]
--   play maze ["Right","Right","Right","Right"]
--      ==> ["Maze","Elsewhere in the maze","Deeper in the maze","Maze","Elsewhere in the maze"]
--   play maze ["Left","Left","Right"]
--      ==> ["Maze","Deeper in the maze","Elsewhere in the maze","Deeper in the maze"]

data Room = Room String [(String, Room)]

-- Do not modify describe, move or play. The tests will use the
-- original definitions of describe, move and play regardless of your
-- modifications.

describe :: Room -> String
describe (Room s _) = s

move :: Room -> String -> Maybe Room
move (Room _ directions) direction = lookup direction directions

play :: Room -> [String] -> [String]
play room [] = [describe room]
play room (d : ds) = case move room d of
  Nothing -> [describe room]
  Just r -> describe room : play r ds

maze :: Room
maze = maze1
  where
    maze1 = Room "Maze" [("Left", maze2), ("Right", maze3)]
    maze2 = Room "Deeper in the maze" [("Left", maze3), ("Right", maze1)]
    maze3 = Room "Elsewhere in the maze" [("Left", maze1), ("Right", maze2)]
