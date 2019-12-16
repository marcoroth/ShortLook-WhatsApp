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
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *identifiers = @[@"group.net.whatsapp.WhatsApp.shared", @"group.net.whatsapp.WhatsAppSMB.shared"];

    for (NSString *identifier in identifiers) {
      NSString *file;
      NSString *profilePicture;
      NSString *containerPath = [FolderFinder findSharedFolder:identifier];
      NSString *picturesPath = [NSString stringWithFormat:@"%@/Media/Profile", containerPath];
      NSDirectoryEnumerator *files = [fileManager enumeratorAtPath:picturesPath];

      while (file = [files nextObject]) {
        NSArray *parts = [file componentsSeparatedByString:@"-"];

        // DMs
        if ([parts count] == 2) {
          if ([chatId isEqualToString:parts[0]]){
            profilePicture = file;
          }
        }

        // Groups
        if ([parts count] == 3) {
          if ([chatId isEqualToString:[NSString stringWithFormat:@"%@-%@", parts[0], parts[1]]]){
            profilePicture = file;
          }
        }

        if (profilePicture) {
          NSString *imagePath = [NSString stringWithFormat:@"%@/%@", picturesPath, profilePicture];
          UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

          return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imagePath image:image];
        }
      }
    }

    return nil;
  }
@end
