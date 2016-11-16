#import <Cocoa/Cocoa.h>

@class NoodleLineNumberMarker;

@protocol MarkerLineNumberDelegate  <NSObject>
- (void)lineMarkerChanged;

@end

@interface NoodleLineNumberView : NSRulerView
{
    // Array of character indices for the beginning of each line
    NSMutableArray      *lineIndices;
	// Maps line numbers to markers
	NSMutableDictionary	*linesToMarkers;
	NSFont              *font;
	NSColor				*textColor;
	NSColor				*alternateTextColor;
	NSColor				*backgroundColor;
}

- (instancetype)initWithScrollView:(NSScrollView *)aScrollView;

@property id <MarkerLineNumberDelegate> delegate;

@property (NS_NONATOMIC_IOSONLY, copy) NSFont *font;

@property (NS_NONATOMIC_IOSONLY, copy) NSColor *textColor;

@property (NS_NONATOMIC_IOSONLY, copy) NSColor *alternateTextColor;

@property (NS_NONATOMIC_IOSONLY, copy) NSColor *backgroundColor;

- (NSUInteger)lineNumberForLocation:(CGFloat)location;
- (NoodleLineNumberMarker *)markerAtLine:(unsigned)line;
- (NSArray*) markedLines;

@end
