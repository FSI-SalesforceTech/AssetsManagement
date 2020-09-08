/* @Contents 資産管理
 * @Author matsuzaki
 * @Since 2020/09/07
 * @LastUpdate 2020/09/07
 */
trigger Inventory_Trg on Inventory__c (after insert) {

    if(InventoryTriggerHandler.hasExecuted){
        return;
    }

    InventoryTriggerHandler.hasExecuted = true;
    InventoryTriggerHandler handler = new InventoryTriggerHandler(Trigger.isExecuting,Trigger.size);

    if(Trigger.isInsert && Trigger.isAfter){
        handler.OnAfterInsert(Trigger.new);
    } 

}