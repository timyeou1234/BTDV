
#import "Function.h"

@implementation Function

//@synthesize isPrintLog;
static BOOL isPrintLog = false;

#pragma mark - Math
//十六進位字串轉bytes
+ (NSData *) hexStrToNSData:(NSString *)hexStr{
    
    NSMutableData* data = [NSMutableData data];
    
    int idx;
    
    for (idx = 0; idx+2 <= hexStr.length; idx+=2) {
        
        NSRange range = NSMakeRange(idx, 2);
        
        NSString* ch = [hexStr substringWithRange:range];
        
        NSScanner* scanner = [NSScanner scannerWithString:ch];
        
        unsigned int intValue;
        
        [scanner scanHexInt:&intValue];
        
        [data appendBytes:&intValue length:1];
        
    }
    return data;
}

+ (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    //    [Function printLog:[NSString stringWithFormat:@"SoleProtocol hexStringToInt  -> %i", result]];
    //    [Function printLog:[NSString stringWithFormat:@"SoleProtocol hexStringToInt  -> %x", result]];
    return result;
}

// 字串轉十六進制(轉換字串: string): int
+ (int)stringToHex:(NSString *)string{
    
    int nValue = 0;
    for (int i = 0; i < [string length]; i++)
    {
        int nLetterValue ;  //針對數字0〜9，A〜F
        switch ([string characterAtIndex:i])
        {
            case 'a':case 'A':
                nLetterValue = 10;
                break;
            case 'b':case 'B':
                nLetterValue = 11;
                break;
            case 'c': case 'C':
                nLetterValue = 12;
                break;
            case 'd':case 'D':
                nLetterValue = 13;
                break;
            case 'e': case 'E':
                nLetterValue = 14;
                break;
            case 'f': case 'F':
                nLetterValue = 15;
                break;
            default:
                nLetterValue = [string characterAtIndex:i] - '0';
                break;
                
        }
        nValue = nValue * 16 + nLetterValue; //16進制
    }
    return nValue;
}

//+ (MySingleton *) instance
//{
//    // Persistent instance.
//    static MySingleton *_default = nil;
//    if (_default == nil)
//    {
//        _default = [[MySingleton alloc] init];
//    }
//    return _default;
//}

+ (void)setPrintLog:(BOOL)printLog{
    isPrintLog = printLog;
}

+ (void)printLog:(NSString *)log{
    if(isPrintLog)
        NSLog(@"%@", log);
}

+ (int)getIntFromHexString:(NSString *)hexString ScanLocation:(int)scanLocation{
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    //unsigned = 正數 0 ~ 4,294,967,295
    unsigned int decimal = 0;
    [scanner setScanLocation:scanLocation]; // 從第幾個開始
    //& = 變數的位置 , * = 取得指標變數所指向的內容。
    [scanner scanHexInt:&decimal];
    return decimal;
}

+ (NSString *)getCurrentDateTimeWeek{
    //現在時間
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //時間格式
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    //星期
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    long week = [components weekday] - 1;
    
    NSString *dateTimeWeek = [NSString stringWithFormat:@"%@-%li", [dateFormat stringFromDate:currentDate], week];
    return dateTimeWeek;
}

+ (long)getDayOfMonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    
    long dayOfMonth = range.length;
    return dayOfMonth;
}

@end
