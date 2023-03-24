-- Shark Tank Success: Analyzing the Outcomes of Deals and No Deals in Seasons 1-6


/*
	CONTEXT:
Shark Tank is a popular reality TV show where entrepreneurs pitch their business ideas to a panel of potential investors, or "sharks," in the hopes of securing funding and support to take their businesses to the next level. The show has been running since 2009.

Each episode features several pitches from entrepreneurs, who have just a few minutes to make their case to the sharks. The sharks then ask questions, offer feedback, and decide whether or not to make an investment in the business. If a shark does decide to invest, they negotiate the terms of the deal with the entrepreneur and become a partner in the business.

Over the years, Shark Tank has featured many successful businesses that have gone on to become household names, as well as some memorable failures. The show is known for its high-stakes drama, tough negotiations, and larger-than-life personalities, making it a favorite among viewers who are interested in entrepreneurship, investing, and business strategy.

	DATASET:
 First I have to acknowledge that this is small dataset of 491 values. In addition, the dataset only includes information on the first six seasons of Shark Tank, which may not be representative of more recent seasons. Therefore a lot of conclusions and percentages may be not a correct representation of reality.
 Nevertheless my findings can give a direction to other analyst that have a bigger dataset on this topic. 
 Data gathered from Kaggle - https://www.kaggle.com/datasets/ulrikthygepedersen/shark-tank-companies?resource=download

	PERSONAL INTEREST:
As a business economics graduate and entrepreneur, I am always on the lookout for innovative business ideas that can lead to success, as it is always inspiring to see. While having a great business idea is crucial, it's not the only factor that contributes to success. Access to funding is also important, and one way to get it is through Shark Tank. Having a well-known figure associated with your business can give it a significant boost, especially if that person has a track record of helping other businesses succeed.

If you manage to secure a deal on Shark Tank, it can result in a huge payout, sometimes making you a millionaire after a pitch that is just a few minutes long. This piqued my curiosity about whether it's possible to predict in advance whether a company will succeed on the show or not.
*/

-- ANALYSIS

-- ***** PAGE 1  *****

-- First I am interested whether businesses with higher valuation get more deals or not. Average valuation of all businesses equals to 2.17 million. 

SELECT deal, COUNT(*)

FROM shark_tank_companies
WHERE valuation < (SELECT AVG(valuation) FROM shark_tank_companies)

GROUP BY deal

-- Here there are 10% more businesses that get a deal rather than not

SELECT deal, COUNT(*)

FROM shark_tank_companies
WHERE valuation > (SELECT AVG(valuation) FROM shark_tank_companies)

GROUP BY deal

-- Here there are 27% more businesses that get no deal rather than a deal
-- But as we can see there are 3 times more companies with a valuation lower than the average. Therefore there must be a few companies with extreme high valuations. 

SELECT deal, COUNT(*), round(avg(valuation)), CASE 
	WHEN valuation < 1000000 THEN '3. Low valuation'
	WHEN valuation BETWEEN 1000000 AND 10000000 THEN '2. Middle valuation'
	ELSE '1. High valuation'
	END AS vl

FROM shark_tank_companies

GROUP BY deal, vl
ORDER BY vl

-- From here it is visible that there are as many companies with a valuation below 1 million as there are companies with a valuation between 1 and 10 million.
-- There are only 17 companies with a higher valuation. Companies with a valuation above 10 million get twice as many no deal rather than a deal.


-- ***** PAGE 2 *****

-- Next I am interested whether the amount of entrepeneurs in combination with what they offer has an influence:

SELECT deal, COUNT(*), avg(valuation), avg (askedfor), avg(exchangeforstake), multiple_entreprenuers

FROM shark_tank_companies

GROUP BY deal, multiple_entreprenuers


/*

Here it is visible that multiple entrepeneurs ask for more money and have higher valuation companies than solo entrepeneurs.
It is noticable that on all bar charts the companies that get a deal have lower averages than the companies that get no deal.
This suggest that offering a bigger stake of your company does not increase your chance of getting a deal, but asking for less money and having a lower valuation does.
Biggest difference that is visible is the stake amount that multiple entrepeneurs offer. The entrepeneurs who get a deal are offering a smaller stake of their company, 14.8% comapred to 18.9% for companies that did not get a deal.
It also shows that multiple entrepeneurs get 17% more deals than no deals, 87 compared to 74.
For solo entrepeneurs the division between deal or no deal is almost 50/50, for multiple entrepeneurs the division is 54% deals and 46% no deals.

If we exclude companies with a valuation above 10m (17 companies), we can see that comapnies with mulitple entrepeneurs who get a deal actually have a higher valuation and ask for more money than companies that get no deal. Average valuation is 25% higher and average asked for is 30% higher.
The conclusions on stake amount offered stay the same.
The conclusions for small entrepeneurs stay the same, probably because solo entrepeuners have smaller companies and therefore the averages stay the same with this filter.
I will not make conlcusions for companies with value that is above 10m because of the small sample set.

*/

-- ***** PAGE 3 *****

-- Next I wanted to see whether the state that the entrepeneurs are from has an influence on the outcome:

SELECT deal, trim(substr(location, -2)) AS state, COUNT(*)

FROM shark_tank_companies

GROUP BY deal, state

-- And the same for categories

SELECT deal, category, COUNT(*)

FROM shark_tank_companies

GROUP BY deal, category

-- We can see that most entrepeneurs are from California. This can be explained by the fact that Shark Tank is filmed in California and the fact that there are a lot of (tech) start ups in the state of California.
-- For categories it is noticable that 24% of all companies fall into "Specialty Food", "Novelties" or "Baby and Child Care" categories.
-- Since the sample size for different distinct metrics is not big enough I will not make conclusion based on these metrics.


