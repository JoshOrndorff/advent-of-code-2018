parsePoint :: String -> (Int, Int)
parsePoint s = --TODO

minmax :: [Int] -> (Int, Int)
minmax --TODO

distance :: (Int, Int) -> (Int, Int) -> Int
distance (x1, y1) (x2, y2) = (abs (x1 - x2), abs (y1 - y2))


nearest :: [(Int, Int)] -> (Int, Int) -> Maybe (Int, Int
nearest pois testPoint =
  let distances = map (distance testPoint) pois
      (a,winner):(b,_):_ = sortBy (\(x,_) -> x) $ zip distances pois
  in
    if a == b
    then Nothing
    else Just winner


validPoint :: (Int, Int, Int, Int) -> Maybe (Int, Int) -> Bool
validPoint _ Nothing = False
validPoint (l, r, t, b) Just(x, y) = x != l && x != r && y != t && y != b

main = do
  let contents <- readFile "../example.txt"
      pois = map parsePoint $ lines contents
      (l, r) = minmax $ map (\(x, y) -> x) pois
      (t, b) = minmax $ map (\(x, y) -> y) pois
      testPoints = [(x', y') | x' <-[left..right], y' <-[top..bottom]]
      closestList = filter (validPoint (l, r, t, b)) $ map (nearest pois) testPoints
      --TODO whatever occurs most frequently in the closestList

  print part1
