//
//  ContentViewCell.h
//  Undrel
//
//  Created by Mukesh Sharma on 11/16/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewCell : UITableViewCell
{
    UIImageView *imageVw;
    UILabel *detaillbl;
    
}
@property(nonatomic,retain)UIImageView *imageVw;
@property(nonatomic,retain)UILabel *detaillbl;
@property(nonatomic,retain)UILabel *detailDescriptionLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexes:(NSIndexPath*)indexPath;
@end

