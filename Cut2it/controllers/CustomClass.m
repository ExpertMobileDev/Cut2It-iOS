//
//  CustomClass.m
//  cut2it
//
//  Created by Anand Kumar on 01/02/13.
//
//

#import "CustomClass.h"
#import "Annotation.h"

@implementation CustomClass
@synthesize coustomAnnotaions;

//static CustomClass *coustomShared;

+(CustomClass*)sharedServer{
    
    static dispatch_once_t pred;
    static CustomClass *coustomShared = nil;
    dispatch_once(&pred, ^{
        coustomShared = [[CustomClass alloc] init];
        coustomShared.coustomAnnotaions = [[NSMutableArray alloc]init];
    });
    
    return coustomShared;
    
}

- (NSMutableArray*) addAnnotation:(Annotation *) annotation {
    NSLog(@"addAnnotation_Custom");
    NSLog(@"self.coustomAnnotaions_Count:%i",self.coustomAnnotaions.count);
    if(self.coustomAnnotaions&& [self.coustomAnnotaions count]>0)
    {
        NSLog(@"TotalCoustomAnnot:%@",[self.coustomAnnotaions description]);
    }
    
    for (Annotation *a in self.coustomAnnotaions) {
        if ([a.pk isEqualToNumber:annotation.pk]) {
            [self.coustomAnnotaions removeObject:a];
            break;
        }
    }
    
    int index = 0;
    BOOL isAddToEnd  = TRUE;
    for (Annotation *a in self.coustomAnnotaions) {
        if (a.begin > annotation.begin) {
            [self.coustomAnnotaions insertObject:annotation atIndex:index];
            isAddToEnd = FALSE;
            break;
        }
        index ++;
    }
    if(isAddToEnd == TRUE)
    {
        [self.coustomAnnotaions addObject:annotation];
    }
    
    return coustomAnnotaions;
}



@end