
#import "MyBluetoothLE.h"

@implementation MyBluetoothLE{
    NSMutableArray *charWriteDictionary;
    
    //連線狀態 0:未連線 1:連線 2:斷線
    int connectStatus;
    //true:已回覆 false:未回覆
    BOOL commandStatus;
    //判斷是否監聽到所有notify UUID
    int notifyUUIDCount;
    //判斷是否接收到全部device訊息
    int receivedMessageCount;
    //掃描到的設備Array
    NSMutableArray *peripheralDictionary;
    //連線到的設備Array
    NSMutableArray *deviceNumDictionary;
    
    //要連線 & 操作的Services UUID
    NSArray *connectionUUIDs;
    NSString *serviceUUID;
    NSString *writeUUID;
    NSString *notifyUUID;
    NSString *notifyUpdateUUID;
    
    NSTimer *scanTimer;
    NSTimer *commandTimer;
    NSTimer *connectTimer;
}

int writeType = CBCharacteristicWriteWithoutResponse; //or CBCharacteristicWriteWithResponse

//初始化
- (id)getInstanceInfo:(NSDictionary *)info{
    
    [Function printLog:[[NSString alloc] initWithFormat:@"MyBluetoothLE-----getInstanceInfo"]];
    
    serviceUUID = serviceUUID == nil ? [info objectForKey:@"serviceUUID"] : serviceUUID;
    writeUUID = writeUUID == nil ? [info objectForKey:@"writeUUID"] : writeUUID;
    notifyUUID = notifyUUID == nil ? [info objectForKey:@"notifyUUID"] : notifyUUID;
    
    [Function printLog:[[NSString alloc] initWithFormat:@"MyBluetoothLE-----getInstanceInfo : %@", connectionUUIDs]];
    [Function printLog:[[NSString alloc] initWithFormat:@"MyBluetoothLE-----getInstanceInfo : %@", serviceUUID]];
    
    connectionUUIDs = connectionUUIDs == nil ? [[NSArray alloc] initWithObjects:
                                                [CBUUID UUIDWithString:serviceUUID], nil] : connectionUUIDs;
    [Function printLog:[[NSString alloc] initWithFormat:@"MyBluetoothLE-----getInstanceInfo : %@", connectionUUIDs]];
    
    [self initScanParams];
    [self initConnectParams];
    
    return self;
}

- (void)initScanParams{
    if(_centralManager == nil){
        //BLE Manager
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false], CBCentralManagerOptionShowPowerAlertKey, NULL];
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    }
    
    //掃到的外圍設備
    peripheralDictionary = peripheralDictionary == nil ? [[NSMutableArray alloc] init] : peripheralDictionary;
    [peripheralDictionary removeAllObjects];
    
    //連線到的設備position
    deviceNumDictionary = deviceNumDictionary == nil ? [[NSMutableArray alloc] init] : deviceNumDictionary;
    [deviceNumDictionary removeAllObjects];
    
    //Write Char Array
    charWriteDictionary = charWriteDictionary == nil ? [[NSMutableArray alloc] init] : charWriteDictionary;
    [charWriteDictionary removeAllObjects];
}

- (void)initConnectParams{
    //訊息回覆狀態true:已回覆 false:未回覆
    commandStatus = true;
    //判斷是否監聽notify狀態
    notifyUUIDCount = 0;
    //判斷是否接收到全部device訊息
    receivedMessageCount = 0;
    //連線狀態
    connectStatus = 0;
}

- (void)enableBluetooth{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

//使用CBCentralManager，以檢查是否當前平台/硬件支持藍牙LE。
- (bool) isSupportBLE{
    switch ([_centralManager state]){
        case CBCentralManagerStateUnsupported:
            NSLog(@"BLE管理器狀態:此設備不支援BLE");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"BLE管理器狀態:此App無BLE功能");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"BLE管理器狀態:請開啟藍芽");
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            NSLog(@"BLE管理器狀態:出現未知錯誤");
            return FALSE;
    }
    return FALSE;
}

