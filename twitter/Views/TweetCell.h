//
//  TweetCell.h
//  twitter
//
//  Created by rutvims on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_profile;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_username;
@property (weak, nonatomic) IBOutlet UILabel *tweet_date;
@property (weak, nonatomic) IBOutlet UILabel *tweet_text;
@property (weak, nonatomic) IBOutlet UILabel *tweet_replies;
@property (weak, nonatomic) IBOutlet UILabel *tweet_retweets;
@property (weak, nonatomic) IBOutlet UILabel *tweet_likes;
@property (weak, nonatomic) IBOutlet UIButton *reply_button;
@property (weak, nonatomic) IBOutlet UIButton *retweet_button;
@property (weak, nonatomic) IBOutlet UIButton *favor_button;
@property (weak, nonatomic) IBOutlet UIButton *message_button;
@property (strong, nonatomic) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
