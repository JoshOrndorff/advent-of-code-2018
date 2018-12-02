// It's not 5
// It's not -17

const { readFileSync } = require('fs');

const input = readFileSync('input.txt', 'utf-8')
  .split('\n')
  .map((x) => parseInt(x, 10))
  .filter((x) => !isNaN(x));

// Part 1
const part1 = input.reduce(((x, y) => x + y), 0);
console.log("part 1 is: " + part1);

// Part 2
// Recursive attempt
function firstDupe(seen, total, remaining, original) {
  console.log(`next is ${remaining[0]}, remaining ${remaining.length}, total is ${total}, seen ${seen.size}`)
  if (remaining.length === 0) {
    return firstDupe(seen, total, original, original)
  }

  total += remaining[0];
  if (seen.has(total)) {
    return total;
  }
  seen.add(total);
  return firstDupe(seen, total, remaining.slice(1), original);
}

// Iterative attempt
function repeatedTotal(changes) {
  let total = 0;
  let seen = new Set([0]);
  while(true) {
    for (let change of changes) {
      total += change;
      console.log(`next is ${change}, total is ${total}, seen ${seen.size}`)
      if (seen.has(total)) {
        return total;
      }
      seen.add(total);
    }
  }
}

console.log(repeatedTotal(input))
//const part2 = firstDupe(new Set([0]), 0, input, input)
//console.log("part 2 is: " + part2);