//搜尋
//@param uuids 要搜尋的Services UUID , 可以nil
//@param timeout 掃描時間
- (void)imStartScanUUIDs:(NSArray *)uuids Timeout:(int)timeout{
    
    [self initScanParams];
    
//    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

    [self cancelScanTimer];
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(scanTimeout) userInfo:nil repeats:false];
    
    [_centralManager scanForPeripheralsWithServices:uuids options:nil];
    
}

//停止搜尋
- (void)imStopScan{
    [self cancelScanTimer];
    [_centralManager stopScan];//停止搜尋
}

//連線
- (void)imConnectUUIDs:(NSArray *)uuids{
    
    [self initConnectParams];
    
    [self imStopScan];//停止搜尋
    [self cancelScanTimer];
    [self cancelConnectTimer];
    
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(connectionTimeout) userInfo:nil repeats:false];
    
    for (int i=0; i<peripheralDictionary.count; i++){
        
        CBPeripheral *p = [peripheralDictionary objectAtIndex:i];
        NSString *uuid = p.identifier.UUIDString;
        
        for (int j = 0; j < uuids.count ; j++){
            
            if ([uuid isEqualToString:[uuids objectAtIndex:j]]){
                
                [_centralManager connectPeripheral:p options:nil];
                
                NSNumber *deviceNum = [NSNumber numberWithFloat:i];
                [deviceNumDictionary addObject:deviceNum];
                
                [Function printLog:[NSString stringWithFormat:@"連線 的藍牙名稱 = %@ , UUID = %@", p.name, uuid]];
            }
        }
    }
}

//手動斷線
- (void)imDisconnect{
    connectStatus = 2;
    [self cancelConnectTimer];
    
    for (int i = 0; i < deviceNumDictionary.count; i++){
        [_centralManager cancelPeripheralConnection:[peripheralDictionary objectAtIndex:[[deviceNumDictionary objectAtIndex:i] intValue]]];
        [Function printLog:@"手動斷線成功"];
    }
    [self initScanParams];
    [self cancelCommandTimer];
    
    [_myBLEDelegate onConnectionState:Disconnect];
}

- (void)imSendMessage:(NSString *)message{
    if (connectStatus == 1){
        [self SendMessage:message EncodeType:1];
    }else {
        [deviceNumDictionary removeAllObjects];
    }
}

//處理傳送事件
//0=ASCII,1=Hex
- (void)SendMessage:(NSString *)message EncodeType:(int)encodeType{
    
    switch ( encodeType ){
        case 0: {//編碼ASCII
//            NSString * content = [message stringByAppendingString:@"\r\n"];
//            NSData *data = [content dataUsingEncoding:NSISOLatin1StringEncoding];
//            for (int i=0; i<deviceNumDictionary.count; i++){
//                [[peripheralDictionary objectAtIndex:[[deviceNumDictionary objectAtIndex:i] intValue]] writeValue:data forCharacteristic:[charWriteDictionary objectAtIndex:i] type:CBCharacteristicWriteWithResponse];
//            }
        }
            break;
        case 1: {//編碼Hex
            
            NSLog(@"MyBluetoothLe SendMessage~~~~~~~~~~~ message = %@", message);
            
            static uint8_t buf[1024];
            
            unsigned long size = message.length;
            
            for (int i = 0; i < size ; i+=2){
                NSString *hexStr = [message substringWithRange:NSMakeRange(i, 2)];
                buf[i / 2] = [Function hexStringToInt:hexStr];
            }

            NSData *data = [NSData dataWithBytes:(const void *)buf length:size / 2];
            
            
            [_myBLEDelegate onWriteCommand:message];
            for(int i = 0 ; i < deviceNumDictionary.count ; i++){
                [Function printLog:[NSString stringWithFormat:@"SendMessage   data = %@", data]];
                [[peripheralDictionary objectAtIndex:[[deviceNumDictionary objectAtIndex:i] intValue]] writeValue:data forCharacteristic:[charWriteDictionary objectAtIndex:i] type:writeType];
            }
            
            //Received Message Count
            receivedMessageCount = 0;
            if(commandStatus){
                commandStatus = false;
                [self cancelCommandTimer];
                //Command Timeout 5s
                commandTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(commandTimeout) userInfo:nil repeats:NO];
            }
        }
            break;
    }
}

