//
//  Tweet.m
//  twitter
//
//  Created by rutvims on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet

-(instancetype)initWithDictionary:(NSDictionary *) dictionary{
    // initialize user
    NSDictionary *user = dictionary[@"user"];
    self.user = [[User alloc] initWithDictionary:user];

    self = [super init];
    if(self){
        //is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil){
            NSDictionary *userDictionary = dictionary [@"user"];
//            NSDictionary *userMentionDictionary = dictionary [@"user_mentions"];
            self.retweetedByUser = [ [User alloc] initWithDictionary:userDictionary];
//            self.mentionedByUser = [ [User alloc] initWithDictionary:userMentionDictionary];
            
            //change tweet to original tweet
            dictionary = originalTweet;
            NSLog(@"%@", dictionary);
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary [@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        self.replyCount = [dictionary[@"reply"] intValue];
        
        //format createdAt data string
        NSString *createdAtOriginalString = dictionary [@"created_at"];
        NSDateFormatter *formatter = [ [NSDateFormatter alloc] init];
        //configure input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        //convert string to date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        //configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterShortStyle;
        //convert date to string
        self.createdAtString = [date shortTimeAgoSinceNow];
        self.createdAtStringSpecific = [formatter stringFromDate:date];
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray: (NSArray *) dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries){
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject: tweet];
    }
    return tweets;
}

+ (NSMutableArray *)userTweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *userTweets = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries){
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [userTweets addObject: tweet];
    }
    return userTweets;
}

@end
