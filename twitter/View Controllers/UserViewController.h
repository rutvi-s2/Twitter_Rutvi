//
//  UserViewController.h
//  twitter
//
//  Created by rutvims on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *fullProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetNumber;
@property (weak, nonatomic) IBOutlet UILabel *followerNumber;
@property (weak, nonatomic) IBOutlet UILabel *followingNumber;

@end

NS_ASSUME_NONNULL_END
