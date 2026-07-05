public with sharing class PortfolioPageController {

    public Account account { get; private set; }

    public PortfolioPageController() {
        String accountId = ApexPages.currentPage().getParameters().get('id');
        if (String.isNotBlank(accountId)) {
            try {
                account = [
                    SELECT Name, Site, Description, Industry, Type,
                           NumberOfEmployees, Phone, Website,
                           BillingCity, BillingCountry
                    FROM Account
                    WHERE Id = :accountId
                    WITH USER_MODE
                    LIMIT 1
                ];
            } catch (QueryException e) {
                ApexPages.addMessage(
                    new ApexPages.Message(ApexPages.Severity.ERROR, 'Account not found.')
                );
            }
        }
    }

    public Boolean getHasAccount() {
        return account != null;
    }

    public String getInitials() {
        if (account == null || String.isBlank(account.Name)) return '??';
        List<String> parts = account.Name.trim().split('\\s+');
        if (parts.size() >= 2) {
            return (parts[0].substring(0, 1) + parts[parts.size() - 1].substring(0, 1)).toUpperCase();
        }
        return account.Name.substring(0, Math.min(2, account.Name.length())).toUpperCase();
    }

    public Boolean getHasLocation() {
        return account != null &&
               (String.isNotBlank(account.BillingCity) || String.isNotBlank(account.BillingCountry));
    }

    public String getLocation() {
        if (account == null) return '';
        List<String> parts = new List<String>();
        if (String.isNotBlank(account.BillingCity))    parts.add(account.BillingCity);
        if (String.isNotBlank(account.BillingCountry)) parts.add(account.BillingCountry);
        return String.join(parts, ', ');
    }

    public Boolean getHasExperience() {
        return account != null && account.NumberOfEmployees != null;
    }

    public String getExperience() {
        if (account == null || account.NumberOfEmployees == null) return '';
        return account.NumberOfEmployees + '+ Years';
    }

    public Boolean getHasContact() {
        return account != null &&
               (String.isNotBlank(account.Phone) || String.isNotBlank(account.Website));
    }
}
