#!/bin/bash

# Define input and output filenames
OSM_FILE="/app/map.osm"
OBJ_FILE="/app/3D_Model/output.obj"
PCD_FILE="/app/output.pcd"
FIRST_TRANSFORM="/app/first_transformation.pcd"
SECOND_TRANSFORM="/app/transformed_top_down_view.pcd"
FINAL_PCD="/app/pointcloud_map.pcd"

mkdir -p /app/3D_Model

# Check if the pointcloud_map.pcd file exists
if [ ! -f $FINAL_PCD ]; then
    touch $FINAL_PCD
    echo "Created empty $FINAL_PCD"
fi

# Run osm2world to generate OBJ
echo "Generating OBJ file..."
java -jar /app/osm2world.jar --input $OSM_FILE -o $OBJ_FILE

echo "OBJ File created successfully!"

# Run pcl_mesh_sampling to generate PCD
echo "Generating PCD file..."
pcl_mesh_sampling $OBJ_FILE $PCD_FILE -leaf_size 0.5 -no_vis_result -n_samples 1000000

echo "Sampled PCD File created successfully!"

# Apply transformations
echo "Applying first transformation..."
pcl_transform_point_cloud $PCD_FILE $FIRST_TRANSFORM -axisangle 1,0,0,-1.5708

echo "Applying second transformation..."
pcl_transform_point_cloud $FIRST_TRANSFORM $SECOND_TRANSFORM -axisangle 1,0,0,3.1416

# Convert to binary PCD
echo "Converting to binary PCD format..."
pcl_convert_pcd_ascii_binary $SECOND_TRANSFORM $FINAL_PCD 1

# Cleanup: Remove intermediate PCD files
echo "Cleaning up intermediate files..."
rm -f $PCD_FILE $FIRST_TRANSFORM $SECOND_TRANSFORM

echo "Process completed successfully!"
