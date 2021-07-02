//
//  UserViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "UserViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface UserViewController () <ComposeViewControllerDelegate, DetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *userArrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.followerNumber.layer.borderColor = [UIColor grayColor].CGColor;
    self.followingNumber.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.followerNumber.layer.borderWidth = 0.5;
    self.followingNumber.layer.borderWidth = 0.5;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getUserTimeline];

    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(getUserTimeline) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)getUserTimeline{
    // Get timeline
    [[APIManager shared] getProfileTimeline:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.userArrayOfTweets = (NSMutableArray *)tweets;
            [self.tableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting user timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.userArrayOfTweets.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.userArrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    
    cell.user_username.text = [@"@" stringByAppendingString: cell.tweet.user.screenName];
    cell.user_name.text = tweet.user.name;
    cell.tweet_date.text = tweet.createdAtString;
    cell.tweet_text.text = tweet.text;
    
    self.followerNumber.text = [[NSString stringWithFormat:@"%d", tweet.user.followers] stringByAppendingString:@" followers"];
    self.followingNumber.text = [[NSString stringWithFormat:@"%d", tweet.user.following]stringByAppendingString:@" following"];
    self.descriptionLabel.text = tweet.user.descriptionTweet;
    
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
    
    NSString *URLBackgroundString = tweet.user.backgroundPicture;
    NSURL *backurl = [NSURL URLWithString:URLBackgroundString];
    [self.fullProfileImage setImageWithURL:backurl];
    
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
    [self.userArrayOfTweets addObject:tweet];
    [self getUserTimeline];
}

- (void) tweetUpdate:(Tweet *)tweet{
    [self getUserTimeline];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"composeTweet"]){
        UINavigationController  *navigationController = [segue destinationViewController];
        ComposeViewController  *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
        UITableViewCell *tappedCell = sender;
        NSIndexPath  *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.userArrayOfTweets[indexPath.row];
        composeController.tweet = tweet;
    }else{
        UITableViewCell *tappedCell = sender;
        NSIndexPath  *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.userArrayOfTweets[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
        detailsViewController.delegate = self;
    }
    
}


@end
