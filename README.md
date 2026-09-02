🚀 **End-to-End Machine Learning Project: Daily Customer Forecasting**

I recently worked on a **sales dataset with the objective of improving the forecasting of daily customer demand**.

🔹 **1. Data Cleaning**

Before building any machine learning model, I cleaned and prepared the data using **Pandas**, making sure the dataset was suitable for analysis and modeling.

🔹 **2. Exploratory Data Analysis (EDA)**

I then merged the relevant datasets to perform a deeper analysis of the business performance.

📊 **EDA Summary**

• Total Revenue: **$114,964.94**
• Total Cost: **$69,101.77**
• Total Profit: **$45,863.48**

🌍 **Profit Contribution by Country**

• Australia: **29.6%**
• Canada: **23.9%**
• UK: **20.2%**
• USA: **13.7%**
• Germany: **10.0%**
• France: **2.6%**

🔹 **3. Feature Engineering**

Since this was a time-series forecasting problem, I created several temporal and lag features:

• Year
• Month
• Day
• Day of the Week
• Lag 1
• Lag 2
• Lag 14
• Lag 28

After creating the lag features, I used `dropna()` to remove the rows where lag values were unavailable.

🔹 **4. Model Training**

I used **XGBRegressor** to forecast daily customers.

To improve the model, I also used **RandomizedSearchCV** to search for better hyperparameters.

🔹 **5. Model Evaluation**

📈 **Training Performance**

• RMSE: **1.72**
• MAE: **1.36**

📊 **Test Performance**

• RMSE: **2.25**
• MAE: **1.84**

The test error was slightly higher than the training error, which is expected. However, the difference was relatively small, suggesting that the model was able to **generalize reasonably well to unseen data**.

🎯 **Key Takeaway**

This project helped me practice the complete machine learning workflow:

**Data Cleaning → EDA → Feature Engineering → Time-Series Features → Hyperparameter Tuning → Model Training → Evaluation**

The model is now ready for the next step: **deployment and monitoring**.

I'm always looking to improve my projects and ML skills.

💬 **What would you improve in this project? I'd appreciate your feedback!**

#DataScience #MachineLearning #Python #XGBoost #TimeSeries #Forecasting #DataAnalytics #Pandas #MachineLearningProject
