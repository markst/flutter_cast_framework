// Autogenerated from Pigeon (v1.0.8), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import <Foundation/Foundation.h>
@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, StreamType) {
  StreamTypeInvalid = 0,
  StreamTypeNone = 1,
  StreamTypeBuffered = 2,
  StreamTypeLive = 3,
};

typedef NS_ENUM(NSUInteger, MediaType) {
  MediaTypeGeneric = 0,
  MediaTypeMovie = 1,
  MediaTypeTvShow = 2,
  MediaTypeMusicTrack = 3,
  MediaTypePhoto = 4,
  MediaTypeAudiobookChapter = 5,
  MediaTypeUser = 6,
};

typedef NS_ENUM(NSUInteger, TrackType) {
  TrackTypeUnknown = 0,
  TrackTypeText = 1,
  TrackTypeAudio = 2,
  TrackTypeVideo = 3,
};

typedef NS_ENUM(NSUInteger, TrackSubtype) {
  TrackSubtypeUnknown = 0,
  TrackSubtypeNone = 1,
  TrackSubtypeSubtitles = 2,
  TrackSubtypeCaptions = 3,
  TrackSubtypeDescriptions = 4,
  TrackSubtypeChapters = 5,
  TrackSubtypeMetadata = 6,
};

@class MediaLoadRequestData;
@class MediaInfo;
@class MediaMetadata;
@class WebImage;
@class MediaTrack;
@class CastMessage;

@interface MediaLoadRequestData : NSObject
@property(nonatomic, strong, nullable) NSNumber * shouldAutoplay;
@property(nonatomic, strong, nullable) NSNumber * currentTime;
@property(nonatomic, strong, nullable) MediaInfo * mediaInfo;
@end

@interface MediaInfo : NSObject
@property(nonatomic, copy, nullable) NSString * contentId;
@property(nonatomic, assign) StreamType streamType;
@property(nonatomic, copy, nullable) NSString * contentType;
@property(nonatomic, strong, nullable) MediaMetadata * mediaMetadata;
@property(nonatomic, strong, nullable) NSArray<MediaTrack *> * mediaTracks;
@property(nonatomic, strong, nullable) NSNumber * streamDuration;
@property(nonatomic, copy, nullable) NSString * customDataAsJson;
@end

@interface MediaMetadata : NSObject
@property(nonatomic, assign) MediaType mediaType;
@property(nonatomic, strong, nullable) NSArray<WebImage *> * webImages;
@end

@interface WebImage : NSObject
@property(nonatomic, copy, nullable) NSString * url;
@end

@interface MediaTrack : NSObject
@property(nonatomic, strong, nullable) NSNumber * id;
@property(nonatomic, assign) TrackType trackType;
@property(nonatomic, copy, nullable) NSString * name;
@property(nonatomic, assign) TrackSubtype trackSubtype;
@property(nonatomic, copy, nullable) NSString * contentId;
@property(nonatomic, copy, nullable) NSString * language;
@end

@interface CastMessage : NSObject
@property(nonatomic, copy, nullable) NSString * namespace;
@property(nonatomic, copy, nullable) NSString * message;
@end

/// The codec used by CastHostApi.
NSObject<FlutterMessageCodec> *CastHostApiGetCodec(void);

@protocol CastHostApi
- (void)sendMessageMessage:(CastMessage *)message error:(FlutterError *_Nullable *_Nonnull)error;
- (void)showCastDialogWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)loadMediaLoadRequestDataRequest:(MediaLoadRequestData *)request error:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void CastHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<CastHostApi> *_Nullable api);

/// The codec used by CastFlutterApi.
NSObject<FlutterMessageCodec> *CastFlutterApiGetCodec(void);

@interface CastFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)getSessionMessageNamespacesWithCompletion:(void(^)(NSArray<NSString *> *, NSError *_Nullable))completion;
- (void)onCastStateChangedCastState:(NSNumber *)castState completion:(void(^)(NSError *_Nullable))completion;
- (void)onMessageReceivedMessage:(CastMessage *)message completion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionStartingWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionStartedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionStartFailedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionEndingWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionEndedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionResumingWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionResumedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionResumeFailedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSessionSuspendedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onStatusUpdatedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onMetadataUpdatedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onQueueStatusUpdatedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onPreloadStatusUpdatedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onSendingRemoteMediaRequestWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onAdBreakStatusUpdatedWithCompletion:(void(^)(NSError *_Nullable))completion;
- (void)onMediaErrorWithCompletion:(void(^)(NSError *_Nullable))completion;
@end
NS_ASSUME_NONNULL_END
