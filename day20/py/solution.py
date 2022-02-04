class room:
  def __init__(self, x, y):
    self.x = x
    self.y = y
    self.n = False
    self.s = False
    self.e = False
    self.w = False


def parser(input):
    '''
    Parses a string of input regex into a list of tokens.
    Tokens can be either a string of NSEW characters, or a set of options
    '''
    tokens = []
    for char in input:
      if char in "NSEW":
        tokens.append(char)
      elif char == '(':
######### Main Program ############

# Read input from file chopping ^ and $
with open("../ex1.txt", 'r') as f:
  input = f.read()[1, -1]

# Parse input



# Build the graph

# Djykstra the graph
