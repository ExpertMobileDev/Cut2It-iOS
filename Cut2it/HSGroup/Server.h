//
//  Server.h
//
//  Created by Anand Kumar on 18/01/13.
//  Copyright (c) 2013 Anand Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface Server : NSObject<FBSessionDelegate> {
    NSOperationQueue *queue;
    NSMutableArray *array;
    NSMutableDictionary *dictionary;
    NSString *currentElementValue;
    NSString *maintag;
    NSString *subtag;
    Facebook* _facebook;
    NSArray* _permissions;
    NSString* _token;
    NSString *_uid;
    NSString *_picurl;
   	
	//NSString *resultString;
    NSMutableDictionary *userPermissions;

}
@property (nonatomic, retain) Facebook* _facebook;
@property (nonatomic, retain) NSArray* _permissions;
@property (nonatomic, retain) NSString* _token;
@property (nonatomic, retain) NSString* _uid;
@property (nonatomic, retain) NSString* _picurl;

@property (nonatomic, retain) NSMutableDictionary *userPermissions;

+(Server*)sharedServer;
@end