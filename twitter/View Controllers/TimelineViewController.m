//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, DetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (strong, nonatomic) NSMutableArray *userArrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL moreDataLeft;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.moreDataLeft = false;
    [self getTimeline];

    self.refreshControl = [[UIRefreshControl alloc] init];

    [self.refreshControl addTarget:self action:@selector(getTimeline) forControlEvents:UIControlEventValueChanged];

    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)getTimeline{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.arrayOfTweets = (NSMutableArray *)tweets;
//            NSLog(@"%lu", self.arrayOfTweets.count);
            NSLog(@"%lu", tweets.count);
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%lu", self.arrayOfTweets.count);
    return self.arrayOfTweets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;

    cell.user_username.text = [@"@" stringByAppendingString: cell.tweet.user.screenName];
    cell.user_name.text = tweet.user.name;
    cell.tweet_date.text = tweet.createdAtString;
    cell.tweet_text.text = tweet.text;

    if(cell.tweet.retweetedByUser.name != NULL){
        [cell.retweet_top setHidden:NO];
        [cell.retweet_top setTitle: [cell.tweet.retweetedByUser.name stringByAppendingString:@" retweeted"] forState:UIControlStateNormal];
    }else{
        [cell.retweet_top setHidden:YES];
    }
    cell.user_profile.image = nil;
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [cell.user_profile setImageWithURL:url];

    if (cell.tweet.favorited == YES){
        [cell.favor_button setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }else{
        [cell.favor_button setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    if(cell.tweet.retweeted == YES){
        [cell.retweet_button setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }else{
        [cell.retweet_button setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }

    cell.tweet_replies.text = [NSString stringWithFormat:@"%d", tweet.replyCount];
    cell.tweet_likes.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.tweet_retweets.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];

    return cell;
}

- (void) didTweet:(Tweet *)tweet{
    [self.arrayOfTweets addObject:tweet];
    NSLog(@"%@", @"added");
    //[self.tableView reloadData];
    [self getTimeline];
}

- (void) loadMoreTweets{
    Tweet *lastTweet = self.arrayOfTweets[self.arrayOfTweets.count - 1];
    NSString *maxId = lastTweet.idStr;
    [[APIManager shared] getMoreTweetsWithCompletion:maxId completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            [self.arrayOfTweets addObjectsFromArray:tweets];

            NSLog(@"%lu", tweets.count);
            NSLog(@"😎😎😎 Successfully loaded home timeline");

            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
            self.moreDataLeft = false;
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void) tweetUpdate:(Tweet *)tweet{
    [self getTimeline];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.moreDataLeft){
        int height = self.tableView.contentSize.height;
        int threshold = height - self.tableView.bounds.size.height;
        
        
        if(scrollView.contentOffset.y > threshold &&(self.tableView.isDragging)){
            self.moreDataLeft = true;
            [self loadMoreTweets];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"composeTweet"]){
        UINavigationController const *navigationController = [segue destinationViewController];
        ComposeViewController const *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;

        UITableViewCell *tappedCell = sender;
        NSIndexPath const *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];
        composeController.tweet = tweet;
    }else{
        UITableViewCell *tappedCell = sender;
        NSIndexPath const *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.arrayOfTweets[indexPath.row];

        DetailsViewController const *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        detailsViewController.delegate = self;
    }

}


@end