//藍牙狀態改變時
- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    [_myBLEDelegate onBtStateEnable:[self isSupportBLE]];
}

//掃描到藍牙時
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)aPeripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSString *name = aPeripheral.name;
    [Function printLog:[NSString stringWithFormat:@"SoleProtocol didDiscoverPeripheral  name = %@", name]];
    
    if(name == NULL || [name isEqualToString:@""])
        name = @"n/a";
    
    NSString *uuid = aPeripheral.identifier.UUIDString;
    
    if(uuid == NULL || [uuid isEqualToString:@""])
        return;
    
    if ([peripheralDictionary containsObject:aPeripheral]){
        [peripheralDictionary removeObject:aPeripheral];
        
        [peripheralDictionary addObject:aPeripheral];
    }else{
        [peripheralDictionary addObject:aPeripheral];
        [_myBLEDelegate onScanResultUUID:uuid Name:name RSSI:[RSSI intValue]];
    }
}

//連接藍牙成功
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)aPeripheral{
    [Function printLog:[NSString stringWithFormat:@"連線成功 , aPeripheral.UUID = %@",aPeripheral.identifier.UUIDString]];
    
    [aPeripheral setDelegate:self];
    
//    NSArray *uuids = [[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:serviceUUID], nil];
    [aPeripheral discoverServices:connectionUUIDs];
}

//斷線事件
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error{
    connectStatus = 2;
    NSLog(@"斷線了 = %@, error msg:%@, %@", aPeripheral.identifier.UUIDString ,[error localizedFailureReason], [error localizedDescription]);
    
    [self imDisconnect];
}


//連線失敗。
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral error:(NSError *)error{
    NSLog(@"連接失敗 peripheral: %@ with error = %@", aPeripheral, error.description);
    
    [self imDisconnect];
}

//搜尋Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    [Function printLog:[NSString stringWithFormat:@"搜尋Services  didDiscoverServices : %@ with error = %@", peripheral.name, [error localizedDescription]]];
    
    if (error) {
        NSLog(@"Error didDiscoverServices: %@", [error localizedDescription]);
        [self imDisconnect];
    }else{
        for (CBService *service in peripheral.services) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

//notify charactoeristic result
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if(error){
        NSLog(@"didUpdateNotificationStateForCharacteristic  : name = %@ with error = %@", peripheral.name, [error localizedDescription]);
        [self imDisconnect];
    }else{
        [Function printLog:[NSString stringWithFormat:@"didUpdateNotificationStateForCharacteristic value : %@", characteristic.value]];
    }
    
}

