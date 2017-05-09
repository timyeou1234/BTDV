
#import "Function.h"
#import <CoreBluetooth/CoreBluetooth.h>

@protocol MyBluetoothLEDelegate

//設備BLE事件
//@param isOpen 藍牙開啟
- (void)onBtStateEnable:(bool)isEnable;

//掃描到的設備
//@param uuid=uuid address , name=名稱 , rssi=訊號強度
- (void)onScanResultUUID:(NSString *)uuid Name:(NSString *)name RSSI:(int)rssi;

//連線狀態
- (void)onConnectionState:(ConnectState)state;

//接收字串
- (void)onDataResultMessage:(NSString *)message;

- (void) onWriteCommand:(NSString *) command;

@end

//enum UnicodeMode{ imHex, imAscII};

@interface MyBluetoothLE : Function<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) id<MyBluetoothLEDelegate> myBLEDelegate;


- (id)getInstanceInfo:(NSDictionary *)info;

//彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth;

//使用CBCentralManager，以檢查是否當前平台/硬件支持藍牙LE。
- (bool)isSupportBLE;

//搜尋
//@param uuids 要搜尋的Services UUID
//@param timeout 掃描時間
- (void)imStartScanUUIDs:(NSArray *)uuids Timeout:(int)timeout;

//停止掃描
- (void)imStopScan;

//連線
- (void)imConnectUUIDs:(NSArray *)uuids;

//手動斷線
- (void)imDisconnect;

//發送訊息
- (void)imSendMessage:(NSString *)message;

@end
