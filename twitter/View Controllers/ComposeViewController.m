//
//  ComposeViewController.m
//  twitter
//
//  Created by rutvims on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.TweetText.placeholder = @"Type Something Here...";
    self.TweetText.placeholderColor = [UIColor lightGrayColor];
    self.TweetText.layer.borderColor = [[UIColor grayColor] CGColor];
    self.TweetText.layer.borderWidth = 1.0;
    self.TweetText.layer.cornerRadius = 8;
    
    self.userID.text = [@"@" stringByAppendingString: self.tweet.user.screenName];
    self.userName.text = self.tweet.user.name;
    
    //self.profileImage = nil;
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    [self.profileImage setImageWithURL:url];

}
- (IBAction)tweetButton:(id)sender {
    [[APIManager shared] postStatusWithText:self.TweetText.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
    
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
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
