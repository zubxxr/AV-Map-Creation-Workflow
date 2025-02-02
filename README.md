# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This document outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D model compatible with AWSIM and Autoware. Demonstrations have been provided below for each part. This [Google Drive](https://drive.google.com/drive/folders/1Mtkr13VCS5KdGLns7JRVTOxwJmy0Xnit?usp=drive_link) also contains all the demonstrations.

<img src="https://github.com/zubxxr/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/blob/main/assets/OSM-Mesh-Workflow.png" alt="image" style="width: 700px;">

## Steps:

1. **Download OSM File**: [Demonstration](https://drive.google.com/file/d/1siUoWQ66YDEZnNxpCEGZUtRvuZyRF7Ho/view?usp=drive_link)
 
    - Select the location you want to create a map for.
    ![image](https://github.com/user-attachments/assets/a0fe3473-11da-4b74-9fa5-31b8ce43e652)

    - Click Export to download a **map.osm** file.


2. **Convert OSM to OBJ**: [Demonstration](https://drive.google.com/file/d/1dyTxqLgO2tPrpjYVindg-_BhmtaVfODf/view?usp=drive_link)

    - Utilize OSM2World to convert the OSM file into an OBJ format.
    - Export the OBJ folder containing part_obj_textures, materials.mtl, and part0000.obj.

3. **Import OBJ mesh file into CloudCompare and Generate PCD**: [Demonstration](https://drive.google.com/file/d/1cAZZyMCDsIj3vTjb7KjpvkoFsfH8ReB2/view?usp=drive_link)

    - Use CloudCompare to import the OBJ mesh file along with its associated files.
    - Ensure all files are stored in the same directory.
    - In Cloud Compare, select the mesh in the DB Tree, then Edit > Mesh > Sample Points and click OK.
    - Save the sampled file as a .pcd file.

4. **Adjust View Angle & Convert Format**: [Demonstration](https://drive.google.com/file/d/1atm-YRY9qiV59AITQKHuUumpNAuUOszs/view?usp=drive_link)

    - If there are view angle issues, apply the following commands for a top-down view:

      ```bash
      pcl_transform_point_cloud original_point_cloud_input.pcd preliminary_rotation_result.pcd -axisangle 1,0,0,-1.5708
      pcl_transform_point_cloud preliminary_rotation_result.pcd transformed_top_down_view.pcd -axisangle 1,0,0,3.1416
      ```
    - Convert the .pcd file from ASCII to binary using:
      
      ```bash
      pcl_convert_pcd_ascii_binary transformed_top_down_view.pcd final_output.pcd 1
      ```

    

5. **Create Lanelets**: [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)

    - Import the .pcd file into [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/).
    - Specify the MGRS of the map.
    - Create lanelets and other required elements.

6. **Import Files to Autoware**: [Demonstration](https://drive.google.com/file/d/1JRt64q4x_NL__mK30LJ7Vgzp1ZBU6C9e/view?usp=drive_link)
   

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*
