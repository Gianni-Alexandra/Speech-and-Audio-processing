## Overview
This project implements a music genre recognition system using:
- Mel-Frequency Cepstral Coefficients (MFCCs) for feature extraction.
- Gaussian Mixture Models (GMMs) trained with the Expectation-Maximization (EM) algorithm for classification.

The system classifies audio files into one of three genres:
- 🎸 Blues
- 🎻 Classical
- 🎧 Reggae

## Methodology
- Dataset: 300 .wav files (100 per genre), split into training and testing folders.
- Feature Extraction: 13 MFCCs per frame (20ms window, 5ms step) using librosa.
- Model Training: GMMs are trained per genre using a custom EM implementation with K-Means initialization.
- Classification: Based on *Maximum Log-Likelihood* using trained GMMs.
- Evaluation: Classification accuracy and confusion matrix.

## Results
- Accuracy was tested for different numbers of Gaussian components (K = 4, 8, 16)
- Best performance: **K = 4**, with **91.67% accuracy**
- Increasing K resulted in reduced accuracy due to overfitting



