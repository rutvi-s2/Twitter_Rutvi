//
//  ComposeViewController.h
//  twitter
//
//  Created by rutvims on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ComposeViewControllerDelegate
- (void) didTweet:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *TweetText;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
