### README for Layoffs Data Analysis and Cleanup Project

#### Problem Statement
The aim of this project is to analyze and clean a dataset containing information about company layoffs. The goals include identifying patterns, removing duplicates, ensuring data consistency, and deriving meaningful insights regarding the layoffs across various companies, industries, and countries.

#### Steps Taken to Find Insights
1. **Data Staging:**
   - Created staging tables to hold intermediate data.
   - Inserted data into staging tables for processing.

2. **Data Cleaning:**
   - Removed duplicates using Common Table Expressions (CTEs) and the `ROW_NUMBER()` function.
   - Trimmed whitespace from company and country names.
   - Standardized industry names, particularly for the crypto industry.
   - Converted date fields to the proper date format.
   - Replaced blank values with NULL for easier data manipulation.

3. **Data Transformation:**
   - Updated columns for consistency across related records (e.g., updating industry based on company name).
   - Removed records with null or blank values in key columns.
   - Dropped unnecessary columns post-cleaning and modified column data types to ensure proper storage formats.

4. **Exploratory Data Analysis (EDA):**
   - Calculated total layoffs by company, industry, country, and stage.
   - Analyzed layoffs by year and month.
   - Performed rolling total calculations for monthly layoffs.
   - Ranked companies by total layoffs per year to identify the top affected companies.

#### Conclusion
- **Amazon** (18,150 layoffs) and **Google** (12,000 layoffs) were the companies with the highest number of layoffs.
- The **consumer** (46,682 layoffs) and **retail** (43,613 layoffs) industries were the most affected sectors.
- The **United States** (256,474 layoffs) experienced the highest number of layoffs by a significant margin.
- **Post-IPO** companies (204,882 layoffs) faced substantial layoffs, indicating financial or operational challenges post-IPO.
- **2022** (161,711 layoffs) saw the highest number of layoffs, with a notable reduction in **2023** (127,277 layoffs).
- **January** (92,037 layoffs) had the highest number of layoffs, suggesting seasonal or fiscal year-end influences.

This project provides a comprehensive view of the layoffs landscape, offering valuable insights into the factors contributing to workforce reductions. The findings can help organizations and stakeholders understand the trends and challenges within different sectors and regions.
