//
//  User.m
//  twitter
//
//  Created by rutvims on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)initWithDictionary:(NSDictionary *) dictionary{
    self = [super init];
    if(self){
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.backgroundPicture = dictionary[@"profile_banner_url"];
        self.following = [dictionary[@"friends_count"] intValue];
        self.followers = [dictionary[@"followers_count"] intValue];
        self.descriptionTweet = dictionary[@"description"];
    }
    return self;
}

@end
