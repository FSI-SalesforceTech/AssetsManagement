/* @Contents 資産管理
 * @Author matsuzaki
 * @Since 2020/09/08
 * @LastUpdate 2020/09/08
 */
@isTest(SeeAllData=false)
public class TestInventory_Trg {
    @isTest static void Test_Inventory_Trg() {
        TestCreateDataUtil CreateDataUtil = new TestCreateDataUtil();

        //テスト開始
        Test.starttest();
        User adminUser = CreateDataUtil.createdUser('CreateAssetsRecordadmin','admin');

        System.runAs(adminUser){
            String recordNameAdmin = 'admin';
            List<Assets__c> AssetsList = CreateDataUtil.createAssetsRecord(recordNameAdmin);
        }

        User standardUser = CreateDataUtil.createdUser('TestInventory_Trg', '');
        CreateDataUtil.getPermissionSet(standardUser, 'AssetsManagementPermset');

        System.runAs (standardUser) {
            String recordNameStandard = 'Standard';
            List<InventoryResults__c> newInventoryResultList = CreateDataUtil.createInventoryRecord(recordNameStandard);
        }
        Test.stoptest();
    }

}
