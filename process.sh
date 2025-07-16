#!/bin/bash

# Define input and output filenames
OSM_FILE="/app/map.osm"
OBJ_FILE="/app/3D_Model/output.obj"
PCD_FILE="/app/output.pcd"
MTL_FILE="/app/3D_Model/output.obj.mtl"
FINAL_PCD="/app/pointcloud_map.pcd"

mkdir -p /app/3D_Model

# Check if the pointcloud_map.pcd file exists
if [ ! -f $FINAL_PCD ]; then
    touch $FINAL_PCD
    echo "Created empty $FINAL_PCD"
fi

# Check if the output.pcd file exists
if [ ! -f $PCD_FILE ]; then
    touch $PCD_FILE
    echo "Created empty $PCD_FILE"
fi

# Run osm2world to generate OBJ
echo "Generating OBJ file..."
java -jar /app/osm2world.jar --input $OSM_FILE -o $OBJ_FILE

echo "OBJ File created successfully!"

# Clean the MTL file
if [ -f "$MTL_FILE" ]; then
    echo "Cleaning MTL file..."
    python3 /app/clean_mtl_file.py "$MTL_FILE"
    echo "MTL File cleaned successfully!"
else
    echo "Warning: MTL file not found. Skipping cleaning step."
fi

# Run CloudCompare to generate PCD
echo "Generating PCD file..."
CloudCompare -SILENT -O $OBJ_FILE -AUTO_SAVE OFF -SAMPLE_MESH DENSITY 100 -C_EXPORT_FMT PCD -SAVE_CLOUDS
echo "Sampled PCD File created successfully!"

# Ensure the output file is moved to the correct location
mv /app/3D_Model/output_SAMPLED_*.pcd $PCD_FILE

# Downsample to make pcd lighter on system
pcl_voxel_grid $PCD_FILE $PCD_FILE -leaf 0.1,0.1,0.1

# Apply transformations
echo "Applying first transformation..."
pcl_transform_point_cloud $PCD_FILE $PCD_FILE -axisangle 1,0,0,-1.5708

echo "Applying second transformation..."
pcl_transform_point_cloud $PCD_FILE $PCD_FILE -axisangle 1,0,0,3.1416

# Convert to binary PCD
echo "Converting to binary PCD format..."
pcl_convert_pcd_ascii_binary $PCD_FILE $FINAL_PCD 1

# Cleanup: Remove old PCD file
echo "Removing old PCD file..."
rm -f $PCD_FILE

echo "Process completed successfully!"
