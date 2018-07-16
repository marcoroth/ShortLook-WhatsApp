#import "WhatsAppContactPhotoProvider.h"

@interface NCNotificationRequest
  -(NSString *)threadIdentifier;
@end

@implementation WhatsAppContactPhotoProvider

- (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NCNotificationRequest *request = [notification request];
    NSString *threadId = [request threadIdentifier];
    NSString *phonenumber = [threadId componentsSeparatedByString:@"@"][0];

    NSMutableString *path = [NSMutableString new];

    [path appendString:@"/var/mobile/Containers/Data/Application/"];
    [path appendString:@"9BA71641-253E-450C-AE43-10A51DD7BD4F"];
    [path appendString: @"/Library/Caches/spotlight-profile-v2/"];
    [path appendString:phonenumber];
    [path appendString:@"@s-whatsapp-net.png"];

    UIImage *image = [UIImage imageWithContentsOfFile:path];

    return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:phonenumber image:image];
}

@end
