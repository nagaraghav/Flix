//
//  TrailerViewController.m
//  Flix
//
//  Created by Raghav Sreeram on 6/11/21.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSArray *movieVideos;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchTrailer];
}


- (void)fetchTrailer {
    NSString *firstPartURL = @"https://api.themoviedb.org/3/movie/";
    NSString *stringMovieID = [self.movieID stringValue];
    NSString *secondPartURL = [firstPartURL stringByAppendingString:stringMovieID];
    NSString *finalURL = [secondPartURL stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURL *url = [NSURL URLWithString: finalURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
                
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.movieVideos = dataDictionary[@"results"];
               NSArray *extracted = [self.movieVideos valueForKey:@"key"];
//               NSLog(@"%@", extracted);
               NSArray *key = [extracted subarrayWithRange:NSMakeRange(0,1)];
//               NSLog(@"%@", key);
               NSString * result = [key componentsJoinedByString:@""];
               NSLog(@"%@", result);
               self.key = result;
               
               NSString *urlString = [@"https://www.youtube.com/watch?v=" stringByAppendingFormat:@"%@", self.key];
               // Convert the url String to a NSURL object.
               NSURL *url = [NSURL URLWithString:urlString];

               // Place the URL in a URL Request.
               NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               // Load Request into WebView.
               [self.webView loadRequest:request];
               

               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
           }
       }];
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
