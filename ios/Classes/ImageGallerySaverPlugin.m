#import "ImageGallerySaverPlugin.h"


@interface ImageGallerySaverPlugin ()
@property (nonatomic, copy) FlutterResult result;
@end

@implementation ImageGallerySaverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"image_gallery_saver"
              binaryMessenger:[registrar messenger]];
    ImageGallerySaverPlugin* instance = [[ImageGallerySaverPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"saveImageToGallery" isEqualToString:call.method]) {
        self.result = result;
        FlutterStandardTypedData *typeData = call.arguments;
        if (![typeData isKindOfClass:[FlutterStandardTypedData class]]) {
            result(@(NO));
            return;
        }
        NSData *data = typeData.data;
        UIImage *image = [UIImage imageWithData:data];
        if (![image isKindOfClass:[UIImage class]]) {
            result(@(NO));
            return;
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    } else if ([@"saveFileToGallery" isEqualToString:call.method]) {
        self.result = result;
        NSString *path = call.arguments;
        if (![path isKindOfClass:[NSString class]]) {
            result(@(NO));
            return;
        }
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (self.result) {
        self.result(@(error == nil));
    }
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (self.result) {
        self.result(@(error == nil));
    }
}
@end
