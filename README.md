# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This document outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D model compatible with AWSIM and Autoware. Demonstrations have been provided below for each part. This [playlist](https://youtube.com/playlist?list=PLeS09kz3NmdCWKZ0mzhWLT95PZ_UkcSlW&si=Yb3to5FhjK-JcwSk) also contains all the demonstrations.

<img src="https://github.com/zubxxr/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/blob/main/assets/OSM-Mesh-Workflow.png" alt="image" style="width: 700px;">

## Steps:

1. **Download OSM File**: [Demonstration](https://youtu.be/XRM1CWqoilY?si=k4Z60OI0aAYvFbIY)
 
    - Obtain the desired OSM file from OpenStreetMap. 

2. **Convert OSM to OBJ**: [Demonstration](https://youtu.be/EcEMcxI5B8I?si=jfZtykDK3_kFkCEJ)

    - Utilize OSM2World to convert the OSM file into an OBJ format.
    - Export the OBJ folder containing part_obj_textures, materials.mtl, and part0000.obj.

3. **Import OBJ mesh file into CloudCompare and Generate PCD**: [Demonstration](https://youtu.be/x9EbpukDEtI?si=wLUtBe0_kmvFjB0e)

    - Use CloudCompare to import the OBJ mesh file along with its associated files.
    - Ensure all files are stored in the same directory.
    - In Cloud Compare, select the mesh in the DB Tree, then Edit > Mesh > Sample Points and click OK.
    - Save the sampled file as a .pcd file.

4. **Adjust View Angle & Convert Format**: [Demonstration](https://youtu.be/U-Kz_an1IyM?si=cCpnjo5GM6epVi0N)

    - If there are view angle issues, apply the following commands for a top-down view:

      ```bash
      pcl_transform_point_cloud original_point_cloud_input.pcd preliminary_rotation_result.pcd -axisangle 1,0,0,-1.5708
      pcl_transform_point_cloud preliminary_rotation_result.pcd transformed_top_down_view.pcd -axisangle 1,0,0,3.1416
      ```
    - Uncompress the .pcd file using:
      
      ```bash
      pcl_convert_pcd_ascii_binary transformed_top_down_view.pcd final_output.pcd 1
      ```

    

5. **Create Lanelets**: [Demonstration](https://youtu.be/L9ijGCOvHXw?si=YF_KEIsLrELkaID9)

    - Import the .pcd file into [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/).
    - Specify the MGRS of the map.
    - Create lanelets and other required elements.

6. **Import Files to Autoware**: [Demonstration](https://youtu.be/J-14XYo3Ww4?si=exdyb04r5s6vO_Up)
   

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*
