"""
02_Remove_Duplicates.py
Remove duplicate characters using loop.
"""

def remove_duplicates(string):
    unique_string = ""

    for char in string:
        if char not in unique_string:
            unique_string += char

    return unique_string


if __name__ == "__main__":
    test_string = "platinumrx"
    print("Original String:", test_string)
    print("After Removing Duplicates:", remove_duplicates(test_string))

