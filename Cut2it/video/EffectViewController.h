//
//  EffectViewController.h
//  cut2it
//
//  Created by Eugene on 10/19/12.
//
//

#import "BaseViewController.h"
#import "Effect.h"

@interface EffectViewController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, EffectDelegate> {
    MPMoviePlayerController *player;
    Effect *effect;
    BOOL upload;
    int index;
    int outputIndex;
    NSURL *output;
}

@property (retain, nonatomic) IBOutlet UIImageView *preview;
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet UIButton *play;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *desc;

- (IBAction)play:(id)sender;

@end
