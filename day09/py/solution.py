#!/usr/bin/env python3

# Problem inputs
# 9 players; last marble is worth 25 points: high score is 32

# 10 players; last marble is worth 1618 points: high score is 8317
# 13 players; last marble is worth 7999 points: high score is 146373
# 17 players; last marble is worth 1104 points: high score is 2764
# 21 players; last marble is worth 6111 points: high score is 54718
# 30 players; last marble is worth 5807 points: high score is 37305

# 465 players; last marble is worth 71498 points



class Marble:
    def __init__(self):
        self.number = 0
        self.cw = self
        self.ccw = self

    def remove_ccw(self):
        """ Removes the clockwise marble from the circle, and returns it """
        removed = self.ccw

        removed.ccw.cw = self
        self.ccw = removed.ccw

        return removed

    def insert_cw(self, newNum):
        newMarble = Marble()
        newMarble.number = newNum
        newMarble.cw = self.cw
        newMarble.ccw = self

        self.cw.ccw = newMarble
        self.cw = newMarble

def something_entirely_different(current):
    next = current
    for i in range(6):
        next = next.ccw
    return next.remove_ccw()

# Initialize
players = 465
lastMarble = 7149800

currentMarble = Marble()
scores = {}

# Execute the game
for number in range(1, lastMarble + 1):
    player = number % players

    if number % 23 != 0:
        # OOhhh, traversing twice
        currentMarble.cw.insert_cw(number)
        currentMarble = currentMarble.cw.cw
    else:
        removed = something_entirely_different(currentMarble)
        try:
            scores[player]
        except KeyError:
            scores[player] = 0

        scores[player] += number + removed.number
        currentMarble = removed.cw

# Search for best score.
# This could be optimized away by keeping track of the highest score as we go.
topScore = -1
winner = -1
for player, score in scores.iteritems():
    if score > topScore:
        topScore = score
        winner = player

print("Player {} won with a highscore of {}".format(winner, topScore))
