# RFM Customer Segmentation with K-Means

This project uses the K-means clustering algorithm to perform RFM (Recency, Frequency, Monetary) analysis. The main objective is to segment customers into different groups based on their buying behavior, which can be used to tailor marketing strategies for each group.


## Source Data

The dataset is sample superstore dataset on [Kaggle](https://www.kaggle.com/datasets/bravehart101/sample-supermarket-dataset). 

## Data Preprocessing

1.    Identify any missing or duplicate values (none for this project). 
2.    Convert order_date and ship_date columns to datetime type.

## Workflow

1.	Convert negative and zero values to 1 so that they won’t cause infinite numbers during the log transformation. 
2.	Perform log transformation to bring data into a normal or near-normal distribution. This step can improve the performance of the clustering algorithm.
3.	 Standardize the transformed data using StandardScaler function to ensure that all features are on the same scale.
4.	 Use Elbow method to determine the optimal number of clusters for the K-means algorithm. 

  ![alt text](https://github.com/QiujiaGuo/RFM-Analysis-for-Customer-Segmentation/blob/main/Elbow%20Method.png)

5. Perform K-means clustering with the number of clusters set to 3, based on the optimal number of clusters determined in step 4.
6.	  Assign customer segments to one of three levels: "whales" for high-value customers, "lapsed" for low-value customers, and "promising" for medium-value customers.

## Results

The "whales" cluster includes customers who order frequently and bring in a large amount of revenue. This cluster represents 35.44% of the total customer base in the dataset.

![alt text](https://github.com/QiujiaGuo/RFM-Analysis-for-Customer-Segmentation/blob/main/percentage%20for%20each%20cluster.png)

The "promising" cluster  includes customers who order occasionally but still generate a decent amount of monetary sales. It represents 40.86% of the total customer base in the dataset.

The "lapsed" cluster includes customers who have either made a purchase a long time ago or have made a purchase with a minimal amount. It represents 23.71% of the total customer base in the dataset.

## Business Recommendation

1.	Retain "Whales": offer exclusive discounts, loyalty programs, or personalized customer service to keep them engaged and loyal.
2.	Target "Lapsed" Customers: offer special promotions, incentives, or discounts to bring them back. 
3.	Nurture "Promising" Customers: offer personalized product recommendations or discounts to encourage them to increase their purchase frequency and become loyal customers.

## Limitations

Subjectivity in Choosing Optimal Number of Clusters: While the elbow method provides a way to estimate the optimal number of clusters, the choice of the number of clusters can be subjective. The optimal number of clusters may vary depending on the dataset, and there may not be a clear elbow point on the graph.

## Future Improvements

Alternative Clustering Methods: Alternative clustering methods such as hierarchical clustering, density-based clustering, and model-based clustering can be used instead of k-means clustering to overcome some of its limitations.
