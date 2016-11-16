#import "NoodleLineNumberMarker.h"


@implementation NoodleLineNumberMarker

- (instancetype)initWithRulerView:(NSRulerView *)aRulerView lineNumber:(CGFloat)line image:(NSImage *)anImage imageOrigin:(NSPoint)imageOrigin {
	if ((self = [super initWithRulerView:aRulerView markerLocation:0.0 image:anImage imageOrigin:imageOrigin]) != nil) {
		self.lineNumber = line;
	}
	return self;
}

#pragma mark NSCoding methods

#define NOODLE_LINE_CODING_KEY		@"line"

- (instancetype)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder]) != nil) {
		if ([decoder allowsKeyedCoding]) {
			self.lineNumber = [[decoder decodeObjectForKey:NOODLE_LINE_CODING_KEY] unsignedIntValue];
		} else {
			self.lineNumber = [[decoder decodeObject] unsignedIntValue];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:@(self.lineNumber) forKey:NOODLE_LINE_CODING_KEY];
	} else {
		[encoder encodeObject:@(self.lineNumber)];
	}
}


#pragma mark NSCopying methods

- (id)copyWithZone:(NSZone *)zone {
	id copy;
	
	copy = [super copyWithZone:zone];
	[copy setLineNumber:self.lineNumber];
	
	return copy;
}


@end
