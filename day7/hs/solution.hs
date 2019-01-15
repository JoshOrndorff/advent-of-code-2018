import Text.Parsec
import Text.Parsec.String

import qualified Data.Map as Map
import Data.List (sort, delete)
import qualified Data.Char as Char

import System.Environment (getArgs)
import Control.Monad (when)
import Debug.Trace (trace)

lineParser :: Parser (Char, Char)
lineParser = do
  string "Step "
  a <- letter
  string " must be finished before step "
  b <- letter
  string " can begin."
  return (b, a) -- Return order is (blocked, blocker)

buildGraph :: [(Char, Char)] -> Map.Map Char [Char]
buildGraph [] = Map.empty
buildGraph ((k,v):deps) =
  Map.insertWith (++) k [v] $ Map.insertWith (++) v [] $ buildGraph deps


partitionErrors :: ([ParseError], [(Char, Char)]) -> [Either ParseError (Char, Char)] -> ([ParseError], [(Char, Char)])
partitionErrors accs [] = accs
partitionErrors (errs, goods) (x:xs) =
  case x of
    Right good -> partitionErrors (errs, good:goods) xs
    Left  err  -> partitionErrors (err:errs,  goods) xs

getEligible :: Map.Map Char [Char] -> [Char]
getEligible = sort . Map.keys . Map.filter (=="")

charToTime = (subtract 4) . Char.ord -- A is ascii code 65.


--Could be tail recursive, but list would be reversed
resolve :: Map.Map Char [Char]-> String
resolve m | Map.null m = "" -- https://stackoverflow.com/a/46144683/4184410
resolve graph =
  let
    eligible = getEligible graph
    next = head eligible
    remaining = Map.map (delete next) . Map.delete next $ graph
  in
    next : resolve remaining

part2 :: Map.Map Char [Char] -> Map.Map Char Int -> Int
part2 graph timers | Map.null graph = maximum $ Map.elems timers
part2 graph timers =
  let
    eligible = getEligible graph
  in
    if ((length eligible) > 0) && ((Map.size timers) < 5) then
      let starting = head eligible in
        part2 (Map.delete starting graph) $ Map.insert starting (charToTime starting) timers
    else
      let
        ticksPassed = minimum $ Map.elems timers
        updatedTimers = Map.map (subtract ticksPassed) $ timers
        (running, expired) = Map.partition (>0) $ updatedTimers
        finished = head $ Map.keys expired --TODO Probably this is giving me the head of empty list
        remainingGraph = Map.map (delete finished) graph
      in
        ticksPassed + (part2 remainingGraph running)



main = do
  args <- getArgs
  rawContents <- readFile $ head args
  let parsedLines = map (parse lineParser "") $ lines rawContents
  let (errors, dependencies) = partitionErrors ([], []) parsedLines
  when (length errors > 0) $ do
    putStrLn $ (show . length $ errors) ++ " line(s) didn't parse. Ignoring"
  let graph = buildGraph dependencies
  print $ resolve graph
  print $ part2 graph Map.empty
