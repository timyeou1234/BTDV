
#import "FuelProtocol.h"

FuelProtocol *instance;

int LENGTH_INDEX_START = 4;
int LENGTH_INDEX_LENGTH = 4;
int CMD_INDEX_START = 8;
int CMD_INDEX_LENGTH = 4;
int DATA_INDEX_START = 12;
int CHECKSUM_INDEX_START = 8;
int CHECKSUM_INDEX_LENGTH = 4;


@implementation FuelProtocol{
    bool isSimulation;
    bool isPrintLog;
    
    //Simulation----------------------------------
    NSTimer *simulationTimer;
    
    NSString *bleName;
    NSString *bleMac;
    
    NSMutableArray *simulationMacArray,*simulationNameArray;
    int simulationPosition;
    //Simulation----------------------------------
    
    NSString *allReceivedCommand;
    
    //暫存
    NSString *fwVersion;
    NSString *hwVersion;
    int battery;
    int cameraMode;
    bool upgradeMode;
    
}
//@synthesize commandDelegate;

//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id)getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog{
    isSimulation = simulation;
    isPrintLog = printLog;
    
    [Function setPrintLog:isPrintLog];
    
    if(isSimulation){
        bleName = @"Fuel";
        bleMac = @"1234567890";
        simulationPosition = 0;
        
        allReceivedCommand = @"";
        
        
        simulationMacArray = [[NSMutableArray alloc] initWithCapacity:10];
        simulationNameArray = [[NSMutableArray alloc] initWithCapacity:10];
        for(int i = 1 ; i < 11 ; i++){
            [simulationNameArray addObject:[NSString stringWithFormat:@"%@-%i", bleName, i]];
            [simulationMacArray addObject:[NSString stringWithFormat:@"%@%i", bleMac, (i - 1)]];
        }
        return self;
    }
    
    if(instance == nil)
        instance = [[FuelProtocol alloc] init];
    return instance;
}

- (id)init{
    self = [super init];
    if(self){
        NSNumber *type = [NSNumber numberWithInt:cpAndFF];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setValue:@"6E400001-B5A3-F393-E0A9-E50E24DCCA9E" forKey:@"serviceUUID"];
        [info setValue:@"6E400002-B5A3-F393-E0A9-E50E24DCCA9E" forKey:@"writeUUID"];
        [info setValue:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E" forKey:@"notifyUUID"];
        [info setValue:@"5AA5" forKey:@"header"];
        [info setValue:@"A55A" forKey:@"end"];
        [info setValue:@"0.5" forKey:@"frequency"];
        [info setValue:type forKey:@"checksumType"];
        
        [self initWithInfo:info PrintLog:isPrintLog];
        
        self.myBluetooth.myBLEDelegate = self;
    }
    return self;
}

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth{
    [self.myBluetooth enableBluetooth];
}

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout{
    [self stopScan];
    [Function printLog:@"開始掃描"];
    if(isSimulation){
        simulationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(simulationScan) userInfo:nil repeats:YES];
        return;
    }
    
//  @[[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]
//    @[[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]
//    NSArray *uuids = [NSArray arrayWithObject:[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]];
    [self.myBluetooth imStartScanUUIDs:nil Timeout:timeout];
}

//停止掃瞄
- (void)stopScan{
    [Function printLog:@"停止掃描"];
    if(isSimulation){
        [self cancelTimer];
        return;
    }
    [self.myBluetooth imStopScan];
}

- (BOOL) isSupportBLE{
    return [self.myBluetooth isSupportBLE];
}

- (void) connectUUID:(NSString *)uuid{
    [self stopScan];
    [Function printLog:@"連線"];
    if(isSimulation){
        [_connectStateDelegate onConnectionState:Connected];
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:uuid, nil];
    [self.myBluetooth imConnectUUIDs:array];
}

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect{
    [Function printLog:@"斷線"];
    if(isSimulation){
        [self cancelTimer];
        [_connectStateDelegate onConnectionState:Disconnect];
        return;
    }
    [self commTimerStop];
    [self.myBluetooth imDisconnect];
}

//--------------------------------------------------------------------------------------------------------------------

