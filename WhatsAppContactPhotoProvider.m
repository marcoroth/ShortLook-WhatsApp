#import "WhatsAppContactPhotoProvider.h"

@interface NCNotificationRequest
  -(NSString *)threadIdentifier;
@end

@interface FBApplicationInfo
  -(NSURL *)dataContainerURL;
@end

@interface LSApplicationProxy
  +(id)applicationProxyForIdentifier:(id)arg1;
@end

@implementation WhatsAppContactPhotoProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    FBApplicationInfo *appinfo = [LSApplicationProxy applicationProxyForIdentifier:@"net.whatsapp.WhatsApp"];
    NCNotificationRequest *request = [notification request];
    NSString *threadId = [request threadIdentifier];
    NSString *phoneNumber = [threadId componentsSeparatedByString:@"@"][0];
    NSMutableString *imageURL = [NSMutableString new];
    NSString *containerURL = [[appinfo dataContainerURL] absoluteString];

    [imageURL appendString:containerURL];
    [imageURL appendString:@"/Library/Caches/spotlight-profile-v2/"];
    [imageURL appendString:phoneNumber];
    [imageURL appendString:@"@s-whatsapp-net.png"];
    imageURL = [imageURL stringByReplacingOccurrencesOfString:@"file://" withString:@""];

    UIImage *image = [UIImage imageWithContentsOfFile:imageURL];

    return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imageURL image:image];
  }
@end
