/* @Contents 資産管理
 * @Author matsuzaki
 * @Since 2020/09/07
 * @LastUpdate 2020/09/07
 */
public with sharing class InventoryTriggerHandler {

    public static boolean hasExecuted = false;
    private boolean m_isExrcuting = false;
    private integer BatchSize = 0;

    public InventoryTriggerHandler(boolean isExcuting, integer size) {
        m_isExrcuting = isExcuting;
        BatchSize = size;
    }

    public List<Inventory__c> OnAfterInsert(List<Inventory__c> newInventory){
        
        //棚卸対象の資産を全件取得
        List<Assets__c> AssetsList = [SELECT id , User__c FROM Assets__c WHERE InventoryTarget__c = true];
        List<InventoryResults__C> InvResultList = new List<InventoryResults__C>();
    
        //棚卸対象の資産件数分、棚卸結果を作成
        for(Integer i = 0 ; i < AssetsList.size() ; i++){
            InventoryResults__C IR = new InventoryResults__C(InventoryYear__c = newInventory[0].id,
                                                            Assets__c = AssetsList[i].id,
                                                            User__c = AssetsList[i].User__c);
            InvResultList.add(IR);
        }

        try{
            System.debug('Attempting to insert positions');
            insert InvResultList;
            System.debug('Insert complete');
        }catch(System.DmlException e){
            System.debug('DML exception:' + e.getDmlMessage(0));
        }
    
    return newInventory;
    }
}
