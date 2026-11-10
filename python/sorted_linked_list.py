# Point class for representing a node of a singly linked list
class Point:
    def __init__(self):
        self.elem = 0  # Element value (integer)
        self.next = None  # Reference to the next node

# Function for inserting a new element into the list after the current node
def vstav(lanka, info):
    q = Point()  # Create a new node
    q.elem = info  # Assign a value to the new node
    q.next = lanka.next  # The new node points to the next node of the current node
    lanka.next = q  # The current node points to the new node

# Function for displaying the elements of the list
def vyvid(lanka):
    q = lanka  # Start from the first node
    while q is not None:  # Until the end of the list is reached
        print(q.elem, end=' ')  # Display the element
        q = q.next  # Move to the next node
    print()  # Move to a new line after displaying the list

# Function for bubble sorting a singly linked list
def bubble_sort(lanka):
    if lanka is None:  # If the list is empty, there is nothing to sort
        return lanka

    swap = True  # Indicator of whether any swaps occurred during the current iteration
    while swap:  # Repeat while at least one swap has been made
        swap = False  # Initially assume that no swaps will occur
        current = lanka  # Start from the first node
        while current.next is not None:  # Traverse all nodes except the last one
            if current.elem > current.next.elem:  # If the elements are not in the correct order
                # Swap the values
                current.elem, current.next.elem = current.next.elem, current.elem
                swap = True  # Update the flag indicating that a swap occurred
            current = current.next  # Move to the next node
    return lanka  # Return the sorted list

# Main program
print("\nPlease enter numbers separated by spaces\n")
st = input().split(' ')  # Read the entered numbers as a string and split them by spaces
i = 0  # Indicator for the first number
num = int(st[i])  # Convert the first number to an integer

# Creating the first element of the list
vslov = Point()  # Create the first node
vslov.elem = num  # Assign a value to the first node
vslov.next = None  # The reference to the next node is initially empty (end of the list)
vlan = vslov  # The current node is the first node of the list

# Adding the remaining elements to the list
while i < len(st) - 1:  # Until all numbers in the list have been processed
    i += 1  # Move to the next number
    num = int(st[i])  # Convert the number to an integer
    vstav(vlan, num)  # Insert this number after the current node
    vlan = vlan.next  # Move to the new node (the one just added)

# Displaying the list before sorting
print("\nList before sorting:")
vyvid(vslov)  # Call the function to display the list

# Bubble sort
vslov = bubble_sort(vslov)  # Sort the list

# Displaying the list after sorting
print("\nList after sorting:")
vyvid(vslov)  # Display the sorted list