import System.IO
import qualified Data.Set as Set

-- Part 1 stuff

finalFreq :: Int -> [Int] -> Int
finalFreq acc [] = acc
finalFreq acc (change:changes) = finalFreq (acc + change) changes


-- Part 2 stuff

-- Either found a frequency, or need to continue with the specified state
data MaybeFreq = Found Int | Continue (Set.Set Int) Int

repeatHelper :: Set.Set Int -> Int -> [Int] -> MaybeFreq
repeatHelper seen currentFreq [] = Continue seen currentFreq
repeatHelper seen currentFreq (change:changes) =
  let newFreq = currentFreq + change
  in
    if newFreq `Set.member` seen then
      Found newFreq
    else
      repeatHelper (Set.insert newFreq seen) newFreq changes

findRepeat :: (Set.Set Int) -> Int -> [Int] -> Int
findRepeat seen current changes =
  case repeatHelper seen current changes of
    Found x -> x
    Continue seen' current' -> findRepeat seen' current' changes


-- Main program stuff

parseInt :: String -> Int
parseInt ('+':pos) = read pos
parseInt ('-':neg) = -1 * (read neg)

main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let changes = map parseInt (words contents)
      part1 = finalFreq 0 changes -- I guess probably reduce would have worked here. How does that work in haskell?
      part2 = findRepeat Set.empty 0 changes
  print part1
  print part2
  hClose handle
