//
//  EffectViewController.m
//  cut2it
//
//  Created by Eugene on 10/19/12.
//
//

#import "EffectViewController.h"

@implementation EffectViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Effects";
    NSURL *inputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/sample3.mov"]]];
    self.container.url = inputURL;
    
//    if (player != nil) {        
//        [player.view removeFromSuperview];
//        player = nil;
//        [player release];        
//    }
    
    player = [[MPMoviePlayerController alloc] init];
    player.view.frame = CGRectMake(0, 0, 320, 200);
    [self.view insertSubview:player.view atIndex:0];
    player.controlStyle = MPMovieControlStyleNone;
    
    effect = [[Effect alloc] init];
    effect.delegate = self;
    
    UIBarButtonItem *back = [self createBarButtonWithName:@"Back" image:@"back" width:68 target:self action:@selector(back:)];
    UIBarButtonItem *save = [self createBarButtonWithName:@"Save" image:@"rounded" width:68 target:self action:@selector(save:)];
    
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = save;
    
    [back release];
    [save release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    [effect generateImage:self.container.url handle:^(UIImage *image) {
        self.preview.image = image;
        [self.collectionView reloadData];
    }];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
}

- (void) dealloc {
    [effect release];
    [player release];
    [output release];
    [super dealloc];
}

- (IBAction) back:(id)sender  {
    [effect cancel];
    [super back:sender];
}

- (void) save:(id) sender {
    if (outputIndex == index) {
        [self upload];
    } else {
        upload = YES;
        [effect applyFilter:self.container.url atIndex:index];
        [_indicatorView startAnimating];
        _play.hidden = YES;
        UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
        save.enabled = NO;
    }
}

- (void) upload {
    Media *media = [[Media alloc] init];
    media.title = _name;
    media.description = _desc;
    
    //Bhavya - Commented //Media *created = [self.api createMedia:media];
    Media *created = [self.api createMediaNewWithAnnotation:media :nil status:nil];
    
    [media release];
    
    created.url = output;
    [self.navigationController popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadMedia"
                                                        object: created];
    [created release];
}

- (IBAction) play:(id)sender {
    if (index != 0) {
        [effect applyFilter:self.container.url atIndex:index];
        [_indicatorView startAnimating];
        _play.hidden = YES;
        UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
        save.enabled = NO;
    } else {
        [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _play.hidden = YES;
                             self.preview.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             player.contentURL = self.container.url;
                             [player play];
                         }];
    }
}

- (void) finish:(NSURL *) url index:(int) indx {
    outputIndex = index;
    output = [url retain];
    
    if (upload) {
        upload = NO;
        [self upload];
        return;
    }
    
    [_indicatorView stopAnimating];
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _play.hidden = YES;
                         self.preview.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         player.contentURL = url;
                         [player play];
                         UIButton *save = (UIButton *) self.navigationItem.rightBarButtonItem.customView;
                         save.enabled = YES;
                     }];
}

- (void) playbackDidFinish:(NSNotification*) notification {
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.preview.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                        _play.hidden = NO;
                     }];
}

#pragma mark -
#pragma mark UICollectionViewDataSource Delegate Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger) section {
    return [effect countEffects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbnail_frame"]];
    
    if (self.preview.image) {
        UIImageView *imageView;
        if (indexPath.row == 0) {
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"none_fx"]];
        } else {
            UIImage *image = [effect effectImage:self.preview.image atIndex:indexPath.row];
            imageView = [[UIImageView alloc] initWithImage:image];
        }
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        cell.backgroundView = imageView;
        [imageView release];
        

        
    }
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) cell.backgroundView;
    index = indexPath.row;
    self.preview.highlighted = index != 0;
    self.preview.highlightedImage = imageView.image;
}

@end
