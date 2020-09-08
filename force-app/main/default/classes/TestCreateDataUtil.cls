/* @Contents テストデータ作成共通クラス
 * @Author matsuzaki
 * @Since 2020/09/08
 * @LastUpdate 2020/09/08
 */
public with sharing class TestCreateDataUtil {

    /*
     *@資産のデータ作成
     */
    @TestVisible List<Assets__c> createAssetsRecord(String recordName){

            List<Integer> AssetManagementNumber = new List<Integer>();
            AssetManagementNumber.add(11111111);
            AssetManagementNumber.add(22222222);
            AssetManagementNumber.add(33333333);
            AssetManagementNumber.add(44444444);
            AssetManagementNumber.add(55555555);

            List<Integer> BarcodeNumber = new List<Integer>();
            BarcodeNumber.add(6666666);
            BarcodeNumber.add(7777777);
            BarcodeNumber.add(8888888);
            BarcodeNumber.add(9999999);
            BarcodeNumber.add(1222222);
            
            List<Boolean> InventoryTarget = new List<Boolean>();
            InventoryTarget.add(TRUE);
            InventoryTarget.add(TRUE);
            InventoryTarget.add(TRUE);
            InventoryTarget.add(FALSE);
            InventoryTarget.add(FALSE);

            List<Assets__c> AssetsList = new List<Assets__c>();

            for(Integer i = 0 ; i < AssetManagementNumber.size() ; i++){
                Assets__c Assets = new Assets__c(name = recordName + i,
                                                AssetManagementNumber__c = AssetManagementNumber.get(i),
                                                BarcodeNumber__c = BarcodeNumber.get(i),
                                                InventoryTarget__c = InventoryTarget.get(i));
                AssetsList.add(Assets);
            }

            try{
                System.debug('Attempting to insert positions');
                insert AssetsList;
                System.debug('Insert complete');
            }catch(System.DmlException e){
                System.debug('DML exception:' + e.getDmlMessage(0));
            }
        List<Assets__c> newAssetsList = [select Name, AssetManagementNumber__c, BarcodeNumber__c, InventoryTarget__c from Assets__c];
        return newAssetsList;
    }

    /*
     *@棚卸のデータ作成
     */
    @TestVisible List<InventoryResults__c> createInventoryRecord(String recordName){

        Inventory__c Inventory = new Inventory__c(Period__c = recordName);

        try{
            System.debug('Attempting to insert positions');
            insert Inventory;
            System.debug('Insert complete');
        }catch(System.DmlException e){
            System.debug('DML exception:' + e.getDmlMessage(0));
        }

        List<InventoryResults__c> newInventoryResultsList = [select Name, Assets__c, InventoryYear__c from InventoryResults__c];
        return newInventoryResultsList;

    }

    /*
     * @テスト用ユーザ作成
     * @String name : ユーザ名
     * @String pName : プロファイル名
     */ 
    @TestVisible User createdUser(String name, String pName){
        Profile profile;
        if(pName == 'admin'){
            profile = getAdminProfile();
        }else{
            profile = getStandardProfile();
        }
        String profileId =profile.id;

        User user = new User();
        user.Email = name + 'test@xxx.com';
        user.UserName = name + 'test@xxx.com';
        user.FirstName = name;
        User.LastName = 'abc';
        user.Alias = user.UserName.split('@')[0].left(8);
        user.profileId = profileId;
        user.EmailEncodingKey = 'ISO-2022-JP';
        user.LanguageLocaleKey = 'ja';
        user.LocaleSidKey = 'ja_JP';
        user.TimeZoneSidKey = 'Asia/Tokyo';

        insert user;

        user = [select Name, UserName, FirstName, LastName, Alias, UserRoleId, ProfileId, CreatedDate from user where UserName = :user.Username limit 1];
        
        return user;
    }

    /*
     * @標準プロファイルのId取得
     */ 
    private static Profile getStandardProfile(){
        List<Profile> profiles = [select Id From Profile where Name = '標準ユーザ' limit 1];
        if (profiles.isEmpty()){
            profiles = [select Id From Profile where Name = 'Standard User' limit 1];
        }
        return profiles[0];
    }

    /*
     *@システム管理者プロファイルのId取得
     */
    private static Profile getAdminProfile(){
        List<Profile> profiles = [select Id From Profile where Name = 'システム管理者' limit 1];
        if (profiles.isEmpty()){
            profiles = [select Id From Profile where Name = 'System Admin' limit 1];
        }
        return profiles[0];
    }

    /*
     *@権限セットをユーザに付与
     */
    @TestVisible void getPermissionSet(User user, String PerSetName){
        PermissionSet PerSet = [SELECT Id FROM PermissionSet WHERE Name =:PerSetName];
        PermissionSetAssignment PerSetAss = new PermissionSetAssignment(
            AssigneeId = user.Id,
            PermissionSetId = PerSet.Id
        );
        insert PerSetAss;
    }
}