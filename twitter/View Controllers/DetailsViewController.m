//
//  DetailsViewController.m
//  twitter
//
//  Created by rutvims on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *user_profile;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_username;
@property (weak, nonatomic) IBOutlet UILabel *tweet_date;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *likes_number;
@property (weak, nonatomic) IBOutlet UILabel *retweet_number;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.user_username.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.user_name.text = self.tweet.user.name;
    self.tweet_date.text = self.tweet.createdAtString;
    self.tweet_text.text = self.tweet.text;
    self.retweet_number.text = [[NSString stringWithFormat:@"%d", self.tweet.retweetCount] stringByAppendingString:@" RETWEETS"];
    self.likes_number.text =  [[NSString stringWithFormat:@"%d", self.tweet.favoriteCount] stringByAppendingString:@" FAVORITES"];

    
    if(self.tweet.retweetedByUser.name != NULL){
        [self.retweet_top setHidden:NO];
        [self.retweet_top setTitle: [self.tweet.retweetedByUser.name stringByAppendingString:@" retweeted"] forState:UIControlStateNormal];
    }else{
        [self.retweet_top setHidden:YES];
    }
    self.user_profile.image = nil;
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.user_profile setImageWithURL:url];
    
    if (self.tweet.favorited == YES){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    }
    if(self.tweet.retweeted == YES){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    }
    
}
- (IBAction)didTapLike:(id)sender {
    NSLog(@"%@", @"hellllllo");
    NSLog(@"%@", self.tweet.text);
    self.tweet.favorited = !self.tweet.favorited;
    if(self.tweet.favorited == YES){
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateNormal];
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
                [self.delegate tweetUpdate: self.tweet];
            }
        }];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", self.tweet.text);
                [self.delegate tweetUpdate: self.tweet];
            }
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    self.tweet.retweeted = !self.tweet.retweeted;
    if(self.tweet.retweeted == YES){
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
        self.tweet.retweetCount += 1;
        self.tweet.retweetedByUser.name = self.tweet.idStr;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", self.tweet.text);
                [self.delegate tweetUpdate: self.tweet];
                
            }
        }];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeting the following Tweet: %@", self.tweet.text);
                [self.delegate tweetUpdate: self.tweet];
            }
        }];
    }
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
