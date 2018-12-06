import System.IO
import Data.Char
import Data.List.Split (splitOneOf)

anhialate :: Char -> Char -> Bool
anhialate a b =
  (isUpper a == isLower b) && (toUpper a == toUpper b)

react :: String -> String -> String
react a "" = reverse a
react "" (b:bs) = react [b] bs
react (a:as) (b:bs) =
  if anhialate a b
    then react as bs
    else react (b:a:as) bs

removeOccurances :: String -> Char -> String
removeOccurances "" _ = ""
removeOccurances cs d = concat . splitOneOf [toUpper d, toLower d] $ cs

main = do
  polymerN <- readFile "../input.txt"
  let polymer:[] = lines polymerN
      reduced = react "" $ polymer
      allReduced = map (react "" . removeOccurances reduced) $ ['a'..'z']
      part1 = length reduced
      part2 = minimum . map length $ allReduced
  print part1
  print part2
