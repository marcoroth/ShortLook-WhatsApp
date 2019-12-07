#import "FolderFinder.h"
#import "WhatsAppContactPhotoProvider.h"

@interface NCNotificationRequest
  -(NSString *)threadIdentifier;
@end

@implementation WhatsAppContactPhotoProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NCNotificationRequest *request = [notification request];
    NSString *threadId = [request threadIdentifier];
    NSString *chatId = [threadId componentsSeparatedByString:@"@"][0];
    NSString* containerURL = [FolderFinder findSharedFolder:@"group.net.whatsapp.WhatsAppSMB.shared"];
    containerURL = [NSString stringWithFormat:@"%@/Media/Profile", containerURL];

    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *files = [fileManager enumeratorAtPath:containerURL];

    NSString *file;
    NSString *profilePicture;

    while ((file = [files nextObject])) {
      NSArray *parts = [file componentsSeparatedByString:@"-"];

      // DMs
      if ([parts count] == 2){
        if ([chatId isEqualToString:parts[0]]){
          profilePicture = file;
        }
      }

      // Groups
      if ([parts count] == 3){
        if ([chatId isEqualToString:[NSString stringWithFormat:@"%@-%@", parts[0], parts[1]]]){
          profilePicture = file;
        }
      }
    }

    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", containerURL, profilePicture];
    UIImage *image = [UIImage imageWithContentsOfFile:imageURL];

    return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imageURL image:image];
  }
@end
