
#import "CommProcess.h"
#import "MyBluetoothLE.h"
#import "FuelProtocol.h"


/**
 操作流程：
 //Step 1初始化
 protocol = [[FuelProtocol alloc] getInstanceSimulation:false PrintLog:true];
 protocol.connectStateDelegate = self;
 protocol.dataResponseDelegate = self;
 
 //Step 2 判斷系統藍牙是否開啟
 [protocol enableBluetooth]; -(delegate)> - (void) onBtStateChanged:(bool) isEnable;
 
 //Step 3 開始掃描
 [protocol startScanTimeout:10]; -(delegate)> - (void) onScanResultUUID:(NSString*) uuid Name:(NSString*) name RSSI:(int) rssi;
 
 //Step 4 停止掃描
 [protocol stopScan];
 
 //Step 5 連線
 [protocol connectUUID:uuid]; -(delegate)> - (void) onConnectionState:(ConnectState) state;
 
 
 //Step 6 取得藍牙裝置資訊
 - (NSString *) getFwVersion;
 - (NSString *) getHwVersion;
 - (int) getBattery;
 
 //Step 7 拍照/錄影模式改變時call
 [protocol setCameraMode:textStr2.intValue];
 
 //Step 8 Delegate，藍牙裝置按鈕觸發事件
 - (void) onResponsePressed:(int) keyboardCode;
 
 */

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

/**
 * 藍牙裝置按鈕觸發事件
 * KeyCode:4(Zoom in)
 * KeyCode:1(Zoom out)
 * KeyCode:2(拍照/錄影)
 */
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

//檢查是否支援藍牙。如果未開啟藍牙,彈出詢問使用者是否開啟藍牙視窗
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
