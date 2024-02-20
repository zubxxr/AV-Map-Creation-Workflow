# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This document outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D working model compatible with AWSIM and Autoware.

## Steps:

#### 1. Download OSM File:

- Obtain the desired OSM file from OpenStreetMap.

#### 2. Convert OSM to OBJ:

- Utilize OSM2World to convert the OSM file into an OBJ format.
- Export the OBJ folder containing part_obj_textures, materials.mtl, and part0000.obj.

#### 3. Import OBJ into CloudCompare:

- Use CloudCompare to import the OBJ file along with its associated files.
- Ensure all files are stored in the same directory.

#### 4. Generate Point Cloud from OBJ:

- In CloudCompare, select the model, then navigate to edit, mesh, and sample points.
- Save the sampled points as a .pcd file.

#### 5. Adjust View Angle (if necessary):

- If there are view angle issues, apply the following commands for a top-down view:

```
pcl_transform_point_cloud input.pcd output.pcd -axisangle 1,0,0,-1.5708
pcl_transform_point_cloud output_from_last_command.pcd new_output.pcd -axisangle 1,0,0,3.1416
```

#### 6. Convert Point Cloud Format:

- Uncompress the .pcd file using:
```
pcl_convert_pcd_ascii_binary input.pcd output.pcd 1
```

Import Point Cloud into Vector Map Builder (https://tools.tier4.jp/vector_map_builder_ll2/):

- Import the .pcd file into the vector map builder.
- Specify the MGRS of the map.
- Create lanelets and other required elements.