//搜尋到Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error) {
         NSLog(@"Error didDiscoverCharacteristicsForService: %@", [error localizedDescription]);
        [self imDisconnect];
    }else{
        if ([peripheralDictionary containsObject:peripheral]){
            
            NSUInteger index = [peripheralDictionary indexOfObject:peripheral];
            
            
            for (CBCharacteristic *characteristic in service.characteristics){
                
                [Function printLog:[NSString stringWithFormat:@"Service 11 UUID : %@", characteristic.service.UUID]];
                [Function printLog:[NSString stringWithFormat:@"Characteristic 11 UUID : %@", characteristic.UUID]];
                
                if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]]){
                    if([writeUUID isEqualToString:notifyUUID] &&
                       [characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyUUID]]){
                        CBPeripheral *aPeripheral = [peripheralDictionary objectAtIndex:index];
                        //[aPeripheral readValueForCharacteristic:characteristic];
                        [aPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                        
                        [Function printLog:[NSString stringWithFormat:@"setNotifyValue Both: %@", characteristic.UUID]];
                        notifyUUIDCount++;
                        
                        
                        [charWriteDictionary addObject:characteristic];
                        [[peripheralDictionary objectAtIndex:[[deviceNumDictionary objectAtIndex:0] intValue]] discoverDescriptorsForCharacteristic:characteristic];
                        
                        [Function printLog:[NSString stringWithFormat:@"setWrite Both: %@", characteristic.UUID]];
                    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyUUID]]){
                        CBPeripheral *aPeripheral = [peripheralDictionary objectAtIndex:index];
                        //[aPeripheral readValueForCharacteristic:characteristic];
                        [aPeripheral setNotifyValue:YES forCharacteristic:characteristic];
                        
                        [Function printLog:[NSString stringWithFormat:@"setNotifyValue: %@", characteristic.UUID]];
                        notifyUUIDCount++;
                        
                    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:writeUUID]]){
                        
                        [charWriteDictionary addObject:characteristic];
                        [[peripheralDictionary objectAtIndex:[[deviceNumDictionary objectAtIndex:0] intValue]] discoverDescriptorsForCharacteristic:characteristic];
                        
                        [Function printLog:[NSString stringWithFormat:@"setWrite: %@", characteristic.UUID]];
                    }
                }
                
            }
            if(connectStatus != 1 && charWriteDictionary.count == deviceNumDictionary.count && notifyUUIDCount == deviceNumDictionary.count){
                [Function printLog:@"全部連線成功"];
                connectStatus = 1;
                [self cancelConnectTimer];
                [_myBLEDelegate onConnectionState:Connected];
            }
        }
    }
}

- (void) scanTimeout{
    [self imStopScan];
    [self.myBLEDelegate onConnectionState:ScanFinish];
}

- (void) connectionTimeout{
    if(connectStatus != 1){
        [Function printLog:@"Connection Timeout 15s End"];
        [self imDisconnect];
    }
}

- (void) commandTimeout{
    if(commandStatus == false){
        //[Function printLog:@"Command Timeout 5s End"];
        //[self imDisconnect];
    }
}

- (void) cancelScanTimer{
    if(scanTimer != NULL){
        [scanTimer invalidate];
        scanTimer = NULL;
    }
}

- (void) cancelConnectTimer{
    if(connectTimer != NULL){
        [connectTimer invalidate];
        connectTimer = NULL;
    }
}

- (void) cancelCommandTimer{
    if(commandTimer != NULL){
        [commandTimer invalidate];
        commandTimer = NULL;
    }
}

//回覆訊息 or read message
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    [Function printLog:[NSString stringWithFormat:@"接收 = %@", characteristic.value]];
    
    if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:serviceUUID]] && [characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyUUID]]){
        
        NSString *message = [self parseValue:characteristic.value EncodeType:1];
        [_myBLEDelegate onDataResultMessage:message];
        receivedMessageCount++;
        
        
        if(connectStatus == 1 && receivedMessageCount == deviceNumDictionary.count){
            [self cancelCommandTimer];
            commandStatus = true;
        }
    }
}

//0=ASCII,1=Hex
- (NSString *)parseValue:(NSData *)data EncodeType:(int)encodeType{
    
    const uint8_t* buf = [data bytes];
    NSString *receiveStr = @"";
    
    if ( buf != nil ){
        switch ( encodeType ){
            case 0: {//編碼ASCII
                receiveStr = [NSString stringWithCString:(const char *)buf encoding:NSMacOSRomanStringEncoding];
            }
                break;
            case 1: {//編碼Hex
            
                NSString *dataStr = @"";
                
                for (int i = 0; i < [data length]; i++){
                    dataStr = [NSString stringWithFormat:@"%02X", buf[i]];
                    if ( i == 0 ){
                        receiveStr = dataStr;
                    }else{
                        receiveStr = [NSString stringWithFormat:@"%@%@", receiveStr, dataStr];
                    }
                }
            }
                break;
            default:
                break;
        }
    }
    return receiveStr;
}

@end
