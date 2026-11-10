class DataInfo:
    def init(self):
        self.info = ""

class Point3:
    def init(self):
        self.kluch = 0
        self.zap = None
        self.lv = None
        self.pr = None

def treecheck(k, d):
    q = None
    rez = None
    b = False  # Check whether the node exists
    p = d      # Traversing the branches
    if d is not None:
        while True:
            q = p
            if p.kluch == k:
                b = True
            else:
                if k < p.kluch:
                    p = p.lv
                else:
                    p = p.pr
            if b or p is None:
                break
    rez = q
    return b, rez

def treewatch(d, st):
    if d is not None:
        treewatch(d.lv, "left=")
        print(st, d.kluch, "", d.zap.info)
        treewatch(d.pr, "right=")

def treeadd(k, d, rec):
    b, p = treecheck(k, d)
    if not b:
        t = DataInfo()
        t.info = rec
        s = Point3()
        s.kluch = k
        s.zap = t
        s.lv = None
        s.pr = None
        if d is None:
            d = s
        else:
            if k < p.kluch:
                p.lv = s
            else:
                p.pr = s
    return d

# Creating the tree according to your structure
vtree = None
vtree = treeadd(100, vtree, "Sentence")       # Root
vtree = treeadd(50, vtree, "Subject")         # Left child of the root
vtree = treeadd(75, vtree, "Apple tree")      # Right child of 50
vtree = treeadd(60, vtree, "Green")            # Left child of 75
vtree = treeadd(200, vtree, "Predicate")      # Right child of the root
vtree = treeadd(150, vtree, "Looks in")       # Left child of 200
vtree = treeadd(125, vtree, "Window")         # Left child of 150
vtree = treeadd(145, vtree, "into")           # Right child of 125

print("My tree:")
treewatch(vtree, "TOP1=")

# Printing the tree diagram with correct formatting
print("         ", vtree.kluch)
print("       ", vtree.zap.info)
print("        /     \\")
if vtree.lv and vtree.pr:
    print("      ", vtree.lv.kluch, "     ", vtree.pr.kluch)
    print("    ", vtree.lv.zap.info, "  ", vtree.pr.zap.info)
    print("     /          \\")
    if vtree.lv.pr:  # 75 (Apple tree)
        print("   ", vtree.lv.pr.kluch, "        ", vtree.pr.lv.kluch)
        print(" ", vtree.lv.pr.zap.info, "       ", vtree.pr.lv.zap.info)
        print("   /               \\")
        if vtree.lv.pr.lv:  # Green
            print(" ", vtree.lv.pr.lv.kluch, "              ", vtree.pr.lv.lv.kluch)
            print("", vtree.lv.pr.lv.zap.info, "           ", vtree.pr.lv.lv.zap.info)
            print("                         \\")
            if vtree.pr.lv.lv.pr:  # "into"
                print("                        ", vtree.pr.lv.lv.pr.kluch)
                print("                         ", vtree.pr.lv.lv.pr.zap.info)