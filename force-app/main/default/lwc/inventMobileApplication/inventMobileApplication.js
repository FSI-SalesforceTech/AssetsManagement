import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import Id from '@salesforce/user/Id';
import searchInventoryResults from '@salesforce/apex/inventMobileApplicationControler.searchInventoryResults';
import searchAssets from '@salesforce/apex/inventMobileApplicationControler.searchAssets';
import NORESULT_ILUST from '@salesforce/resourceUrl/no_result';

export default class InventMobileApplication extends LightningElement {
    @track home = true;
    @track inventory = false;
    @track search = false;
    @track barcodenumber;
    myScanner;
    scanButtonDisabled = false;
    noresultUrl = NORESULT_ILUST;
    userId = Id;
    get today() {
        let now = new Date();
        
        return now.getFullYear() + '-' + ('0' + (now.getMonth() + 1)).slice(-2) + '-' + ('0' + now.getDate()).slice(-2);
    }

    connectedCallback() {
        this.myScanner = getBarcodeScanner();
        if (this.myScanner == null || !this.myScanner.isAvailable()) {
            this.scanButtonDisabled = true;
        }
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

    handleBeginScanClick(event) {
        //this.barcodenumber = '';

        if (this.myScanner != null && this.myScanner.isAvailable()) {
            const scanningOptions = {
                barcodeTypes: [this.myScanner.barcodeTypes.CODE_128]
            };
            this.myScanner
                .beginCapture(scanningOptions)
                .then((result) => {
                    this.barcodenumber = decodeURIComponent(result.value);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Successful Scan',
                            message: 'Barcode scanned successfully.',
                            variant: 'success'
                        })
                    );
                })
                .catch((error) => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Barcode Scanner Error',
                            message:
                                JSON.stringify(error) +
                                ' Please try again.',
                            variant: 'error',
                            mode: 'sticky'
                        })
                    );
                })
                .finally(() => {
                    this.myScanner.endCapture();
                });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'バーコードスキャナーが有効になっていません',
                    message:
                        'Salesforce モバイルアプリケーションで再度試してください。',
                    variant: 'error'
                })
            );
        }
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