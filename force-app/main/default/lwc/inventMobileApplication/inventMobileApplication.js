import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import searchInventoryResults from '@salesforce/apex/inventMobileApplicationControler.searchInventoryResults';
import searchAssets from '@salesforce/apex/inventMobileApplicationControler.searchAssets';
import NORESULT_ILUST from '@salesforce/resourceUrl/no_result';

export default class InventMobileApplication extends LightningElement {
    @track home = true;
    @track inventory = false;
    @track search = false;
    @track barcodenumber;
    noresultUrl = NORESULT_ILUST;
    userId = Id;
    get today() {
        let now = new Date();
        
        return now.getFullYear() + '-' + ('0' + (now.getMonth() + 1)).slice(-2) + '-' + ('0' + now.getDate()).slice(-2);
    }

    @wire(searchAssets, {BarcodeNumber : '$barcodenumber'})
    AssetsList

    @wire(searchInventoryResults, {BarcodeNumber : '$barcodenumber'})
    InventoryResultsList

    handleClickAssets() {
        this.home = false;
        this.inventory = true;
    }

    handleClickSearch() {
        this.home = false;
        this.search = true;
    }

    handleClickHome() {
        this.home = true;
        this.inventory = false;
        this.search = false;
    }

    handleClickSearchExec() {
        // Winter '21 まではこれ
        this.barcodenumber = '9000000291771';
    }

    handleClickAssetsExec() {
        // Winter '21 まではこれ
        this.barcodenumber = '9000000291771';
    }

    handleEditSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: '更新しました！',
                variant: 'success'
            })
        );
    }
}