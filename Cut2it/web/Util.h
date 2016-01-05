//
//  Util.h
//  Cut2it
//
//  Created by Eugene Maystrenko on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Util : NSObject

+ (BOOL) isIOS5;
+ (BOOL) isNumber:(NSString *) string;
+ (void) add:(NSMutableDictionary *) dic value:(id) value key:(NSString *) key;
+ (void) addList:(NSMutableDictionary *) dic list:(NSArray *) list key:(NSString *) key;
+ (id) getList:(NSArray *) list  object:(Class) obj;
+ (id) get:(NSDictionary *) dic key:(NSString *) key;
+ (NSString *) append:(id) first, ... ;
+ (NSArray *) convert:(NSArray *) array;
+ (NSString *) serialize:(id) data ;
+ (NSDictionary *) deserialize:(NSString *)string;

+ (void) setProperties:(NSString *) key value:(id) value;
+ (void) setBoolProperties:(NSString *) key value:(BOOL) value;
+ (void) removeProperties:(NSString *) key;
+ (NSString *) getProperties:(NSString *) key;
+ (BOOL) getBoolProperties:(NSString *) key;

+ (NSString *) timeFormat: (float) seconds;
+ (BOOL) isEmpty:(id) data;
+ (NSString*) stringByTruncatingToWidth:(NSString *) string width:(CGFloat) width withFont:(UIFont*) font;
+ (NSString *) generateName:(int) len;
+ (NSNumber *)dateToSecondConvert:(NSString *)string;

//+ (void)setFbcomment:(NSString*)comment;
//+ (void)getFbcomment:(NSString*)comment;
@end