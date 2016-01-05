//
//  ContentViewCell.m
//  Undrel
//
//  Created by Mukesh Sharma on 11/16/12.
//  Copyright (c) 2012 Mukesh Sharma. All rights reserved.
//

#import "ContentViewCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation ContentViewCell




@synthesize imageVw,detaillbl,detailDescriptionLabel;
/*
 - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
 {
 self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 if (self) {
 // Initialization code
 }
 return self;
 }*/



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier indexes:(NSIndexPath*)indexPath{
    
    //self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        CGRect  imgeframe = CGRectMake(0, 6, 100, 50);
        imageVw = [[UIImageView alloc] init];
        imageVw.frame = imgeframe;
        imageVw.layer.cornerRadius = 5.0f;
        imageVw.opaque = NO;
        imageVw.alpha =1.0;
        [self addSubview:imageVw];
        
        
        
        CGRect lableFrame = CGRectMake(100, 0, 185, 25);
        detaillbl = [[UILabel alloc] init];
        detaillbl.frame = lableFrame;
        detaillbl.numberOfLines = 3;
        detaillbl.font = [UIFont boldSystemFontOfSize:14];
        detaillbl.backgroundColor = [UIColor clearColor];
        detaillbl.opaque = NO;
        detaillbl.alpha =1.0;
        [self addSubview:detaillbl];
        
        CGRect detailLabelFrame = CGRectMake(100, 25, 185, 35);
        detailDescriptionLabel = [[UILabel alloc] init];
        detailDescriptionLabel.frame = detailLabelFrame;
        detailDescriptionLabel.numberOfLines = 3;
        detailDescriptionLabel.font = [UIFont systemFontOfSize:12];
        detailDescriptionLabel.backgroundColor = [UIColor clearColor];
        detailDescriptionLabel.textColor =[UIColor lightGrayColor] ;
        detailDescriptionLabel.opaque = NO;
        detailDescriptionLabel.alpha =1.0;
        [self addSubview:detailDescriptionLabel];
        
    }
    return  self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
