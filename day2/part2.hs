import System.IO

similarityString :: String -> String -> String
similarityString "" "" = ""
similarityString (x:xs) (y:ys) =
  if x == y
    then x:(similarityString xs ys)
    else similarityString xs ys

findCloseStrings :: [(String, String)] -> String
findCloseStrings [] = "it hit the fan" --Should never get here because one close string is expected
findCloseStrings ((s1, s2):pairs) =
  let
    similarity = similarityString s1 s2
  in
    if (length similarity) == ((length s1) - 1)
      then similarity
      else findCloseStrings pairs

main = do
  handle <- openFile "input.txt" ReadMode
  contents <- hGetContents handle
  let strings = words contents
      pairs = [(x, y) | x <- strings, y <- strings]
      part1 = findCloseStrings pairs
  print part1
  hClose handle
