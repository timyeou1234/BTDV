
#import "CommProcess.h"

@implementation CommProcess{
    //通訊迴圈
    NSTimer *commTimer;
    //指令Array
    NSMutableArray *commArray;
    
    //通訊秒數
    float frequency;
    //標頭檔
    NSString *header;
    //標尾檔
    NSString *end;
    //CheckSum類型
    int checksumType;
    
    int sendCount;
    
}

- (void)initWithInfo:(NSDictionary *)info PrintLog:(BOOL)printLog{
    
    commArray = [[NSMutableArray alloc] init];
    
    //通訊秒數
    frequency = [[info objectForKey:@"frequency"] floatValue];
    //標頭檔
    header = [info objectForKey:@"header"];
    //標尾檔
    end = [info objectForKey:@"end"];
    //checksum類型
    checksumType = [[info objectForKey:@"checksumType"] intValue];
    
    _myBluetooth = [[MyBluetoothLE alloc] getInstanceInfo:info];
}

- (NSString *)getHeader{
    return header;
}
- (NSString *)getEnd{
    return end;
}

//開始通訊迴圈
- (void)commTimerStart{
    [self commTimerStop];
    
    commTimer = [NSTimer scheduledTimerWithTimeInterval:frequency target:self selector:@selector(commTimerLoop) userInfo:nil repeats:YES];
}

- (void)commTimerLoop{
    
    if ( commArray.count > 0){
        
        NSString *message = [self getFirstComm];
        sendCount++;
        
        if(sendCount >= 10){
            [Function printLog:[NSString stringWithFormat:@"commTimerLoop---回覆超時 自動斷線!"]];
            sendCount = 0;
            [_myBluetooth imDisconnect];
            return;
        }
        
        [Function printLog:[NSString stringWithFormat:@"commTimerLoop--- message = %@ , sendCount = %i", message, sendCount]];
        [_myBluetooth imSendMessage:message];
        
        [self initSendCount];
        [self removeAllComm];
    }
}

- (void)initSendCount{
    sendCount = 0;
}

//結束通訊迴圈
- (void)commTimerStop{
    [commArray removeAllObjects];
    if(commTimer != NULL){
        [commTimer invalidate];
        commTimer = NULL;
    }
}


- (void)addCommArray:(NSString *)comm RemoveAllComm:(BOOL)removeAllComm{
    NSLog(@"addCommArray---%@ -> %lu , %i", comm, (unsigned long)commArray.count, removeAllComm);
//    if([commArray count] > 10 || removeAllComm)
//        [self removeOtherComm];
    if(removeAllComm)
        [self removeOtherComm];
    
//    NSString *newComm = [self calcChecksum:comm];
    [commArray addObject:comm];
}

- (NSString *)getFirstComm{
    if (commArray.count > 0)
        return [commArray objectAtIndex:0];
    else
        return nil;
}

- (int)getCommArrayCount{
    return commArray.count;
}

//刪除命令
- (void)removeComm{
    if(commArray.count >= 1)
        [commArray removeObjectAtIndex:0];
}

//刪除所有相同命令
- (void)removeSameComm:(NSString *)cmd{
    for(int i = 0; i < commArray.count; i++) {
        if([[commArray objectAtIndex:i] isEqualToString:cmd]) {
            [commArray removeObjectAtIndex:i];
        }
    }
}

- (void)removeOtherComm{
    if(commArray != NULL && commArray.count > 1){
        NSString *commStr = [commArray objectAtIndex:0];
        [self removeAllComm];
        [commArray addObject:commStr];
    }
}

//刪除所有命令
- (void)removeAllComm{
    [commArray removeAllObjects];
}

- (NSString*) calcChecksum:(NSString*)message{
    NSString* length = [[NSString alloc] initWithFormat:@"%02lx", message.length / 2 + 1];
    
    NSString* result;
    
    //無標尾檔
    if([end isEqualToString:@"-1"]){
        //無標頭檔
        if([header isEqualToString:@"-1"]){
            //無checksum
            if(checksumType == none){
                
            }else{
                //有checksum
                
            }
        }else{
            //有標頭檔
            //無checksum
            if(checksumType == none){
                result = [[NSString alloc] initWithFormat:@"%@%@%@", header, length, message];
            }else{
                //有checksum
                unsigned int checksum = [self computationCheckSum:message];
                result = [[NSString alloc] initWithFormat:@"%@%@%@%02x", header, length, message, checksum];
            }
            
        }
    }else{
        //有標尾
        //無標頭檔
        if([header isEqualToString:@"-1"]){
            if(checksumType == none){
                //無checksum
                
            }else{
                
            }
        }else{
            //有標頭檔
            if(checksumType == none){
                //無checksum
                result = [[NSString alloc] initWithFormat:@"%@%@%@%@", header, length, message, end];
            }else{
                //有checksum
                unsigned int checksum = [self computationCheckSum:message];
                result = [[NSString alloc] initWithFormat:@"%@%@%@%02x%@", header, length, message, checksum, end];
            }
        }
    }
    
    
    return result;
}