- (void) setReplyVersion{
    if(isSimulation){
        return;
    }
    upgradeMode = false;
    [self addCommArray:@"5AA50004044D00000051A55A" RemoveAllComm:false];
}

- (void) setReplyBattery{
    if(isSimulation){
        return;
    }
    upgradeMode = false;
    [self addCommArray:@"5AA50004044E00000052A55A" RemoveAllComm:false];
}

- (void) setReplyMode{
    if(isSimulation){
        return;
    }
    upgradeMode = false;
    NSString *data =[[NSString alloc] initWithFormat:@"0450%@000%i", @"00", cameraMode];
    NSString *checksum = [[NSString alloc] initWithFormat:@"%04x", [self computationCheckSum:data]];
    NSString *comm = [[NSString alloc] initWithFormat:@"5AA50005%@%@A55A", data, checksum];
    [self addCommArray:comm RemoveAllComm:true];
}

- (void) setUpgradeMode{
    if(isSimulation){
       // return;
    }
    upgradeMode = true;
    [self addCommArray:@"5AA5000403290000002CA55A" RemoveAllComm:true];
}


- (NSString *) getFwVersion {
    return fwVersion;
}

- (NSString *) getHwVersion {
    return hwVersion;
}

- (int) getBattery {
    return battery;
}

- (void) setCameraMode:(int)mode {
    cameraMode = mode;
}



//-------------MyBluetoothLEDelegate---------------------------------------
//連線狀態 IMBluetoothLE 回調

//設備BLE事件
//@param isOpen 藍牙開啟
- (void)onBtStateEnable:(bool)isEnable{
    [_connectStateDelegate onBtStateChanged:isEnable];
}

- (void)onConnectionState:(ConnectState)state{
    if(state == Connected){
        [self commTimerStart];
        battery = 0;
//        [self getDeviceInfo];
        return;
    }else if(state == Disconnect){
        [self commTimerStop];
    }
    [_connectStateDelegate onConnectionState:state];
}

//接收字串
- (void)onDataResultMessage:(NSString *)command{
//    message = [self calcReceivedMessage:message];
    //[Function printLog:[NSString stringWithFormat:@"接收字串 === command = %@",command]];
//    [_protocolTestDelegate onNotifyCommand:command];
//    
   [self resolution:command];
    
}

- (void) onWriteCommand:(NSString *) command{
    [_protocolTestDelegate onWriteCommand:command];
}

- (void)onScanResultUUID:(NSString *)uuid Name:(NSString *)name RSSI:(int)rssi{
    [_connectStateDelegate onScanResultUUID:uuid Name:name RSSI:rssi];
}



//-------------IMBluetoothLEDelegate---------------------------------------

//-------------模擬數據------------------------------------------------------
- (void)simulationConnect{
    [_connectStateDelegate onConnectionState:Connected];
}

- (void)simulationScan{
    [_connectStateDelegate onScanResultUUID:simulationMacArray[simulationPosition]
                                  Name:simulationNameArray[simulationPosition]
                                  RSSI:-50 + simulationPosition];
    simulationPosition++;
    if(simulationPosition >= 10){
        simulationPosition = 0;
        [self cancelTimer];
        [_connectStateDelegate onConnectionState:ScanFinish];
    }
}


- (void)cancelTimer{
    if(simulationTimer != nil){
        [simulationTimer invalidate];
        simulationTimer = nil;
    }
}
//-------------模擬數據------------------------------------------------------

