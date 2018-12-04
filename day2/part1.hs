import qualified Data.Map as Map
import System.IO

-- Frequency analysis on a single string
freqAnal ::  String -> Map.Map Char Int
freqAnal s = Map.fromListWith (\x y -> x + y) (map (\x -> (x, 1)) s)


doubsTrips :: String -> (Bool, Bool)
doubsTrips s =
  let freqList = Map.toList $ freqAnal s
      reducer (_, tripsYet) (_, 2) = (True, tripsYet)
      reducer (doubsYet, _) (_, 3) = (doubsYet, True)
      reducer (doubsYet, tripsYet) (_, _) = (doubsYet, tripsYet)
  in
    foldl (reducer) (False, False) (freqList)

countDoubsTrips :: [String] -> (Int, Int)
countDoubsTrips xs =
  let reducer :: (Int, Int) -> (Bool, Bool) -> (Int, Int)
      reducer (doubs, trips) (True, True) = (doubs + 1, trips + 1)
      reducer (doubs, trips) (True, False) = (doubs + 1, trips)
      reducer (doubs, trips) (False, True) = (doubs, trips + 1)
      reducer (doubs, trips) (False, False) = (doubs, trips)
  in
    foldl reducer (0,0) (map (doubsTrips) (xs))

main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let (doubs, trips) = countDoubsTrips $ words contents

  print (doubs * trips)
  hClose handle
