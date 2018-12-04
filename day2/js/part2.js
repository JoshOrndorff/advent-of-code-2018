const { readFileSync } = require('fs');

const input = readFileSync('input.txt', 'utf-8')
  .split('\n')
  .filter((x) => (x !== ""));

const pairs = cartesianProduct(input, input);
console.log(findCloseStrings(pairs));



function cartesianProduct(l1, l2) {
  let pairs = [];
  for(let x of l1){
    for(let y of l2){
      pairs.push([x,y]);
    }
  }
  return pairs;
}


function similarityString(s1, s2) {
  if (s1 === "") {
    return "";
  }
  //console.log("in similarity string " + s1 + " " + s2);
  const x = s1.slice(0, 1);
  const xs = s1.slice(1);
  const y = s2.slice(0, 1);
  const ys = s2.slice(1);

  if (x === y) {
    return x + similarityString(xs, ys);
  }
  return similarityString(xs, ys);
}

// Recursive attempt
// Fails with JavaScript heap out of memory
// If memory is increased, fails with
// RangeError: Maximum call stack size exceeded
// I guess recursion kinda sucks in js
function findCloseRecursive(allPairs) {
  if (allPairs.length === 0) {
    throw "It hit the fan";
  }

  const [s1, s2] = allPairs[0];
  const pairs = allPairs.slice(1);
  const similarity = similarityString(s1, s2);

  if (s1.length === similarity.length + 1) {
    return similarity
  }
  //console.log("comparing strings " + [s1, s2]);
  return findCloseStrings(pairs);
}


// Iterative attempt
function findCloseStrings(pairs) {
  for( let [s1, s2] of pairs ) {

    let similarity = similarityString(s1, s2);

    if (s1.length === similarity.length + 1) {
      return similarity
    }
    //console.log("comparing strings " + [s1, s2]);
  }
  throw "It hit the fan";
}
