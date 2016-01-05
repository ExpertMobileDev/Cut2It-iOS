//
//  CustomClass.h
//  cut2it
//
//  Created by Anand Kumar on 01/02/13.
//
//

#import <Foundation/Foundation.h>

@interface CustomClass : NSObject
{
    NSMutableArray *coustomAnnotaions;
}
@property(nonatomic,retain)NSMutableArray *coustomAnnotaions;

+(CustomClass*)sharedServer;
@end
