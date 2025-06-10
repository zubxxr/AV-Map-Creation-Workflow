# AV Map Creation Workflow for Autonomous Vehicle Simulations

![Best Paper Award - GEOProcessing 2025](https://img.shields.io/badge/Best%20Paper-GEOProcessing%202025-brightgreen?style=flat-square)

## 🏆 Publication and Recognition

This repository supports the paper:
> **Zubair Islam**, Ahmaad Ansari, George Daoud, Mohamed El-Darieby  
> *A Workflow for Streamlining 3D Map Creation for Autonomous Vehicle Testing*  
> **GEOProcessing 2025** — Awarded **Best Paper**  
> [Read the full paper](https://www.thinkmind.org/library/GEOProcessing/GEOProcessing_2025/geoprocessing_2025_2_40_30041.html)

---

## 🛠️ Overview

This repository outlines a fully offline, simulator-agnostic workflow to create high-definition (HD) maps for Autonomous Vehicle (AV) simulation testing. It enables the generation of:

- **3D Mesh Models**
- **Point Cloud Data (PCD)**
- **Lanelet2 Maps**

These outputs are compatible with **Autoware** and **AWSIM**, facilitating both virtual AV testing and future real-world deployment. The workflow was designed to address the lack of easily reproducible, parking-lot-sized maps for AVP (Autonomous Valet Parking) research.

## 📆 Motivation

At the time of this project's development, AWSIM and Autoware only included a single city-scale map, which lacked critical low-speed elements like parking lots. Moreover, existing documentation for map creation was often outdated or platform-dependent (e.g., CARLA, LGSVL).

To address this:
- We created a **custom parking lot map** of Ontario Tech University's SIRC campus.
- Designed a **lightweight workflow** that avoids heavy simulation dependencies like CARLA.
- Used **open-source, low-resource tools** to make the pipeline accessible.

## 🛠️ Architecture

### Full Workflow Diagram
![image](https://github.com/user-attachments/assets/975b8182-9a63-4b15-b198-fe80a1c99708)

### Automated Mapping via Docker
![image](https://github.com/user-attachments/assets/eff78a19-81f3-4990-9137-efca93cb049d)

---

## 📅 Table of Contents
1. [Getting Started](#getting-started)
2. [Detailed Workflow Steps](#detailed-workflow-steps)
3. [Workflow Success Demonstration](#workflow-success-demonstration)
4. [Related Publication and References](#related-publication-and-references)

---

## 🚀 Getting Started

Clone the repository and set up the project structure:
```bash
cd ~/
git clone https://github.com/zubxxr/AV-Map-Creation-Workflow
cd AV-Map-Creation-Workflow
mkdir map_files
cd map_files
```

---

## 🔁 Detailed Workflow Steps

Each step is supported with visuals and references to the paper and demo videos.

### Step 1: Download OSM File
- Use [OpenStreetMap](https://www.openstreetmap.org/) to export your desired location.
- Save as `map.osm` and move to your `map_files` directory.

### Step 2: Generate 3D Mesh and Point Cloud (PCD)
- Run the **Docker Container** that combines:
  - `OSM2World` for 3D Mesh
  - `CloudCompare` for PCD
  - `PCL` for orientation and formatting
```bash
docker pull zubxxr/osm-3d-pcd-pipeline:latest
docker run ...  # See full command in README
```

> ⚠️ PCD orientation is transformed to top-down using `pcl_transform_point_cloud`, and converted to binary format using `pcl_convert_pcd_ascii_binary`.

### Step 3: Create Lanelet2 Map
- Use Tier IV's [Vector Map Builder](https://tools.tier4.jp/vector_map_builder_ll2/) with your PCD file
- Draw lanes and parking spots manually (example shown in the paper, Fig. 7)

### Step 4: Nullify Latitude/Longitude
- Use the included Python script to avoid infinite map stretching in Autoware:
```bash
python3 remove_lat_lon.py new_lanelet2_maps.osm lanelet2_map.osm
```

### Step 5: Import to Autoware
Files required:
- `pointcloud_map.pcd`
- `lanelet2_map.osm`

```bash
ros2 launch autoware_launch ... map_path:=... 
```

> AV localizes and plans path inside Autoware using NDT and global planner.

### Step 6: Import to AWSIM
- Import `.obj`, `.mtl`, and `.png` files into Unity scene
- Enable Mesh Colliders and Read/Write in inspector
- Load and align the Lanelet2 file to synchronize with Autoware

---

## 🚩 Workflow Success Demonstration

### Initialization in AWSIM and Autoware
![image](https://github.com/user-attachments/assets/0b7c5f4f-debe-4848-be7e-f8919a99c18b)

### Planning and Navigation
![image](https://github.com/user-attachments/assets/f9b89e0c-2359-4f17-b0ff-eda4dd4d2653)

### Arrival at Parking Spot
![image](https://github.com/user-attachments/assets/f3e45604-2fe0-4f5b-9f1a-c98c1c2fa583)

---

## 🔗 Related Publication and References

This repository is based on the paper:
- **Zubair Islam**, Ahmaad Ansari, George Daoud, Mohamed El-Darieby  
  *"A Workflow for Streamlining 3D Map Creation for Autonomous Vehicle Testing"*, GEOProcessing 2025  
  [Read Paper](https://www.thinkmind.org/library/GEOProcessing/GEOProcessing_2025/geoprocessing_2025_2_40_30041.html)

Cited Tools & Techniques:
- OSM2World
- CloudCompare
- Point Cloud Library (PCL)
- Vector Map Builder
- Autoware Universe (2024.09)
- AWSIM

---

## 🛠️ Troubleshooting

To manually enter the container for debugging:
```bash
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $(pwd)/map_files/map.osm:/app/map.osm --entrypoint bash -it osm-3d-pcd-pipeline
```