-- ***** PAGE 4 *****


-- Next we can check whether the percentage of ownership that the entrepeneurs offer has an influence on the outcome:

SELECT deal, avg(exchangeforstake)

FROM shark_tank_companies

GROUP BY deal

-- We can see that 'no deal' outcomes on average are willing to give 1.7% more of their company. Lets see if we can break it down into smaller groups:

SELECT deal, COUNT(*), CASE 
	WHEN exchangeforstake < 10 THEN '0-10'
	WHEN exchangeforstake BETWEEN 10 and 25 THEN '10-25'
	WHEN exchangeforstake BETWEEN 26 and 50 THEN '26-50'
	WHEN exchangeforstake BETWEEN 51 and 75 THEN '51-75'
	ELSE '76-100'
	END AS Stake

FROM shark_tank_companies

GROUP BY deal, Stake

-- Now we can reevaluate and make new groups to get more insight.
-- From here we can see that most entrepeneurs offer between 10% and 25% of their company. There has been only 1 company who offered more than 75% of their company and got no deal. 
-- The companies that offered 51% or more of their company got 3 deals and 3 no deals, therefore I can add them to the 26-50 group without excluding them or influencing the conclusions too much.
-- I will separate other groups into smaller ones.	


SELECT deal, COUNT(*), CASE 
	WHEN exchangeforstake < 6 THEN '0. 0-6'
	WHEN exchangeforstake BETWEEN 6 and 15 THEN '1. 6-15'
	WHEN exchangeforstake BETWEEN 16 and 26 THEN '2. 16-26'
	ELSE '3. 27-100'
	END AS Stake

FROM shark_tank_companies

GROUP BY deal, Stake

/*

Most entrepeneurs offer between 6 and 15 percent of their company (43% of the total), followed by 16-26 percent group (35% of the total).
Here it is noticable that companies that offer between 0 and 16 procent get 24% more deal than no deal, and the companies who offer more than 16 percent get 20% more no deal than deal.


*/


-- ***** PAGE 5 *****

--Next we can look for differences in outcomes based on the sharks that are present.

SELECT deal, COUNT(*), shark1, shark2, shark3, shark4, shark5

FROM shark_tank_companies

GROUP BY deal, shark1, shark2, shark3, shark4, shark5
HAVING COUNT(*) > 6

-- To exclude the times when there was a guest shark that is not present a lot, HAVING clause has been added. This output includes 471 out of 495 rows.
-- We can see that there are 4 combinations of sharks that are present most of the time at the show: 

/*
1. Barbara Corcoran	Robert Herjavec		Kevin O'Leary	Daymond John	Kevin Harrington
2. Barbara Corcoran	Robert Herjavec		Kevin O'Leary	Daymond John	Mark Cuban
3. Lori Greiner		Barbara Corcoran	Robert Herjavec	Kevin O'Leary	Mark Cuban
4. Lori Greiner		Robert Herjavec		Kevin O'Leary	Daymond John	Mark Cuban

*/

/* From here we can conlcude that:
 Combination 1 has 22% more no deal than deal. 
 Combination 2 has 10% more no deal than deal. 
 Combination 3 has 26% more deal than no deal. 
 Combination 4 has 4% more deal than no deal. 
 */


-- ***** PAGE 6 *****
 
-- Next we can check for differences in each season:

SELECT deal, season, COUNT(*)

FROM shark_tank_companies

GROUP BY deal, season

-- Because of the popularity of the show seasons 4 to 6 have more episodes than the first 3 seasons, and therefore more outcomes.
-- The biggest differences here are in:
/* 
Season 1: with 37% more no deal than deal
Season 6: with 19% more deal than no deal
Other seasons have a difference that is below 15%
*/	



/* 
CONCLUSION:

From this analysis, I found that companies with a lower valuation were more likely to get a deal on the show. Specifically, 10% more businesses with a valuation less than the average of $2.17 million got a deal, while 27% more businesses with a valuation greater than the average did not get a deal. This is likely because the Sharks are looking for a good deal and will only invest if they see a potential for a high return on their investment. Companies with a lower valuation may be perceived as less risky, making them more attractive to investors.

I also looked at the influence of the number of entrepreneurs involved in the pitch. The data showed that companies with multiple entrepreneurs ask for more money and have higher valuation companies than solo entrepreneurs. However, it's interesting to note that offering a bigger stake of the company does not seem to increase the chances of getting a deal. In fact, the data suggests that asking for less money and having a lower valuation can increase the chances of getting a deal. Furthermore, I found that multiple entrepreneurs are more likely to get a deal, with 87 companies out of 161 getting a deal, compared to solo entrepreneurs where the division between deal or no deal is almost 50/50.

When I exclude companies with a valuation above $10 million, I see that companies with multiple entrepreneurs who get a deal have a higher valuation and ask for more money than companies that get no deal. The average valuation is 25% higher, and the average amount asked for is 30% higher. However, the conclusions on stake amount offered stay the same, suggesting that offering a smaller stake of the company is still an effective strategy to secure a deal.

Overall, these findings suggest that sharks on Shark Tank are more attracted to companies with a lower valuation and entrepreneurs who ask for less money. Multiple entrepreneurs seem to have an advantage over solo entrepreneurs, but offering a smaller stake of the company seems to be effective in both cases. However, it's important to note that these conclusions are based on a small dataset of only 491 values and may not be fully representative of the entire Shark Tank experience.


*/

