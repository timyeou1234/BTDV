
#import "CommProcess.h"
#import "MyBluetoothLE.h"
#import "FuelProtocol.h"

@protocol ConnectStateDelegate

/**
 * 開啟設備BLE事件
 * @param isEnable 藍牙是否開啟
 */
- (void) onBtStateChanged:(bool) isEnable;

/**
 * 返回掃描到的藍牙
 * @param uuid mac address
 * @param name 名稱
 * @param rssi 訊號強度
 */
- (void) onScanResultUUID:(NSString*) uuid Name:(NSString*) name RSSI:(int) rssi;

/**
 * 連線狀態
 * ScanFinish,			//掃描結束
 * Connected,			//連線成功
 * Disconnected,		//斷線
 * ConnectTimeout,		//連線超時
 */
- (void) onConnectionState:(ConnectState) state;

@end

@protocol DataResponseDelegate

//KeyCode:4(Zoom in)
//KeyCode:1(Zoom out)
//KeyCode:2(拍照/錄影)
- (void) onResponsePressed:(int) keyboardCode;

@end

//測試用---
@protocol ProtocolTestDelegate
- (void) onWriteCommand:(NSString *) command;
- (void) onNotifyCommand:(NSString *) command;
@end


@interface FuelProtocol : CommProcess <MyBluetoothLEDelegate>{
}

@property (weak) id<ConnectStateDelegate> connectStateDelegate;
@property (weak) id<DataResponseDelegate> dataResponseDelegate;
@property (weak) id<ProtocolTestDelegate> protocolTestDelegate;


//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id) getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog;

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth;

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout;

//停止掃瞄
- (void) stopScan;

//連線,透過onConnectionState返回連線狀態
- (void) connectUUID:(NSString *)uuid;

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect;

//--------------------------------------------------------------------------------------------------------------------

//取得韌體版本
- (NSString *) getFwVersion;

//取得硬體版本
- (NSString *) getHwVersion;

//取得硬體電量
- (int) getBattery;

//設定目前相機模式。0=Normal、1=Camera、2=DV
- (void) setCameraMode:(int)mode;


@end
