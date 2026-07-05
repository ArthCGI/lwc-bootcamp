public with sharing class PortfolioController {
    @AuraEnabled(cacheable=true)
    public static Account getPortfolioAccount(Id accountId) {
        if (accountId == null) {
            return null;
        }
        return [
            SELECT Id, Name, Site, Description, Industry, Type,
                   NumberOfEmployees, Phone, Website,
                   BillingCity, BillingCountry
            FROM Account
            WHERE Id = :accountId
            WITH USER_MODE
            LIMIT 1
        ];
    }
}
