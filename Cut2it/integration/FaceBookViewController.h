//
//  FaceBookViewController.h
//  Undrel
//
//  Created by Mukesh Sharma on 10/31/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
//#import "ServerClass.h"

@interface FaceBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIView *contentView;
     NSDictionary *postDict;
}

@property(nonatomic,retain)NSDictionary *postDict;
@property(nonatomic,retain)NSString *postUrlString;
@property(nonatomic,retain)NSArray *QuestionOptionsArray;
@property(nonatomic,retain)NSDictionary *imageDictionary;
@property(nonatomic,retain)IBOutlet UITableView *contentTableView;
@property(nonatomic,retain)NSDictionary<FBGraphUser> *fbuserDict;
//@property(nonatomic,retain) ServerClass *singletonServerClass;
-(void)removepopView:(id)sender;
-(void)sharetoSybrit;
@end
