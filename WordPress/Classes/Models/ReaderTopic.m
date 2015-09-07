#import "ReaderTopic.h"
#import "ReaderSite.h"

NSString *const ReaderTopicTypeList = @"list";
NSString *const ReaderTopicTypeTag = @"tag";
NSString *const ReaderTopicTypeSite = @"site";

@implementation ReaderTopic

@dynamic account;
@dynamic isMenuItem;
@dynamic isRecommended;
@dynamic isSubscribed;
@dynamic lastSynced;
@dynamic path;
@dynamic posts;
@dynamic slug;
@dynamic title;
@dynamic topicDescription;
@dynamic topicID;
@dynamic type;

- (BOOL)isList
{
    return [self.type isEqualToString:ReaderTopicTypeList];
}

- (BOOL)isTag
{
    return [self.type isEqualToString:ReaderTopicTypeTag];
}

- (BOOL)isSite
{
    return [self.type isEqualToString:ReaderTopicTypeSite];
}

@end
