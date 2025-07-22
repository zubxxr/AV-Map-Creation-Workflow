# AV Map Creation Workflow for Autonomous Vehicle Simulations

![Best Paper Award - GEOProcessing 2025](https://img.shields.io/badge/Best%20Paper-GEOProcessing%202025-brightgreen?style=flat-square)

## Publication and Recognition

This repository supports the paper:
> **Zubair Islam**, Ahmaad Ansari, George Daoud, Mohamed El-Darieby  
> *A Workflow for Map Creation in Autonomous Vehicle Simulations*  
> **GEOProcessing 2025** — Awarded **Best Paper**  
> [Read the full paper](https://www.thinkmind.org/library/GEOProcessing/GEOProcessing_2025/geoprocessing_2025_2_40_30041.html)

<p align="left">
  <img src="https://github.com/user-attachments/assets/8dc4020f-a378-4de7-b9d7-facc86c5a187" alt="Best Paper Award – GEOProcessing 2025" width="400"/>
</p>
---

## Overview

This repository outlines a simulator-agnostic workflow to create maps for Autonomous Vehicle (AV) simulation testing. It enables the generation of:

- **3D Mesh Models**
- **Point Cloud Data (PCD)**
- **Lanelet2 Maps**

These outputs are compatible with **Autoware** and **AWSIM**, facilitating both virtual AV testing and future real-world deployment. The workflow was designed to address the lack of easily reproducible, parking-lot-sized maps for AVP (Autonomous Valet Parking) research.

Demonstrations have been provided below for each part. This [Google Drive](https://drive.google.com/drive/folders/1Mtkr13VCS5KdGLns7JRVTOxwJmy0Xnit?usp=drive_link) also contains all the demonstrations.

## Motivation

At the time of this project's development, AWSIM and Autoware only included a single city-scale map, which lacked critical low-speed elements like parking lots. Moreover, existing documentation for map creation was often outdated or platform-dependent (e.g., CARLA, LGSVL).

To address this:
- Created a **custom parking lot map** of Ontario Tech University's SIRC campus.
- Designed a **lightweight workflow** that avoids heavy simulation dependencies like CARLA.
- Used **open-source, low-resource tools** to make the pipeline accessible.

## Architecture

### Full Workflow Diagram
![image](https://github.com/user-attachments/assets/975b8182-9a63-4b15-b198-fe80a1c99708)

### Automated Mapping via Docker
![image](https://github.com/user-attachments/assets/eff78a19-81f3-4990-9137-efca93cb049d)

---

## Table of Contents
1. [Complete Workflow: Step-by-Step Guide](#complete-workflow-step-by-step-guide)
2. [Workflow Success Demonstration](#workflow-success-demonstration)
3. [Related Publication and References](#related-publication-and-references)
4. [Localization Instability](#localization-instability)
5. [Limitations](#limitations)

---

## Complete Workflow: Step-by-Step Guide
Each step is supported with visuals and references to the paper and demo videos.

### Step 1: Clone the Repository and Set Up the Project Structure
```bash
cd ~/
git clone https://github.com/zubxxr/AV-Map-Creation-Workflow
cd AV-Map-Creation-Workflow
mkdir map_files
cd map_files
```

### Step 2: Download the OSM File

[Demonstration](https://drive.google.com/file/d/1siUoWQ66YDEZnNxpCEGZUtRvuZyRF7Ho/view?usp=drive_link)

Use **OpenStreetMap** to export your desired location as an OSM file.

1. Open [OpenStreetMap](https://www.openstreetmap.org/) and search for the location you want to create a map for.

2. Click **Export** in the top header, then select **Manually select a different area** on the left side.  
   ![image](https://github.com/user-attachments/assets/f2cce522-7d22-4e11-b32c-a490805a4d1a)

3. Resize the selection area as needed.  
   ![image](https://github.com/user-attachments/assets/a0fe3473-11da-4b74-9fa5-31b8ce43e652)

4. Click **Export** on the left side to download the OSM file. A file named `map.osm` will be saved in your **Downloads** folder.

5. Move the `map.osm` file into the directory you created earlier:
   ```bash
   mv ~/Downloads/map.osm ~/AV-Map-Creation-Workflow/map_files
   ```

### Step 3: Generate OBJ Files and PCD Files

This step converts your `.osm` file into:
- A **Point Cloud Data (PCD)** file  
- A **3D Model**, consisting of `.obj`, `.mtl`, and `.png` texture files

1. Navigate to your project workspace:
   ```bash
   cd ~/AV-Map-Creation-Workflow
   ```

2. Create an empty `.pcd` file. This prevents the Docker container from mistaking the path for a folder:
   ```bash
   touch ~/AV-Map-Creation-Workflow/map_files/pointcloud_map.pcd
   ```

3. Pull the automated Docker container:
   ```bash
   docker pull zubxxr/osm-3d-pcd-pipeline:latest
   ```

4. Run the Docker container to generate the files:
   ```bash
   docker run --rm -it -e QT_QPA_PLATFORM=offscreen \
   -v $(pwd)/map_files/map.osm:/app/map.osm \
   -v $(pwd)/map_files/3D_Model:/app/3D_Model \
   -v $(pwd)/map_files/pointcloud_map.pcd:/app/pointcloud_map.pcd \
   zubxxr/osm-3d-pcd-pipeline /bin/bash
   ```

5. Verify that the output files were generated correctly:
   ```bash
   ls ~/AV-Map-Creation-Workflow/map_files
   ls ~/AV-Map-Creation-Workflow/map_files/3D_Model
   ```
   ![image](https://github.com/user-attachments/assets/7c60231d-5045-49b1-abac-2b90151af23a)

6. Fix file and folder permissions (so you can open/edit them normally):
   ```bash
   sudo chown -R $USER:$USER ~/AV-Map-Creation-Workflow/map_files/3D_Model
   ```

### Step 4: Create Lanelet2 Map

[Demonstration](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)

#### Tools Required
- [Vector Map Builder (VMB)](https://tools.tier4.jp/vector_map_builder_ll2/)

This tool is used to draw lanes, parking lots, and traffic markings on top of your point cloud.

1. Import the `.pcd` file into **Vector Map Builder**:
   - Go to **File > Import PCD > Browse**, select the point cloud from Step 3, and click **Import**.
   - You should now see the point cloud in the editor.
   ![image](https://github.com/user-attachments/assets/3cf18bc9-0763-4ae2-8310-2b37a0e09c35)

2. Go to **Create > Create Lanelet2Maps > Change Map Projector Info**, and set the projector type to **MGRS**.
   ![image](https://github.com/user-attachments/assets/729e6e9a-9230-4633-8315-48a485ce6f42)
   ![image](https://github.com/user-attachments/assets/3117a53d-9659-477b-b605-fef19873988c)

3. To set the correct location, you’ll need the **Grid Zone** and **100,000-meter square** values.

4. Open your `map.osm` file and look for any line containing `lat` and `lon` attributes.
   ![image](https://github.com/user-attachments/assets/3bfd614d-9a49-4a18-8315-46cc567f6ba6)

5. Copy any pair of `lat` and `lon` values and paste them into [this MGRS converter](https://legallandconverter.com/p50.html).

6. The values will look something like this:
   - **Grid Zone**: `17T`
   - **100,000-meter square**: `PJ`
     
   ![image](https://github.com/user-attachments/assets/1b0d9bfb-8625-4a34-be4d-1095b2fdad51)
   ![image](https://github.com/user-attachments/assets/af45ab5c-ff87-42d4-ab17-ce8668410440)

7. Enter those values into Vector Map Builder, click **Update Map Projector Info**, and confirm the popup.
   ![image](https://github.com/user-attachments/assets/d78f7a3c-3d72-494e-8f95-dbeb9dc565a0)

8. Begin creating lanelets and any additional map elements such as:
   - Lanes
   - Parking spaces
   - Stop lines

   Resources to help:
   - [Demonstration Video](https://drive.google.com/file/d/1GsgT-V2fWnFuPw8rWdohsYPsOSAnr716/view?usp=drive_link)
   - [Official Manual](https://docs.web.auto/en/user-manuals/vector-map-builder/how-to-use)
   - YouTube tutorials

#### Example map
![image](https://github.com/user-attachments/assets/a9c2e77c-0f3f-47fd-8a03-29f0ed805781)


> Make sure the lanelet2 map is good by exporting it, reimporting it into VMB again, and making sure all the lanelets are correct and not broken. This can happen due to a bug.
> Next, load the map into Autoware PSIM and make sure all areas of the map are routable. 

9. Export the Lanelet2 map:
   - Go to **File > Export Lanelet2Maps**
   - Press **OK** on the popup
   - Click **Download**

10. Move the exported `.osm` file into your project directory:
   ```bash
   mv ~/Downloads/new_lanelet2_maps.osm ~/AV-Map-Creation-Workflow/map_files/
   ```

### Step 5: Nullify Latitude/Longitude
- Use the included Python script to avoid infinite map stretching in Autoware:
```bash
cd ~/AV-Map-Creation-Workflow
python3 remove_lat_lon.py map_files/new_lanelet2_maps.osm map_files/lanelet2_map.osm
```

### Step 6: Import Files to Autoware

[Demonstration](https://drive.google.com/file/d/1JRt64q4x_NL__mK30LJ7Vgzp1ZBU6C9e/view?usp=drive_link)

#### Tools Required
- [Autoware](https://www.autoware.org/)

After completing the previous steps, your `map_files/` directory should contain the following:

- **Point Cloud Map**: `pointcloud_map.pcd`  
- **3D Model Assets**:
  - `map.obj`  
  - `map.mtl`  
  - `textures/` folder containing `.png` images  
- **Lanelet2 Vector Map**: `lanelet2_map.osm`

These files are now ready to be used with Autoware for simulation or real-world integration.

#### Example: Lanelet2 Map and Point Cloud Imported into Autoware
![Importing Files into Autoware](https://github.com/user-attachments/assets/760fefa1-7668-4c97-9531-42e42b6a50a9)


### Step 7: Import to AWSIM
- Import `.obj`, `.mtl`, and `.png` files into Unity scene by dragging them in from the system file manager into the Assets window
![image](https://github.com/user-attachments/assets/a0dcbb49-7f8d-4c2b-a5b3-bfdb1f031c3a)
- Drag the obj file into the scene and enable read/write permissions on the file
![image](https://github.com/user-attachments/assets/46f84474-9e31-475b-bb61-bb28106550cf)


- Load and align the Lanelet2 file to synchronize with Autoware. [Instructions](https://autowarefoundation.github.io/AWSIM-Labs/main/Components/Environment/LaneletBoundsVisualizer/)

#### Example: Lanelet2 Map and 3D Model Imported into AWSIM
![image](https://github.com/user-attachments/assets/d19eff33-39b4-48cd-9992-01c18400a827)
> Parking lot and vehicles were added in manually.
---

## Workflow Success Demonstration

### Initialization in AWSIM and Autoware
![image](https://github.com/user-attachments/assets/0b7c5f4f-debe-4848-be7e-f8919a99c18b)

### Planning and Navigation
![image](https://github.com/user-attachments/assets/f9b89e0c-2359-4f17-b0ff-eda4dd4d2653)

### Arrival at Parking Spot
![image](https://github.com/user-attachments/assets/f3e45604-2fe0-4f5b-9f1a-c98c1c2fa583)

---

## Localization Instability

In the case of localization instability, the map may need additional features to help localize. This can be done using a 3D mesh editing tool, such as Blender in this case. 

The 3D mesh was loaded in to Blender after the workflow was used and trimmed to remove the unwanted features.

### Raw 3D Mesh
![image](https://github.com/user-attachments/assets/b3e3d646-94dc-447d-96ed-515ec8e7edb4)

### Trimmed 3D Mesh
![image](https://github.com/user-attachments/assets/9616b971-af04-4461-8eb4-871f16bb9b03)

Next, planar, wall-like structures were then added around the perimeter of the map to provide additional geometry for LiDAR scan matching.

### Added Perimeter Walls to Enhance LiDAR Scan Matching
<img width="1600" height="766" alt="image" src="https://github.com/user-attachments/assets/1e7680d8-c793-4f7a-93c5-c977cf50ab84" />

The 3D mesh can then be exported again, and re-imported into the workflow to generate the PCD file required by Autoware. This simple yet effective adjustment significantly improved localization performance in previously sparse regions of the map.


## Limitations

- **Large OSM maps are not supported:**  
  This workflow was designed and tested with relatively small OpenStreetMap (OSM) files. It does not currently scale well to large maps due to memory and processing constraints in the conversion and map-building stages. Attempting to process large `.osm` files may result in performance degradation or failure.

> 📌 _Limitation identified in July 2025._


## Troubleshooting

Feel free to open an **Issue** if there are any problems.

### Entering the Container
To manually enter the container for debugging:
```bash
xhost +
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd)/map_files/map.osm:/app/map.osm --entrypoint bash -it zubxxr/osm-3d-pcd-pipeline
```
---

## Related Publication and References

This repository is based on the paper:
- **Zubair Islam**, Ahmaad Ansari, George Daoud, Mohamed El-Darieby  
  *"A Workflow for Map Creation in Autonomous Vehicle Simulations"*, GEOProcessing 2025  
  [Read Paper](https://www.thinkmind.org/library/GEOProcessing/GEOProcessing_2025/geoprocessing_2025_2_40_30041.html)

Cited Tools & Techniques:
- OSM2World
- CloudCompare
- Point Cloud Library (PCL)
- Vector Map Builder
- Autoware Universe (2024.11)
- AWSIM Labs
---




