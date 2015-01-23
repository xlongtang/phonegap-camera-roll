#import "CameraRoll.h"
#import <Cordova/CDV.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CameraRoll


- (void) count:(CDVInvokedUrlCommand*)command {

    BOOL includePhotos   = [command.arguments objectAtIndex:0];
    BOOL includeVideos   = [command.arguments objectAtIndex:1];

    ALAssetsFilter *filter;
    if (includePhotos && includeVideos) {
        filter = [ALAssetsFilter allAssets];
    } else if (includePhotos) {
        filter = [ALAssetsFilter allPhotos];
    } else if (includeVideos) {
        filter = [ALAssetsFilter allVideos];
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }

    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    int __block numAssets = 0;
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               if (group) {
                                   [group setAssetsFilter:filter];
                                   numAssets += group.numberOfAssets;
                               }
                               CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:numAssets];
                               [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                           }

                         failureBlock:^(NSError *err) {
                             CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
                             [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                         }];
}


- (void) find:(CDVInvokedUrlCommand*)command {
    NSInteger max = [[command.arguments objectAtIndex:0] integerValue];
    double startTimeTick = [[command.arguments objectAtIndex:1] doubleValue];
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:startTimeTick];
    __block NSDate *latestTime = startTime;
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *photoUrls = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            if (group == nil) {
                                return;
                            }
                            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *innerStop) {
                                if (result == nil) {
                                    return;
                                }
                                
                                NSDate * date = [result valueForProperty:ALAssetPropertyDate];
                                if ([startTime compare:date] == NSOrderedDescending) {
                                    *innerStop = YES;
                                    return;
                                }
                                
                                if ([date compare:latestTime] == NSOrderedDescending) {
                                    latestTime = date;
                                }
                                
                                NSURL *urld = (NSURL*) [[result defaultRepresentation]url];
                                NSData *imageData = [NSData dataWithContentsOfURL:urld];
                                NSString *base64EncodedImage = [imageData base64EncodedString];

                                [photos addObject:base64EncodedImage];
                                [photoUrls addObject:urld];
                                if (photos.count == max) {
                                    *innerStop = YES;
                                }
                            }];

                            if (photos.count > 0) {
                              // Building return data
                                NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:3];
                                [resultDict setObject:photos forKey:@"photos"];
                                [resultDict setObject:photoUrls forKey:@"urls"];
                                double latestTimeTick = [latestTime timeIntervalSince1970];
                                [resultDict setObject:[NSNumber numberWithDouble:latestTimeTick] forKey:@"timestamp"];
                              CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            } else {
                              CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                              [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            }
                        } failureBlock:^(NSError *error) {
                            NSLog(@"%@", [error localizedDescription]);
                            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                        }];
}

@end
