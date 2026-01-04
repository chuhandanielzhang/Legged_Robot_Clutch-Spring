# Legged_Robot_Clutch&Spring

Energy-recycling mechanism for legged locomotion using lockable clutch to improve walking efficiency.

## Overview

Foot-ground collisions in legged locomotion cause significant energy loss. While spring-like compliant mechanisms can reduce dissipation, their passive timing often mismatches the gait cycle, undermining both efficiency and stability. This work proposes an energy-recycling rimless wheel that uses a lockable clutch to store energy at foot contact and reinject it in the next gait cycle.

## Key Results

- **Energy reduction**: Up to 16.13% compared to viscoelastic-legged configuration
- **Stability**: Strong and consistent stability across a range of slope angles
- **Experimental validation**: Achieved Cost of Transport (CoT) of 0.02 on 1° slope

## Demo

Experimental demonstrations of the energy-recycling mechanism:

- **With Clutch**: [clutch/movie/movie.mp4](clutch/movie/movie.mp4) - Energy-recycling rimless wheel with lockable clutch mechanism
- **Without Clutch**: [no clutch/movie/movie.mp4](no%20clutch/movie/movie.mp4) - Baseline configuration without clutch
- **Energy Comparison**: [two models/movie/CompareEnergyAnimation.mp4](two%20models/movie/CompareEnergyAnimation.mp4) - Side-by-side energy comparison between the two models

The clutch mechanism successfully stores and reinjects energy, achieving a Cost of Transport (CoT) of 0.02 on a 1° slope.

## Research

**Status**: ICRA 2026, Under Review

**Authors**: Tongchen Lin, Yanqiu Zheng, Ruigang Chen, Chuhan Zhang, Yizhar Or, Mingyi Liu*

## Project Structure

- `clutch/` - Implementation with clutch mechanism
- `no clutch/` - Baseline implementation without clutch
- `two models/` - Comparison between models

## Contact

Email: chuhan.zhang@gtiit.edu.cn  
Website: [chuhandanielzhang.github.io](https://chuhandanielzhang.github.io)
