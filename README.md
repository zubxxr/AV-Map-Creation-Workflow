# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This repository outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D model compatible with AWSIM and Autoware. Demonstrations have been provided below for each part. This [Google Drive](https://drive.google.com/drive/folders/1Mtkr13VCS5KdGLns7JRVTOxwJmy0Xnit?usp=drive_link) also contains all the demonstrations.

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
   - Click **File > Open OSM file** and click on the newly downloaded OSM file from Step 1 and click **OK**.
   ![image](https://github.com/user-attachments/assets/51133bf5-49d2-46b7-812a-cd6e9cb93a2f)
   - You will see a 3D map automatically created from the OSM file.
   ![image](https://github.com/user-attachments/assets/6f8628cb-83fa-4875-9867-872d613dd2ce)


   - Click **File > Export OBJ** directory and select a directory to save the files in. Then click **OK**.  
   - Leave the **Graphics Primitives per file** at **10000** and click **OK**.  
       <p>
         <img src="https://github.com/user-attachments/assets/ee527217-88f6-4522-bf0e-e6aa5575329e" alt="Export OBJ settings">
       </p>


---

### 3. **Import OBJ mesh file into CloudCompare and Generate PCD**: [Demonstration](https://drive.google.com/file/d/1cAZZyMCDsIj3vTjb7KjpvkoFsfH8ReB2/view?usp=drive_link)

   - **Tools Required**: [CloudCompare](https://www.danielgm.net/cc/)
   - Use CloudCompare to import the OBJ mesh file. Ensure all files are stored in the same directory.
   - Click **File > Open**, and make sure the file type is set to **OBJ mesh** at the bottom right of the **Open file(s)** window, and select the OBJ file downloaded from Step 2.
   ![image](https://github.com/user-attachments/assets/86e7b04d-bef8-4950-88f6-4cd40a2002ba)

   - The 3D model will now be loaded into CloudCompare. You may have to zoom in and fix the orientation on the window to view the 3D model.
   ![image](https://github.com/user-attachments/assets/ec41a90b-a03b-4569-acee-79c89504eaba)

   - Next, to generate a Point Cloud, click on the mesh in the DB Tree, then **Edit > Mesh > Sample Points**, leave the default values, and click **OK**.  
       ![image](https://github.com/user-attachments/assets/1481abca-b19a-41b6-8966-c55e4f86f501)
       ![image](https://github.com/user-attachments/assets/a6e800a6-a4f0-4fb9-977e-daf3193c8382)

   - You will see a new file created, which is the Point Cloud file.       
       ![image](https://github.com/user-attachments/assets/b1f8e7e9-b560-4a2f-90aa-ccf2d907caca)

   - To view the Point Cloud, uncheck everything except the sampled file.
   ![image](https://github.com/user-attachments/assets/992aa2fc-2c0c-4535-9505-cfe438145477)

   - Click on the new file in the DB Tree, and click **File > Save**, and save it in your preferred directory. Choose any name. This will be saved as a .pcd (Point Cloud Data) file.
   ![image](https://github.com/user-attachments/assets/aa6542a6-b798-40b2-8b0e-b06a5215e325)

---

### 4. **Adjust View Angle & Convert Format**: [Demonstration](https://drive.google.com/file/d/1atm-YRY9qiV59AITQKHuUumpNAuUOszs/view?usp=drive_link)

   - **Tools Required**: [PCL](https://pointclouds.org/)
   - Some extra processing will be needed to fix the orientation of the Point Cloud before it can be loaded into Autoware.
   - To understand why, run the following command in a terminal in the same directory as the Point Cloud file created from Step 3.

      ```bash
      pcl_viewer <your_pointcloud>.pcd
      ```
   - Zoom in a little, and you can see how its a front facing view. We will have to fix it so that once we run **pcl_viewer** again, it will show us a top-down view.
   ![image](https://github.com/user-attachments/assets/71e1f903-01fe-41c4-9f64-dfbe2535bad5)

   - Exit the **pcl_viewer**, and run the following in the terminal for a top-down view:

      ```bash
      pcl_transform_point_cloud <your_pointcloud_file>.pcd first_transformation.pcd -axisangle 1,0,0,-1.5708
      pcl_transform_point_cloud first_transformation.pcd transformed_top_down_view.pcd -axisangle 1,0,0,3.1416
      ```
      ![image](https://github.com/user-attachments/assets/d11f5895-4909-479a-b7f1-6a48baf21394)
      ![image](https://github.com/user-attachments/assets/95434885-0804-423d-bcd9-07ef069bbdea)

   - Convert the .pcd file from ASCII to binary using:
      
      ```bash
      pcl_convert_pcd_ascii_binary transformed_top_down_view.pcd pointcloud_map.pcd 1
      ```
      Keep the output name as **pointcloud_map.pcd**. This is due to naming conventions required for Autoware, With this, the Point Cloud processing is done.

      ![image](https://github.com/user-attachments/assets/a5b5bb8c-21a6-4cbe-b5ea-3430095857c9)

   - View the final Point Cloud. Zoom in a bit, and you will see its a top-down view. 
     
      ```bash
      pcl_viewer <your_final_pointcloud>.pcd
      ```
      ![image](https://github.com/user-attachments/assets/9e6e3dcc-6f4f-4119-abe7-adb5b0d7e939)

---

### 5. **Create Lanelets**: [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)

#### **Tools Required**:  
- [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/)

- To use this tool, a point cloud must first be imported, and then a Lanelet2 map can be created on top of it.  

- Import the `.pcd` file into **Vector Map Builder**:  
    - Navigate to **File > Import PCD > Browse**, select the point cloud file created from Step 4, and click **Import**.  
    - You will see the point cloud in the window.  

  ![image](https://github.com/user-attachments/assets/6bf54634-dc88-4df5-a257-57de2560cdce)  

- Next, click **Create > Create Lanelet2Maps > Change Map Projector Info** and set the projector type to **MGRS**.  

  ![image](https://github.com/user-attachments/assets/3117a53d-9659-477b-b605-fef19873988c)  

- To set the Lanelet2 map in the correct location, the **Grid Zone** and **100,000-meter square** values are needed.  

- Use [this website](https://www.gps-coordinates.net/) to get the latitude and longitude of your extracted location from Step 1.  

  ![image](https://github.com/user-attachments/assets/cbd118c3-98af-4cff-b94b-5a55d135431d)  

- Enter the latitude and longitude into [this website](https://legallandconverter.com/p50.html) to obtain the **MGRS coordinates**.  

  ![image](https://github.com/user-attachments/assets/1b0d9bfb-8625-4a34-be4d-1095b2fdad51)  
  ![image](https://github.com/user-attachments/assets/af45ab5c-ff87-42d4-ab17-ce8668410440)  

- Based on the output, the **Grid Zone** is **17T** and the **100,000-meter square** is **PJ**. 
- Set those values in VectorMapBuilder and click **Update Map Projector Info**, and click **OK** on the popup. Finally, click **Create**.

  ![image](https://github.com/user-attachments/assets/d78f7a3c-3d72-494e-8f95-dbeb9dc565a0)  

- Lastly, create Lanelets and other required elements. You can:  
    - Follow the [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link).  
    - Search for tutorials on YouTube.  
    - Refer to the [manual](https://docs.web.auto/en/user-manuals/vector-map-builder/how-to-use).  

### 6. **Import Files to Autoware**: [Demonstration](https://drive.google.com/file/d/1JRt64q4x_NL__mK30LJ7Vgzp1ZBU6C9e/view?usp=drive_link)

   - **Tools Required**: [Autoware](https://www.autoware.org/)
   - Import the generated files into Autoware for use in simulations or real-world tests.

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*
