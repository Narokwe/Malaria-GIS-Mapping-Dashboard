# Malaria Disease Surveillance Dashboard

## Project Overview

This project aims to build an interactive dashboard using **R** and **Shiny** to track and visualize malaria data. The dashboard allows users to filter and view malaria metrics by year and select the desired metric. It also features a choropleth map powered by **Leaflet** for visualizing malaria data based on geographic regions.

The data used in the app is sourced from **WHO**, **CDC**, and the **Kenya Ministry of Health** open data.

## Features

- **Year Filter**: Users can select a year to visualize malaria data for that specific year.
- **Metric Filter**: Users can choose the metric they want to view, such as malaria prevalence or cases.
- **Interactive Map**: A choropleth map that shows malaria data by country, with color coding to represent various values.
- **Responsive Design**: The app is responsive, adjusting to various screen sizes.

## Installation

To run this project locally, follow these steps:

### Prerequisites

Make sure you have the following installed:
- [R](https://cran.r-project.org/) (version 4.0 or later)
- [RStudio](https://posit.co/products/rstudio/)
- [R Packages](https://cran.r-project.org/web/packages/)
  - **shiny**
  - **ggplot2**
  - **dplyr**
  - **leaflet**
  - **sf**
  - **rmarkdown**

### Steps to Install and Run

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/your-username/your-repository-name.git