- (void)resolution:(NSString *)message{
    
    NSString *header = [self getHeader];
    NSString *end = [self getEnd];
    
    message = message.uppercaseString;
    
    
    if(allReceivedCommand.length > 0){
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@%@", allReceivedCommand, message];
    }else{
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@", message];
    }
    
    message = allReceivedCommand;
    
    bool headerCorrect = [self isCorrectHeader:header Message:message];
    bool endCorrect = [self isCorrectEnd:end Message:message];
    int lengthCorrect = [self getCorrectLength:message];
    
    
//    NSLog(@"headerCorrect = %i", headerCorrect);
//    NSLog(@"endCorrect = %i", endCorrect);
//    NSLog(@"lengthCorrect = %i", lengthCorrect);
    
    if(headerCorrect && endCorrect && message.length >= lengthCorrect){
        
//        [Function printLog:[NSString stringWithFormat:@"Protocol Class 全部接收完 message -> %@", message]];
        
        while(allReceivedCommand.length != 0){
            
            //重新取一次message
            message = allReceivedCommand;
            //因為如果一次收到2筆Command，每次都要重新取得當筆Command的Length
            lengthCorrect = [self getCorrectLength:message];
//            [Function printLog:[NSString stringWithFormat:@"Protocol Class lengthCorrect -> %i", lengthCorrect]];
            
            //這裡要確認一次，可能後段還沒接完
            if(message.length < lengthCorrect){
                [Function printLog:[NSString stringWithFormat:@"Protocol Class 上一筆還沒接收完 message -> %@", message]];
                return;
            }
            
            message = [allReceivedCommand substringToIndex:lengthCorrect];
            
            bool endCorrect = [self isCorrectEnd:end Message:message];
            if(!endCorrect){
                [Function printLog:[NSString stringWithFormat:@"Protocol Class 標尾檔錯誤 message -> %@", message]];
                [self receiveError:message];
                return;
            }
//            [Function printLog:[NSString stringWithFormat:@"Protocol Class message -> %@", message]];
            
            
            @try {
                //----------計算Checksum是否正確----------
                //接收到的CMD
                int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_INDEX_START, CMD_INDEX_LENGTH)]];
//                [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveCmd -> %02x", receiveCmd]];
                
                //接收到的Data
                NSString *data = [message substringWithRange:NSMakeRange(DATA_INDEX_START, lengthCorrect - DATA_INDEX_START - CHECKSUM_INDEX_START)];
//                [Function printLog:[NSString stringWithFormat:@"Protocol Class Data -> %@", data]];
                
                
                NSString *receiveChecksum = [message substringWithRange:NSMakeRange(lengthCorrect - CHECKSUM_INDEX_START, CHECKSUM_INDEX_LENGTH)];
                
                
                NSString *calcChecksum = [[[NSString alloc] initWithFormat:@"%04x", [self computationCheckSum:[message substringWithRange:NSMakeRange(CMD_INDEX_START, lengthCorrect - CMD_INDEX_START - CHECKSUM_INDEX_START)]]] uppercaseString];

//                [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveChecksum -> %@", receiveChecksum]];
//                [Function printLog:[NSString stringWithFormat:@"Protocol Class calcChecksum -> %@", calcChecksum]];
                //----------計算Checksum是否正確----------
                
                
                //Checksum正確
                if([calcChecksum isEqualToString:receiveChecksum]){
                    
                
                    //因為是APP主動傳送，所以要比對Write Command
                    //如果有待發送的CMD，則比對是否跟已回傳的CMD相同，如果是，則比對是哪一個CMD，再把它刪除，代表發送成功
                    if([self getCommArrayCount] > 0){
                        
                        //發送出去的CMD, 接收的command要加100
                        int writeCmd = [self hexStringToInt:[[self getFirstComm] substringWithRange:NSMakeRange(CMD_INDEX_START, CMD_INDEX_LENGTH)]];
                        //接收到的CMD
                        int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_INDEX_START, CMD_INDEX_LENGTH)]];
                        
                        [Function printLog:[NSString stringWithFormat:@"Protocol Class writeCmd -> %02x , receiveCmd -> %02x", writeCmd, receiveCmd]];

                        
                        //比對接收到的CMD跟發送出去的CMD是否相同，如果是，就是收到剛剛發送的CMD的回覆了，刪掉發送陣列裡的CMD
                        if(writeCmd + 100 == receiveCmd) {
                            
                            [Function printLog:[NSString stringWithFormat:@"Protocol Class removeComm -> %@", [self getFirstComm]]];
                            
                            [self initSendCount];
                            [self removeComm];
                            
                            allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                            [self handleReceivedCmd:receiveCmd Data:data];
                            continue;
                        }
                    }
                    
                    //因為是硬體主動回覆，不用比對Write Command  or
                    //Write Command沒有比對到接收到的Command
                    allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                    [self handleReceivedCmd:receiveCmd Data:data];
                    
                }else{
                    //Checksum錯誤
                    [Function printLog:[NSString stringWithFormat:@"Protocol Class === Checksum錯誤 = %@", receiveChecksum]];
                    [self receiveError:message];
                }
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"NSException = %@", [exception debugDescription]);
                [self receiveError:message];
            }
        }
    }else {
        [Function printLog:[NSString stringWithFormat:@"Protocol Class 還沒接收完 message -> %@", message]];
        
        //預防機制
//        ++receiveErrorCount;
//        if(receiveErrorCount > RECEIVED_ERROR_COUNT){
//            [self receiveError:message];
//        }
    }
}

