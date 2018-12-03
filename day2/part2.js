const { readFileSync } = require('fs');

const input = readFileSync('input.txt', 'utf-8')
  .split('\n')
  .filter((x) => (x !== ""));
