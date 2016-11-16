#import <Cocoa/Cocoa.h>


@interface NoodleLineNumberMarker : NSRulerMarker
{
	//NSUInteger		lineNumber;
}

- (instancetype)initWithRulerView:(NSRulerView *)aRulerView lineNumber:(CGFloat)line image:(NSImage *)anImage imageOrigin:(NSPoint)imageOrigin;

@property (NS_NONATOMIC_IOSONLY) NSUInteger lineNumber;


@end