- (void)handleReceivedCmd:(int)cmd Data:(NSString *)data{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class handleReceived data -> %@", data]];
    
    bool isSuccess;
    
    switch(cmd){
        case 0x03E9:{    //回傳FW/SW
            
            [self setReplyVersion];
            
            isSuccess = TRUE;
            
            float fw = [self hexStringToInt:[data substringWithRange:NSMakeRange(4, 2)]] * 0.1;
            float hw = [self hexStringToInt:[data substringWithRange:NSMakeRange(6, 2)]] * 0.1;
            fwVersion = [[NSString alloc] initWithFormat:@"%.01f", fw];
            hwVersion = [[NSString alloc] initWithFormat:@"%.01f", hw];
            [Function printLog:[NSString stringWithFormat:@"handleReceivedCmd fwStr -> %@", fwVersion]];
            [Function printLog:[NSString stringWithFormat:@"handleReceivedCmd hwStr -> %@", hwVersion]];
        }
            break;
        case 0x03EA:{   //回傳電量
            
            if(battery == 0)
                [_connectStateDelegate onConnectionState:Connected];
            
            //刪除上一個command
            [self removeSameComm:@"5AA50004044D00000051A55A"];
            
            [self setReplyBattery];
            
            isSuccess = TRUE;

            battery = [self hexStringToInt:[data substringWithRange:NSMakeRange(4, 2)]];
            [Function printLog:[NSString stringWithFormat:@"handleReceivedCmd battery -> %i", battery]];
            
        }
            break;
        case 0x03EC:{  //固定詢問拍照or錄影模式
            //刪除上一個command
            [self removeSameComm:@"5AA50004044E00000052A55A"];
            
            isSuccess = TRUE;
            
            if(!upgradeMode){
                [self setReplyMode];
            }
            
        }
            break;
        case 0x03E8:{  //按鈕狀態
            
            //[self setReplyMode];
            
            isSuccess = TRUE;
            
            int dataLength = [self hexStringToInt:[data substringWithRange:NSMakeRange(0, 2)]] * 2;
            
            //KeyCode:4(Zoom in)
            //KeyCode:1(Zoom out)
            //KeyCode:2(拍照/錄影)
            //因為只有用到一個Byte，所以就只取2位吧
            int keyboardCode = [self hexStringToInt:[data substringWithRange:NSMakeRange(4, 2)]];
            [Function printLog:[NSString stringWithFormat:@"handleReceivedCmd keyboard -> %i", keyboardCode]];
            
            [_dataResponseDelegate onResponsePressed:keyboardCode];
        }
            break;
        default:
            [self receiveError:data];
            break;
    }
}

- (bool)isCorrectHeader:(NSString *)header Message:(NSString *)message{
    bool hasHeader = ![header isEqualToString:@"-1"];
    bool isCorrect = [message hasPrefix:header];
    if(hasHeader){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (bool)isCorrectEnd:(NSString *)end Message:(NSString *)message{
    bool hasEnd = ![end isEqualToString:@"-1"];
    bool isCorrect = [message hasSuffix:end];
    if(hasEnd){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (int)getCorrectLength:(NSString *)message{
    int length = [self hexStringToInt:[message substringWithRange:NSMakeRange(LENGTH_INDEX_START, LENGTH_INDEX_LENGTH)]];
    //Header(2Byte) + Length(2Byte) + Data + CheckSum(2Byte) + End(2Byte)
    int totalLength = (2 + 2 + length + 2 + 2) * 2;
    
    
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class dataResult totalLength -> %i", totalLength]];
    
    return totalLength;
}

- (void)receiveError:(NSString *)message{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 message -> %@", message]];
    
    allReceivedCommand = @"";
}




@end
