import sys
import xml.etree.ElementTree as ET

def update_lat_lon_to_empty(node):
    # Set lat and lon attributes to empty strings
    node.set("lat", "")
    node.set("lon", "")

def update_lat_lon_in_file(input_file, output_file):
    # Parse the XML file
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Iterate over all elements and update lat and lon if both attributes are present
    for elem in root.iter():
        if 'lat' in elem.attrib and 'lon' in elem.attrib:
            update_lat_lon_to_empty(elem)

    # Save the modified XML to the output file
    tree.write(output_file, encoding="utf-8", xml_declaration=True)

def main():
    # Check if the correct number of command line arguments is provided
    if len(sys.argv) != 3:
        print("Usage: python script.py input_file.xml output_file.xml")
        sys.exit(1)

    # Get input and output file names from command line arguments
    input_file = sys.argv[1]
    output_file = sys.argv[2]

    # Update lat and lon in the input file and save to the output file
    update_lat_lon_in_file(input_file, output_file)

if __name__ == "__main__":
    main()
