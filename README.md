# CPSC-332 File Structure & Database Systems

## Final Project ##
Group Members: Kinsey Vo, Anthony Tran, Chence Shi, Serafina Yu

### Tables ###
1. Country (Base/Main Table)
      - Primary Key: Code
2. City
      - Primary Key: ID
3. CountryLanguage
      - Primary Key: CountryCode, Language
4. Firepower
      - Primary Key: CountryCode
5. Passwords
      - Primary Key: CountryCode, CountryRank
6. WorldHappiness
      - Primary Key: CountryName

### Relationships ###
*One-To-One*
    - Country and Passwords
    - Country and WorldHappiness
*One-To-Many*
    - Country and City
    - Country and CountryLanguage
    - Country and Firepower

Tables Accquired from https://www.kaggle.com/datasets
