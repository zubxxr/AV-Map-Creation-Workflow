# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This document outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D model compatible with AWSIM and Autoware. Demonstrations have been provided below for each part. This [Google Drive](https://drive.google.com/drive/folders/1Mtkr13VCS5KdGLns7JRVTOxwJmy0Xnit?usp=drive_link) also contains all the demonstrations.

![image](https://github.com/user-attachments/assets/7b99aa82-6462-4439-8ed8-299393451029)

## Table of Contents
1. [Download OSM File](#download-osm-file)
2. [Convert OSM to OBJ](#convert-osm-to-obj)
3. [Import OBJ mesh file into CloudCompare and Generate PCD](#import-obj-mesh-file-into-cloudcompare-and-generate-pcd)
4. [Adjust View Angle & Convert Format](#adjust-view-angle--convert-format)
5. [Create Lanelets](#create-lanelets)
6. [Import Files to Autoware](#import-files-to-autoware)

## Steps:

### 1. **Download OSM File**: [Demonstration](https://drive.google.com/file/d/1siUoWQ66YDEZnNxpCEGZUtRvuZyRF7Ho/view?usp=drive_link)
    
   - **Tools Required**: Web browser, OpenStreetMap
   - Select the location you want to create a map for.
   ![image](https://github.com/user-attachments/assets/a0fe3473-11da-4b74-9fa5-31b8ce43e652)

   - Click Export to download a **map.osm** file.

---

### 2. **Convert OSM to OBJ**: [Demonstration](https://drive.google.com/file/d/1dyTxqLgO2tPrpjYVindg-_BhmtaVfODf/view?usp=drive_link)

   - **Tools Required**: [OSM2World](http://osm2world.org/)
   - Click File > Open OSM file and click on the newly downloaded OSM file from Step 1 and click OK.
   ![image](https://github.com/user-attachments/assets/51133bf5-49d2-46b7-812a-cd6e9cb93a2f)
   - You will see a 3D map automatically created from the OSM file.
   ![image](https://github.com/user-attachments/assets/6f8628cb-83fa-4875-9867-872d613dd2ce)

   - Click File > Export OBJ directory and select a directory to save the files in. Then click OK.
   - Leave the Graphics Primitives per file at 10000 and click OK.
   ![image](https://github.com/user-attachments/assets/ee527217-88f6-4522-bf0e-e6aa5575329e)

   - You will then see 2 files and one folder, containing all the data for the 3D model.
   - The obj file is the 3D mesh file, the mtl file is the materials data file, and the textures folder contains all the pictures required to describe the environment.
   ![image](https://github.com/user-attachments/assets/f917622b-a596-4774-8546-41e49cc4b4e6)


---

### 3. **Import OBJ mesh file into CloudCompare and Generate PCD**: [Demonstration](https://drive.google.com/file/d/1cAZZyMCDsIj3vTjb7KjpvkoFsfH8ReB2/view?usp=drive_link)

   - **Tools Required**: [CloudCompare](https://www.danielgm.net/cc/)
   - Use CloudCompare to import the OBJ mesh file. Ensure all files are stored in the same directory.
   - Click File > Open, and make sure the file type is set to **OBJ mesh** at the bottom right of the **Open file(s)** window, and select the OBJ file downloaded from Step 2.
   ![image](https://github.com/user-attachments/assets/86e7b04d-bef8-4950-88f6-4cd40a2002ba)

   - The 3D model will now be loaded into CloudCompare. You may have to zoom in and fix the orientation on the window to view the 3D model.
   ![image](https://github.com/user-attachments/assets/ec41a90b-a03b-4569-acee-79c89504eaba)

   - Next, to generate a Point Cloud, click on the mesh in the DB Tree, then Edit > Mesh > Sample Points, leave the default values, and click OK.
   ![image](https://github.com/user-attachments/assets/1481abca-b19a-41b6-8966-c55e4f86f501)
   ![image](https://github.com/user-attachments/assets/a6e800a6-a4f0-4fb9-977e-daf3193c8382)

   - You will see a new file created, which is the Point Cloud file.
   ![image](https://github.com/user-attachments/assets/b1f8e7e9-b560-4a2f-90aa-ccf2d907caca)

   - Click on the new file in the DB Tree, and click File > Save, and save it in your preferred directory.
   ![image](https://github.com/user-attachments/assets/aa6542a6-b798-40b2-8b0e-b06a5215e325)


---

### 4. **Adjust View Angle & Convert Format**: [Demonstration](https://drive.google.com/file/d/1atm-YRY9qiV59AITQKHuUumpNAuUOszs/view?usp=drive_link)

   - **Tools Required**: [PCL](https://pointclouds.org/)
   - If there are view angle issues, apply the following commands for a top-down view:

      ```bash
      pcl_transform_point_cloud original_point_cloud_input.pcd preliminary_rotation_result.pcd -axisangle 1,0,0,-1.5708
      pcl_transform_point_cloud preliminary_rotation_result.pcd transformed_top_down_view.pcd -axisangle 1,0,0,3.1416
      ```
   - Convert the .pcd file from ASCII to binary using:
      
      ```bash
      pcl_convert_pcd_ascii_binary transformed_top_down_view.pcd final_output.pcd 1
      ```

---

### 5. **Create Lanelets**: [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)

   - **Tools Required**: [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/)
   - Import the .pcd file into Vector Map Builder.
   - Specify the MGRS of the map.
   - Create lanelets and other required elements.

---

### 6. **Import Files to Autoware**: [Demonstration](https://drive.google.com/file/d/1JRt64q4x_NL__mK30LJ7Vgzp1ZBU6C9e/view?usp=drive_link)

   - **Tools Required**: [Autoware](https://www.autoware.org/)
   - Import the generated files into Autoware for use in simulations or real-world tests.

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*
