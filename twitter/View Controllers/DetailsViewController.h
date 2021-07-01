//
//  DetailsViewController.h
//  twitter
//
//  Created by rutvims on 6/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TimelineViewController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DetailViewControllerDelegate
- (void) tweetUpdate:(Tweet *)tweet;
@end

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) TimelineViewController *specific;
@property (weak, nonatomic) IBOutlet UIButton *retweet_top;
@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
