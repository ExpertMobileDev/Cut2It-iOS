//
//  LoadingView.h
//  cut2it
//
//  Created by Anand Kumar on 19/02/13.
//
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIViewController{
    UIActivityIndicatorView *spinner;
    UILabel *loadingLabel;
	UIImageView *loadingImgView;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic,retain) IBOutlet UIImageView *loadingImgView;


@end
