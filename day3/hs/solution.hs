import System.IO
import Data.List.Split
import Data.List
import qualified Data.Map as Map

type Rectangle = (Int, Int, Int, Int) -- (x, y, w, h)
type Coordinate = (Int, Int) -- (x, y)

listToRect :: [Int] -> Rectangle
listToRect [_, x, y, w, h] = (x, y, w, h)
listToRect _ = (10, 20, 30, 40)

-- parse a line into a rectangle
parseRect :: String -> Rectangle
parseRect =
  listToRect . map read . filter (/="") . splitOneOf "#@,:x "

-- Calculate list of Coords contained in rectangle
rectToCoords :: Rectangle -> [Coordinate]
rectToCoords (x, y, w, h) =
  [(x', y') | x' <- [x+1..x+w] , y' <- [y+1..y+h]]

flatten = intercalate []

main = do
  handle <- openFile "../input.txt" ReadMode
  contents <- hGetContents handle
  let
    rects = map parseRect (lines contents)
    coordList = flatten (map rectToCoords rects)
    weightedCoordList = map (\c -> (c, 1)) coordList
    coordCounts = Map.fromListWith (+) weightedCoordList
    part1 = Map.size $ (Map.filter $ (>1)) coordCounts
  print "rects:"
  print rects
  print "coordList:"
  print coordList
  print "part 1:"
  print part1
  hClose handle
