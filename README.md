# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This document outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D working model compatible with AWSIM and Autoware.

## Steps:

1. **Download OSM File**: [Demonstration](assets/1-OSM-File.mkv)
 
    - Obtain the desired OSM file from OpenStreetMap. 

2. **Convert OSM to OBJ**: [Demonstration](assets/2-Mesh-Extraction.mkv)

    - Utilize OSM2World to convert the OSM file into an OBJ format.
    - Export the OBJ folder containing part_obj_textures, materials.mtl, and part0000.obj.

3. **Import OBJ mesh file into CloudCompare and Generate PCD**: [Demonstration](assets/3-Mesh-To-PCD.mkv)

    - Use CloudCompare to import the OBJ mesh file along with its associated files.
    - Ensure all files are stored in the same directory.
    - In Cloud Compare, select the mesh in the DB Tree, then Edit > Mesh > Sample Points and click OK.
    - Save the sampled file as a .pcd file.

4. **Adjust View Angle & Convert Format**: [Demonstration](assets/4-PCD-Processing.mkv)

    - If there are view angle issues, apply the following commands for a top-down view:

      ```bash
      pcl_transform_point_cloud original_point_cloud_input.pcd preliminary_rotation_result.pcd -axisangle 1,0,0,-1.5708
      pcl_transform_point_cloud preliminary_rotation_result.pcd transformed_top_down_view.pcd -axisangle 1,0,0,3.1416
      ```
    - Uncompress the .pcd file using:
      
      ```bash
      pcl_convert_pcd_ascii_binary transformed_top_down_view.pcd final_output.pcd 1
      ```

    

5. **Create Lanelets**: [Demonstration](assets/5-MGRS-and-Lanelet-Creation.mkv)

    - Import the .pcd file into [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/).
    - Specify the MGRS of the map.
    - Create lanelets and other required elements.

6. **Import Files to Autoware**: [Demonstration](assets/6-Importing-Files-Into-Autoware.mkv)
   

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*
