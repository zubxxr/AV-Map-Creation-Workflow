import sys

def clean_mtl_file(file_path):
    # Keywords to remove
    remove_keywords = ["-clamp", "Ke", "map_d"]
    
    # Read the file and filter out unwanted lines
    with open(file_path, "r") as infile:
        lines = infile.readlines()
    
    with open(file_path, "w") as outfile:
        for line in lines:
            if not any(keyword in line for keyword in remove_keywords):
                outfile.write(line)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python clean_mtl.py <file.mtl>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    clean_mtl_file(file_path)
    print(f"Cleaned file: {file_path}")
