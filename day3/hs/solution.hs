import System.IO
import qualified Data.Set as Set
import qualified Data.Map as Map
import Data.List
import Data.List.Split

type Claim = (Int, Int, Int, Int, Int)
type Coordinate = (Int, Int)


parseClaim :: String -> Claim
parseClaim =
  let
    listToClaim :: [Int] -> Claim
    listToClaim [i, x, y, w, h] = (i, x, y, w, h)
    listToClaim _ = (0, 10, 20, 30, 40) -- inexhaustive...
  in
  listToClaim . map read . filter (/="") . splitOneOf "#@,:x "

-- Calculate list of Coords contained in a claim
claimToCoords :: Claim -> [Coordinate]
claimToCoords (_, x, y, w, h) =
  [(x', y') | x' <- [x+1..x+w] , y' <- [y+1..y+h]]



overlapping :: [Claim] -> Set.Set Coordinate
overlapping claims =
  let
    flatten = intercalate []
    coordList = flatten (map claimToCoords claims)
    weightedCoordList = map (\c -> (c, 1)) coordList
    coordCounts = Map.fromListWith (+) weightedCoordList
  in
    Map.keysSet $ (Map.filter (>1)) coordCounts



noneInCommon :: Set.Set Coordinate -> Set.Set Coordinate -> Bool
noneInCommon a b = (==0) . Set.size $ Set.intersection a b



main = do
  handle <- openFile "../example.txt" ReadMode
  contents <- hGetContents handle
  let
    claims = map parseClaim (lines contents)
    overlappingCoords = overlapping claims
    coordsByClaim = Map.fromList . map (\c -> (c, Set.fromList $ claimToCoords c)) $ claims
    (goodClaim, _) = head . Map.toList . Map.filter (noneInCommon overlappingCoords) $ coordsByClaim
    (goodId, _, _, _, _) = goodClaim
  print "part 1:"
  print $ Set.size overlappingCoords
  print "part 2:"
  print goodId
  hClose handle
