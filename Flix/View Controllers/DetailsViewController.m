//
//  DetailsViewController.m
//  Flix
//
//  Created by Raghav Sreeram on 6/10/21.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *fullImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"At details view!");
    [self.fullImage setAlpha:0.0];

    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURL = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURL];
    [self.posterView setImageWithURL:posterURL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
//    NSString *fullBackdropURL = [baseURLString stringByAppendingString:backdropURLString];
    
    //lower image to higher image
    NSURL *urlSmall = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/w45" stringByAppendingString:backdropURLString]];
    NSURL *urlLarge = [NSURL URLWithString:[@"https://image.tmdb.org/t/p/original" stringByAppendingString:backdropURLString]];

    NSURLRequest *requestSmall = [NSURLRequest requestWithURL:urlSmall];
    NSURLRequest *requestLarge = [NSURLRequest requestWithURL:urlLarge];
    
    __weak DetailsViewController *weakSelf = self;

    [weakSelf.backdropView setImageWithURLRequest:requestSmall
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *smallImage) {
                                       
                                       // smallImageResponse will be nil if the smallImage is already available
                                       // in cache (might want to do something smarter in that case).
                                       weakSelf.backdropView.alpha = 0.0;
                                       weakSelf.backdropView.image = smallImage;
       
                                       
                                       [UIView animateWithDuration:0.3
                                                        animations:^{
                                                            
                                                            weakSelf.backdropView.alpha = 1.0;
                                                            
                                                        } completion:^(BOOL finished) {
                                                            // The AFNetworking ImageView Category only allows one request to be sent at a time
                                                            // per ImageView. This code must be in the completion block.
                                                            [weakSelf.backdropView setImageWithURLRequest:requestLarge
                                                                                  placeholderImage:smallImage
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage * largeImage) {
                                                                                                weakSelf.backdropView.image = largeImage;
                                                                weakSelf.fullImage.image = largeImage;
                                                                                  }
                                                                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               // do something for the failure condition of the large image request
                                                                                               // possibly setting the ImageView's image to a default image
                                                                                           }];
                                                        }];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];
    
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}

- (IBAction)tappedOpenImage:(id)sender {
    [self.scrollView setAlpha:0.0];
    [self.fullImage setAlpha:1.0];
    
}


- (IBAction)tapCloseImage:(id)sender {
    [self.scrollView setAlpha:1.0];
    [self.fullImage setAlpha:0.0];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    NSNumber *movieID = self.movie[@"id"];
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movieID = movieID;

}

@end
