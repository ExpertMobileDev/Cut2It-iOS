//
//  AsynImageView.h
//  BonVitas
//
//  Created by Sayali Doshi on 18/12/12.
//
//

#import <UIKit/UIKit.h>

@interface AsynImageView : UIImageView
{
    NSURLConnection *connection;
    NSMutableData *data;
}

- (void)loadImageFromURLString:(NSString *)theUrlString;

@end