//驗證received字串
- (NSString *)calcReceivedMessage:(NSString *)message{
    
//    NSArray *splitMsg = [message componentsSeparatedByString:@","];
    
    unsigned long length = message.length;
    
    if ( length > 0 ){
        NSString *comm = @"";
        
        //是否有標頭檔
        BOOL noHeader = [header isEqualToString:@"-1"];
        //是否有標尾檔
        BOOL noEnd = [end isEqualToString:@"-1"];
        
        
        // 1.驗證標頭檔
        if ( !noHeader && ![message hasPrefix:header])
            return @"Header Error";
        
        // 2.驗證標尾檔
        if ( !noEnd && ![message hasSuffix:end])
            return @"End Error";
        
        return comm;
    }
    return @"Command empty";
}

//計算 CheckSum
- (unsigned int)computationCheckSum:(NSString *)comm{
    
    unsigned int checkSum = 0;
    switch (checksumType) {
        case cpAndFF:{
            
            int i = 0;
            while (i < [comm length])
            {
                NSString * hexChar = [comm substringWithRange: NSMakeRange(i, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%04x", &value);
                
                checkSum += value;
//                [newString appendFormat:@"%c", (char)value];
                i+=2;
            }
            checkSum &= 0xFFFF;
            NSLog(@"computationCheckSum newString = %04x", checkSum);
        }
            break;
    }
    
    return checkSum;
}

unsigned int FUN_Get_CRC16_Value(unsigned char *data0, unsigned char data_length)
{
    unsigned int reg_crc=0xffff;
    unsigned char data_bytes = 0;
    unsigned char j = 0;
    for(data_bytes=0; data_bytes<data_length; data_bytes++)
    {
        reg_crc=(((reg_crc&0x00FF)^*(data0+data_bytes))|(reg_crc&0xFF00));
        //reg_crc^=*(data0+data_bytes);
        for(j=0; j<8; j++)
        {
            if(reg_crc&0x0001)
                reg_crc=(reg_crc>>1) ^ POLY;
            else
                reg_crc>>=1;
        }
    }
    return reg_crc;
}


- (NSString*)convertHexToBinary:(NSString*)hexString {
    
    NSMutableString *returnString = [NSMutableString string];
    for(int i = 0; i < [hexString length]; i++) {
        char c = [[hexString lowercaseString] characterAtIndex:i];
        switch(c) {
            case '0':
                [returnString appendString:@"0000"];
                break;
            case '1':
                [returnString appendString:@"0001"];
                break;
            case '2':
                [returnString appendString:@"0010"];
                break;
            case '3':
                [returnString appendString:@"0011"];
                break;
            case '4':
                [returnString appendString:@"0100"];
                break;
            case '5':
                [returnString appendString:@"0101"];
                break;
            case '6':
                [returnString appendString:@"0110"];
                break;
            case '7':
                [returnString appendString:@"0111"];
                break;
            case '8':
                [returnString appendString:@"1000"];
                break;
            case '9':
                [returnString appendString:@"1001"];
                break;
            case 'a':
                [returnString appendString:@"1010"];
                break;
            case 'b':
                [returnString appendString:@"1011"];
                break;
            case 'c':
                [returnString appendString:@"1100"];
                break;
            case 'd':
                [returnString appendString:@"1101"];
                break;
            case 'e':
                [returnString appendString:@"1110"];
                break;
            case 'f':
                [returnString appendString:@"1111"];
                break;
            default :
                break;
        }
    }
    return returnString;
}

- (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}

- (NSString *) hexStringToAscii:(NSString *)hexString{
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    unsigned long length = [hexString length];
    
    while (i < length){
        NSString * hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    return newString;
}

- (NSString *) asciiStringToHex:(NSString *)asciiString{
    NSMutableString* newString = [[NSMutableString alloc] init ];
    unsigned long len =  [asciiString length];
    for (int i = 0; i < len; i++) {
        if(i < len){
            unsigned int ch =   [asciiString characterAtIndex:i];
            [newString appendString:[NSString stringWithFormat:@"%02X", ch]];
        }
        else{
            [newString appendString:[NSString stringWithFormat:@"00"]];
        }
    }
    return newString;
}

- (NSString *) getIntToHexString:(int)i Digit:(int)digit{
    NSString *hexString = [[NSString alloc] initWithFormat:@"%x", i];
    
    while(hexString.length < digit)
        hexString = [[NSString alloc] initWithFormat:@"0%@", hexString];
    
    return hexString;
}

- (NSString *) getFillString:(int)i :(int) length :(NSString *) fillStr{
    NSMutableString * newString = [[NSMutableString alloc] initWithFormat:@"%i", i];
    while ([newString length] < length){
        [newString insertString:fillStr atIndex:0];
    }
    return newString;
}

@end
