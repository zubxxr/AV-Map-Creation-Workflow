# OSM to Unity 3D Model Conversion Workflow for AWSIM and Autoware

This repository outlines the steps involved in converting an OpenStreetMap (OSM) file into a Unity 3D model compatible with AWSIM and Autoware. Demonstrations have been provided below for each part. This [Google Drive](https://drive.google.com/drive/folders/1Mtkr13VCS5KdGLns7JRVTOxwJmy0Xnit?usp=drive_link) also contains all the demonstrations.

![image](https://github.com/user-attachments/assets/9bb35b4c-08e0-45d1-848d-f8a38e476b9a)

## Table of Contents
1. [Download OSM File](#download-osm-file)
2. [Generate OBJ Files and PCD Files](#generate-obj-files-and-pcd-files)
3. [Create Lanelets](#create-lanelets)
4. [Import Files to Autoware](#import-files-to-autoware)

## Steps:

### 1. **Clone The Repository and Create a New Directory**:
```bash
cd ~/
git clone https://github.com/zubxxr/OSM-to-Pointcloud-and-Lanelet-Conversion-Process
cd OSM-to-Pointcloud-and-Lanelet-Conversion-Process
mkdir map_files
cd map_files
```

---

### 2. **Download OSM File**: [Demonstration](https://drive.google.com/file/d/1siUoWQ66YDEZnNxpCEGZUtRvuZyRF7Ho/view?usp=drive_link)
    
   - **Tools Required**: Web browser, [OpenStreetMap](https://www.openstreetmap.org/)
   1. Open [OpenStreetMap](https://www.openstreetmap.org/), and search for the location you want to create a map for.
   
   2. Click **Export** in the top header, then select **Manually select a different area** on the left side.
   ![image](https://github.com/user-attachments/assets/f2cce522-7d22-4e11-b32c-a490805a4d1a)
    
   3. Resize the selection area as needed.
   ![image](https://github.com/user-attachments/assets/a0fe3473-11da-4b74-9fa5-31b8ce43e652)

   4. Click **Export** on the left side to download the OSM file. A file named **map.osm** will be saved in your **Downloads** folder.
   5. Move the **map.osm** file into the directory created earlier.
         ```bash
         mv ~/Downloads/map.osm ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files
         ```

---

### 2. **Generate OBJ Files and PCD Files**:

This step converts an OSM file into:  
- A **Point Cloud Data (PCD) file**  
- A **3D Model**, consisting of an OBJ file, MTL file, and a textures folder with PNG files  

1. Build the Docker Container:  
    ```bash
    cd ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process
    docker build -t osm-3d-pcd-pipeline .
    ```

2. Create an Empty PCD File (prevents the Container mistakenly saving it as a folder later):
    ```bash
    touch ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files/pointcloud_map.pcd
    ```

3. Run the Docker Container to Generate Files:
    ```bash
    docker run --rm -it -v $(pwd)/map_files/map.osm:/app/map.osm -v $(pwd)/map_files/3D_Model:/app/3D_Model -v $(pwd)/map_files/pointcloud_map.pcd:/app/pointcloud_map.pcd osm-3d-pcd-pipeline /bin/bash
    ```
4. Verify the Output Files:
    ```bash
    ls ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files
    ls ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files/3D_Model
    ```
    ![image](https://github.com/user-attachments/assets/7c60231d-5045-49b1-abac-2b90151af23a)

5. Change Folder Ownership:
   ```bash
   sudo chown -R $USER:$USER ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files/3D_Model
   ```

---

### 3. **Create Lanelets**: [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)

#### **Tools Required**:  
- [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/)

- To use this tool, a point cloud must first be imported, and then a Lanelet2 map can be created on top of it.  

1. Import the `.pcd` file into **Vector Map Builder**:  
    - Navigate to **File > Import PCD > Browse**, select the point cloud file created from Step 3, and click **Import**.  
    - You will see the point cloud in the window.  

      ![image](https://github.com/user-attachments/assets/3cf18bc9-0763-4ae2-8310-2b37a0e09c35)


2. Next, click **Create > Create Lanelet2Maps > Change Map Projector Info** and set the projector type to **MGRS**.
      ![image](https://github.com/user-attachments/assets/729e6e9a-9230-4633-8315-48a485ce6f42)


      ![image](https://github.com/user-attachments/assets/3117a53d-9659-477b-b605-fef19873988c)  

3. To set the Lanelet2 map in the correct location, the **Grid Zone** and **100,000-meter square** values are needed.
4. To get those values, the longitude and latitude values are first needed. 
5. Open the map.osm file, and there will be multiple lines with the **lat** and **lon** values.
      ![image](https://github.com/user-attachments/assets/3bfd614d-9a49-4a18-8315-46cc567f6ba6)


6. Copy any **lat** and **lon** value and enter them into [this website](https://legallandconverter.com/p50.html) to obtain the **MGRS coordinates**.
7. It does not matter which value you copy because they are all very similar.

      ![image](https://github.com/user-attachments/assets/1b0d9bfb-8625-4a34-be4d-1095b2fdad51)  
      ![image](https://github.com/user-attachments/assets/af45ab5c-ff87-42d4-ab17-ce8668410440)  

8. Based on the output, the **Grid Zone** is **17T** and the **100,000-meter square** is **PJ**. 
9. Set those values in VectorMapBuilder and click **Update Map Projector Info**, and click **OK** on the popup. Finally, click **Create**.

     ![image](https://github.com/user-attachments/assets/d78f7a3c-3d72-494e-8f95-dbeb9dc565a0)  

10. Create Lanelets and other required elements. You can:  
    - Follow the [Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link).  
    - Search for tutorials on YouTube.  
    - Refer to the [manual](https://docs.web.auto/en/user-manuals/vector-map-builder/how-to-use).
 
11. Export the Lanelet2 Map.
    - Click **File > Export Lanelet2Maps**.
    - Press **OK** on the popup.
    - Click **Download**.

    - Move it to the working directory..
      ```bash
      mv ~/Downloads/new_lanelet2_maps.osm ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process/map_files/
      ```
---

### 4. **Remove the Lat/Long Fields and Rename it for Autoware Naming Conventions**:

Run the following command:

```bash
cd ~/OSM-to-Pointcloud-and-Lanelet-Conversion-Process
python3 remove_lat_lon.py map_files/new_lanelet2_maps.osm map_files/lanelet2_map.osm
```
---

### 5. **Import Files to Autoware**: [Demonstration](https://drive.google.com/file/d/1JRt64q4x_NL__mK30LJ7Vgzp1ZBU6C9e/view?usp=drive_link)

   - **Tools Required**: [Autoware](https://www.autoware.org/)
   - After the steps above, the following files should be available in your directory:
       - A **Point Cloud Data (PCD) file** named **pointcloud_map.pcd**  
       - A **3D Model**, consisting of an OBJ file, MTL file, and a textures folder with PNG files
       - A Lanelet2 file named **lanelet2_map.osm**
  
   - Import the generated files into Autoware for use in simulations or real-world tests.

---

### 6. **Import Files to AWSIM**: [Demonstration]()

<br> 
*Note: README.md is a work in progress. More detailed documentation will be added soon.*


- LIBGL_ALWAYS_SOFTWARE=1 flatpak run org.cloudcompare.CloudCompare -SILENT -O output.obj -AUTO_SAVE OFF -SAMPLE_MESH DENSITY 50 -C_EXPORT_FMT PCD -SAVE_CLOUDS
- docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd)/map_files/map.osm:/app/map.osm --entrypoint bash -it osm-3d-pcd-pipeline
