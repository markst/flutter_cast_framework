// Autogenerated from Pigeon (v1.0.8), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

@class CastMessage;

@interface CastMessage : NSObject
@property(nonatomic, copy, nullable) NSString * namespace;
@property(nonatomic, copy, nullable) NSString * message;
@end

/// The codec used by CastApi.
NSObject<FlutterMessageCodec> *CastApiGetCodec(void);

@protocol CastApi
- (void)sendMessageMessage:(CastMessage *)message error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void CastApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<CastApi> *_Nullable api);

NS_ASSUME_NONNULL_END
