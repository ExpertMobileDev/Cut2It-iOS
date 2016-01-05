//
//  Util.m
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Request.h"

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

@implementation Util


+ (BOOL) isIOS5 {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0;
}

+ (BOOL) isNumber:(NSString *) string {
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [string rangeOfCharacterFromSet: nonNumbers].location == NSNotFound;
}

+ (NSString *) append:(NSString *) first, ... {
    NSString *result = first;
    NSString *temp;
    va_list alist;
    
    va_start(alist, first);
    while ((temp = va_arg(alist, id))) 
        result = [result stringByAppendingString:temp];
    va_end(alist);
    
    return result;
}

+ (void) addList:(NSMutableDictionary *) dic list:(NSArray *) list key:(NSString *) key {
    if (list) {
        NSMutableArray *temp = [NSMutableArray array];
        for (Serializable *item in list) {
            [temp addObject:[item dictionary]];
        }
        [dic setObject:temp forKey:key];
    }
    
}


+ (id) getList:(NSArray *) list  object:(Class) obj
{
   NSMutableArray *temp = [NSMutableArray array];
   if(list.count > 0)
    {     
        for (Serializable * item in list) {
           [temp addObject:[[obj alloc] initWithDictionary:(NSMutableDictionary*)item]];
        }
    }
    return temp;
       
}

+ (void) add:(NSMutableDictionary *) dic value:(id) value key:(NSString *) key {
    if (value) {
        [dic setObject:value forKey:key];
    }
}

+ (id) get:(NSDictionary *) dic key:(NSString *) key {
    id value = [dic objectForKey:key];
    if (value && value != [NSNull null]) {
        return value;
    }
    return nil;
}

+ (NSArray *) convert:(NSArray *) array {
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    for (id item in array) {
        NSDictionary *dic = [item dictionary];
        [list addObject:dic];
        [dic release];
    }
    return list;
}

+ (NSString *) serialize:(id) obj {
    
    Request *request = [[Request alloc] init];
    request.data = obj;
    NSDictionary *dic = [request dictionary];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    [request release];
    
    return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSDictionary *) deserialize:(NSString *)string {
    if (string.length == 0) return [NSDictionary dictionary];
    
    NSError * error = nil;
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

+ (void) setProperties:(NSString *) key value:(id) value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

+ (void) setBoolProperties:(NSString *) key value:(BOOL) value {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+ (void) removeProperties:(NSString *) key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

+ (NSString *) getProperties:(NSString *) key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key];
}

+ (BOOL) getBoolProperties:(NSString *) key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

+ (NSString *) timeFormat: (float) seconds {
    int hours = seconds / 3600;
    int minutes = seconds / 60;
    int sec = fabs(round((int)seconds % 60));
    NSString *ch = hours <= 9 ? @"0": @"";
    NSString *cm = minutes <= 9 ? @"0": @"";
    NSString *cs = sec <= 9 ? @"0": @"";
    return [NSString stringWithFormat:@"%@%i:%@%i:%@%i", ch, hours, cm, minutes, cs, sec];
}

+ (BOOL) isEmpty:(id) data {
    return data == nil || data == [NSNull null]
    || ([data respondsToSelector:@selector(length)]
        && [data length] == 0)
    || ([data respondsToSelector:@selector(count)]
        && [data count] == 0);

}

+ (NSString *) stringByTruncatingToWidth:(NSString *) string width:(CGFloat) width withFont:(UIFont*) font {
    NSString *currentString = @"";
    for (int i = 0; i <= string.length; i++) {
       CGSize currentSize = [currentString sizeWithFont:font];
        if (currentSize.width > width) {
            currentString = [currentString stringByAppendingString:@"..."];
            break;
        }
        currentString = [string substringWithRange:NSMakeRange(0, i)];
    }
        
    return currentString;
}

+ (NSString *) generateName:(int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

// Bhavya - 14th June (Method to convert the date in hr:min:sec format to seconds)
+ (NSNumber *)dateToSecondConvert:(NSString *)string {
    
    NSArray *components = [string componentsSeparatedByString:@":"];
    
    NSInteger hours   = [[components objectAtIndex:0] integerValue];
    NSInteger minutes = [[components objectAtIndex:1] integerValue];
    NSInteger seconds = [[components objectAtIndex:2] integerValue];
    
    return [NSNumber numberWithInteger:(hours * 60 * 60) + (minutes * 60) + seconds];
}


@end