# Diabetics-Prediction-App-for-Women
# Diabetes Prediction App

## Overview
The Diabetes Prediction App is a machine learning application that predicts diabetes outcomes based on patient health indicators. Built using R, the project employs multiple machine learning models to provide insights into diabetes prediction, making it a valuable tool for healthcare applications. The dataset used for this project is sourced from Kaggle, originally provided by the National Institute of Diabetes and Digestive and Kidney Diseases.

**App Link**: [Diabetes Prediction App](https://kiranchakkapally.shinyapps.io/diabetes_prediction_app/)

## Features
- **Data Preprocessing**:
  - Handled missing values by imputing with median values.
  - Normalized continuous features using Min-Max Scaling.
- **Exploratory Data Analysis**:
  - Distribution analysis of variables using histograms and scatter plots.
  - Correlation analysis using a heatmap to understand feature relationships.
- **Machine Learning Models**:
  - Logistic Regression
  - K-Nearest Neighbors (KNN)
  - Decision Trees
  - Naïve Bayes
  - Support Vector Machines (SVM)
- **Model Evaluation**:
  - Metrics such as Accuracy, AUC, Sensitivity, and Specificity.
  - ROC curve analysis to assess model performance.

## Dataset
The dataset comprises 768 observations with the following features:
- `Pregnancies`: Number of pregnancies.
- `Glucose`: Plasma glucose concentration.
- `BloodPressure`: Diastolic blood pressure (mm Hg).
- `SkinThickness`: Triceps skin fold thickness (mm).
- `Insulin`: 2-Hour serum insulin (mu U/ml).
- `BMI`: Body mass index (weight in kg/(height in m)^2).
- `DiabetesPedigreeFunction`: Diabetes pedigree function.
- `Age`: Age (years).
- `Outcome`: Diabetes outcome (0 = No Diabetes, 1 = Diabetes).

## Project Workflow
1. **Data Loading**:
   - Load the dataset into a DataFrame.
   - Examine structure and summary statistics.
2. **Data Cleaning**:
   - Replace zero values in `Glucose`, `BloodPressure`, `SkinThickness`, `Insulin`, and `BMI` with `NA`.
   - Impute missing values using the median.
3. **Exploratory Analysis**:
   - Visualize data distribution using `ggplot2`.
   - Analyze correlations between features using a heatmap.
4. **Feature Scaling**:
   - Apply Min-Max normalization to selected features.
5. **Model Training and Evaluation**:
   - Split data into training (80%) and testing (20%) sets.
   - Train multiple models using `caret`.
   - Evaluate models with metrics like Accuracy, AUC, Sensitivity, and Specificity.
6. **Visualization**:
   - Generate ROC curves to compare model performances.

## Results
| Model                | Accuracy | AUC   | Sensitivity | Specificity |
|----------------------|----------|-------|-------------|-------------|
| Logistic Regression  | 80.39%   | 0.89  | 0.6038      | 0.91        |
| K-Nearest Neighbors  | 67.97%   | 0.69  | 0.4151      | 0.82        |
| Decision Tree        | 73.86%   | 0.65  | 0.3585      | 0.94        |
| Naïve Bayes          | 79.08%   | 0.87  | 0.6981      | 0.84        |
| Support Vector Machine | 78.43% | 0.88  | 0.6226      | 0.87        |

The Logistic Regression model demonstrated the best performance with an AUC of 0.89, balancing sensitivity and specificity effectively.

