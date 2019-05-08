
with open("../input.txt", 'r') as f:
    numStrs = f.read().split()

nums = list(map(int, numStrs))


# type tree = ([children], [metadata])
def build_tree(nums):
    """
    Takes in a list of integers and returns a tree.
    Mutates the input stream
    """
    numNodes = nums.pop(0)
    numMeta = nums.pop(0)

    children = []
    for i in range(numNodes):
        children.append(build_tree(nums))

    meta = []
    for i in range(numMeta):
        meta.append(nums.pop(0))

    return (children, meta)


tree = build_tree(nums)

# Now traverse the tree and sum the metadata

def sum_tree(t):
    subtotal = 0
    for child in t[0]:
        subtotal += sum_tree(child)
    return sum(t[1]) + subtotal

print(sum_tree(tree))
