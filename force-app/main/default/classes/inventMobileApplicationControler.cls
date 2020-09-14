public with sharing class inventMobileApplicationControler {
    @AuraEnabled(Cacheable=true)
    public static List<Assets__c> searchAssets(String BarcodeNumber) {
        if(BarcodeNumber != null) {
            Decimal decBarcodeNumber = Decimal.valueOf(BarcodeNumber);
            return [SELECT Id FROM Assets__c WHERE BarcodeNumber__c = :decBarcodeNumber LIMIT 1];
        } else {
            return null;
        }
    }

    @AuraEnabled(Cacheable=true)
    public static List<InventoryResults__c> searchInventoryResults(String BarcodeNumber) {
        if(BarcodeNumber != null) {
            Decimal decBarcodeNumber = Decimal.valueOf(BarcodeNumber);
            return [SELECT Id FROM InventoryResults__c WHERE BarcodeNumber__c = :decBarcodeNumber LIMIT 1];
        } else {
            return null;
        }
    }
}
