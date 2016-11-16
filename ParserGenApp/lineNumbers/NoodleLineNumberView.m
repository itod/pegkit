//
//  NoodleLineNumberView.m
//  NoodleKit
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
#import "NoodleLineNumberView.h"
#import "NoodleLineNumberMarker.h"

#define DEFAULT_THICKNESS	22.0
#define RULER_MARGIN		5.0

@interface NoodleLineNumberView (Private)

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSMutableArray *lineIndices;
- (void)invalidateLineIndices;
- (void)calculateLines;
- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index inText:(NSString *)text;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *textAttributes;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *markerTextAttributes;

@end

@implementation NoodleLineNumberView

- (instancetype)initWithScrollView:(NSScrollView *)aScrollView {
    if ((self = [super initWithScrollView:aScrollView orientation:NSVerticalRuler]) != nil) {
		linesToMarkers = [[NSMutableDictionary alloc] init];
		
        [self setClientView:[aScrollView documentView]];
    }
    return self;
}

- (void)awakeFromNib {
	linesToMarkers = [[NSMutableDictionary alloc] init];
	[self setClientView:[[self scrollView] documentView]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFont:(NSFont *)aFont {
    if (font != aFont) {
		font = aFont;
    }
}

- (NSFont *)font {
	if (font == nil) {
		return [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]];
	}
    return font;
}

- (void)setTextColor:(NSColor *)color {
	if (textColor != color) {
		textColor  = color;
	}
}

- (NSColor *)textColor {
	if (textColor == nil) {
		return [NSColor colorWithCalibratedWhite:0.42 alpha:1.0];
	}
	return textColor;
}

- (void)setAlternateTextColor:(NSColor *)color {
	if (alternateTextColor != color) {
		alternateTextColor = color;
	}
}

- (NSColor *)alternateTextColor {
	if (alternateTextColor == nil) {
		return [NSColor whiteColor];
	}
	return alternateTextColor;
}

- (void)setBackgroundColor:(NSColor *)color {
	if (backgroundColor != color) {
		backgroundColor = color;
	}
}

- (NSColor *)backgroundColor {
	return backgroundColor;
}

- (void)setClientView:(NSView *)aView {
	id oldClientView;
	
	oldClientView = [self clientView];
	
    if ((oldClientView != aView) && [oldClientView isKindOfClass:[NSTextView class]]) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)oldClientView textStorage]];
    }
    
    [super setClientView:aView];
    if ((aView != nil) && [aView isKindOfClass:[NSTextView class]]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextStorageDidProcessEditingNotification object:[(NSTextView *)aView textStorage]];

		[self invalidateLineIndices];
    }
}

- (NSMutableArray *)lineIndices {
	if (lineIndices == nil) {
		[self calculateLines];
	}
	return lineIndices;
}

- (void)invalidateLineIndices {
	lineIndices = nil;
}

- (void)textDidChange:(NSNotification *)notification {
	// Invalidate the line indices. They will be recalculated and recached on demand.
	[self invalidateLineIndices];
	
    [self setNeedsDisplay:YES];
}

- (NSUInteger)lineNumberForLocation:(CGFloat)location {
	NSUInteger		line, count, index, rectCount, i;
	NSRectArray		rects;
	NSRect			visibleRect;
	NSLayoutManager	*layoutManager;
	NSTextContainer	*container;
	NSRange			nullRange;
	NSMutableArray	*lines;
	id				view;
		
	view = [self clientView];
	visibleRect = [[[self scrollView] contentView] bounds];
	
	lines = [self lineIndices];

	location += NSMinY(visibleRect);
	
	if ([view isKindOfClass:[NSTextView class]]) {
		nullRange = NSMakeRange(NSNotFound, 0);
		layoutManager = [view layoutManager];
		container = [view textContainer];
		count = [lines count];
		
		for (line = 0; line < count; line++) {
			index = [lines[line] unsignedIntValue];
			
			rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
								 withinSelectedCharacterRange:nullRange
											  inTextContainer:container
													rectCount:&rectCount];
			
			for (i = 0; i < rectCount; i++) {
				if ((location >= NSMinY(rects[i])) && (location < NSMaxY(rects[i]))) {
					return line + 1;
				}
			}
		}	
	}
	return NSNotFound;
}

- (NoodleLineNumberMarker *)markerAtLine:(unsigned)line {
	return linesToMarkers[@(line - 1)];
}

- (void)calculateLines {
    id view;

    view = [self clientView];
    
    if ([view isKindOfClass:[NSTextView class]]) {
        NSUInteger index, numberOfLines, stringLength, lineEnd, contentEnd;
        NSString *text;
        CGFloat oldThickness, newThickness;
        
        text = [view string];
        stringLength = [text length];
        lineIndices = [[NSMutableArray alloc] init];
        
        index = 0;
        numberOfLines = 0;
        
        do {
            [lineIndices addObject:@(index)];
            
            index = NSMaxRange([text lineRangeForRange:NSMakeRange(index, 0)]);
            numberOfLines++;
        }
        while (index < stringLength);

        // Check if text ends with a new line.
        [text getLineStart:NULL end:&lineEnd contentsEnd:&contentEnd forRange:NSMakeRange([[lineIndices lastObject] unsignedIntValue], 0)];
        
        if (contentEnd < lineEnd) {
            [lineIndices addObject:@(index)];
        }

        oldThickness = [self ruleThickness];
        newThickness = [self requiredThickness];
        if (fabs(oldThickness - newThickness) > 1) {
			NSInvocation *invocation;
			
			// Not a good idea to resize the view during calculations (which can happen during
			// display). Do a delayed perform (using NSInvocation since arg is a float).
			invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(setRuleThickness:)]];
			[invocation setSelector:@selector(setRuleThickness:)];
			[invocation setTarget:self];
			[invocation setArgument:&newThickness atIndex:2];
			
			[invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.0];
        }
	}
}

- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index inText:(NSString *)text {
    NSUInteger			left, right, mid, lineStart;
	NSMutableArray		*lines;

	lines = [self lineIndices];
	
    // Binary search
    left = 0;
    right = [lines count];

    while ((right - left) > 1) {
        mid = (right + left) / 2;
        lineStart = [lines[mid] unsignedIntValue];
        
        if (index < lineStart) {
            right = mid;
        } else if (index > lineStart) {
            left = mid;
        } else {
            return mid;
        }
    }
    return left;
}

- (NSDictionary *)textAttributes {
    return @{NSFontAttributeName: [self font], 
            NSForegroundColorAttributeName: [self textColor]};
}

- (NSDictionary *)markerTextAttributes {
	    return @{NSFontAttributeName: [self font], 
            NSForegroundColorAttributeName: [self alternateTextColor]};
}

- (CGFloat)requiredThickness {
    NSUInteger			lineCount, digits, i;
    NSMutableString     *sampleString;
    NSSize              stringSize;
    
    lineCount = [[self lineIndices] count];
    digits = (unsigned)log10(lineCount) + 1;
	sampleString = [NSMutableString string];
    for (i = 0; i < digits; i++) {
        // Use "8" since it is one of the fatter numbers. Anything but "1"
        // will probably be ok here. I could be pedantic and actually find the fattest
		// number for the current font but nah.
        [sampleString appendString:@"8"];
    }
    
    stringSize = [sampleString sizeWithAttributes:[self textAttributes]];

	// Round up the value. There is a bug on 10.4 where the display gets all wonky when scrolling if you don't
	// return an integral value here.
    return ceilf(MAX(DEFAULT_THICKNESS, stringSize.width + RULER_MARGIN * 2));
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)aRect {
    id			view;
	NSRect		bounds;

	bounds = [self bounds];

	if (backgroundColor != nil) {
		[backgroundColor set];
		NSRectFill(bounds);
		
		[[NSColor colorWithCalibratedWhite:0.58 alpha:1.0] set];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(bounds) - 0/5, NSMinY(bounds)) toPoint:NSMakePoint(NSMaxX(bounds) - 0.5, NSMaxY(bounds))];
	}
	
    view = [self clientView];
	
    if ([view isKindOfClass:[NSTextView class]]) {
        NSLayoutManager			*layoutManager;
        NSTextContainer			*container;
        NSRect					visibleRect, markerRect;
        NSRange					range, glyphRange, nullRange;
        NSString				*text, *labelText;
        NSUInteger				rectCount, index, line, count;
        NSRectArray				rects;
        CGFloat					ypos, yinset;
        NSDictionary			*textAttributes, *currentTextAttributes;
        NSSize					stringSize, markerSize;
		NoodleLineNumberMarker	*marker;
		NSImage					*markerImage;
		NSMutableArray			*lines;

        layoutManager = [view layoutManager];
        container = [view textContainer];
        text = [view string];
        nullRange = NSMakeRange(NSNotFound, 0);
		
		yinset = [view textContainerInset].height;        
        visibleRect = [[[self scrollView] contentView] bounds];

        textAttributes = [self textAttributes];
		
		lines = [self lineIndices];

        // Find the characters that are currently visible
        glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:container];
        range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];
        
        // Fudge the range a tad in case there is an extra new line at end.
        // It doesn't show up in the glyphs so would not be accounted for.
        range.length++;
        
        count = [lines count];
        index = 0;
        
        for (line = [self lineNumberForCharacterIndex:range.location inText:text]; line < count; line++) {
            index = [lines[line] unsignedIntValue];
            
            if (NSLocationInRange(index, range)) {
                rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
                                     withinSelectedCharacterRange:nullRange
                                                  inTextContainer:container
                                                        rectCount:&rectCount];
				
                if (rectCount > 0) {
                    // Note that the ruler view is only as tall as the visible
                    // portion. Need to compensate for the clipview's coordinates.
                    ypos = yinset + NSMinY(rects[0]) - NSMinY(visibleRect);
					
					marker = linesToMarkers[@(line)];
					
					if (marker != nil) {
						markerImage = [marker image];
						markerSize = [markerImage size];
						markerRect = NSMakeRect(0.0, 0.0, markerSize.width, markerSize.height);

						// Marker is flush right and centered vertically within the line.
						markerRect.origin.x = NSWidth(bounds) - [markerImage size].width - 1.0;
						markerRect.origin.y = ypos + NSHeight(rects[0]) / 2.0 - [marker imageOrigin].y;

						[markerImage drawInRect:markerRect fromRect:NSMakeRect(0, 0, markerSize.width, markerSize.height) operation:NSCompositeSourceOver fraction:1.0];
					}
                    
                    // Line numbers are internally stored starting at 0
                    labelText = [NSString stringWithFormat:@"%lu", line + 1];
                    
                    stringSize = [labelText sizeWithAttributes:textAttributes];

					if (marker == nil) {
						currentTextAttributes = textAttributes;
					} else {
						currentTextAttributes = [self markerTextAttributes];
					}
					
                    // Draw string flush right, centered vertically within the line
                    [labelText drawInRect:
                       NSMakeRect(NSWidth(bounds) - stringSize.width - RULER_MARGIN,
                                  ypos + (NSHeight(rects[0]) - stringSize.height) / 2.0,
                                  NSWidth(bounds) - RULER_MARGIN * 2.0, NSHeight(rects[0]))
                           withAttributes:currentTextAttributes];
                }
            }
            
			if (index > NSMaxRange(range)) {
				break;
			}
        }
    }
}

- (void)setMarkers:(NSArray *)markers {
	NSEnumerator		*enumerator;
	NSRulerMarker		*marker;
	
	[linesToMarkers removeAllObjects];
	[super setMarkers:nil];

	enumerator = [markers objectEnumerator];
	while ((marker = [enumerator nextObject]) != nil) {
		[self addMarker:marker];
	}
}

- (void)addMarker:(NSRulerMarker *)aMarker {
	if ([aMarker isKindOfClass:[NoodleLineNumberMarker class]]) {
		linesToMarkers[@([(NoodleLineNumberMarker *)aMarker lineNumber] - 1)] = aMarker;
	} else {
		[super addMarker:aMarker];
	}
    
    if (self.delegate != nil) {
        [self.delegate lineMarkerChanged];
    }
}

- (void)removeMarker:(NSRulerMarker *)aMarker {
	if ([aMarker isKindOfClass:[NoodleLineNumberMarker class]]) {
		[linesToMarkers removeObjectForKey:@([(NoodleLineNumberMarker *)aMarker lineNumber] - 1)];
	}
	else {
		[super removeMarker:aMarker];
	}
    
    if (self.delegate != nil) {
        [self.delegate lineMarkerChanged];
    }
}

- (NSArray*) markedLines {
    if (linesToMarkers == nil) {
        return [NSArray array];
    }
    
    return [[linesToMarkers allKeys] copy];
}

#pragma mark NSCoding methods

#define NOODLE_FONT_CODING_KEY				@"font"
#define NOODLE_TEXT_COLOR_CODING_KEY		@"textColor"
#define NOODLE_ALT_TEXT_COLOR_CODING_KEY	@"alternateTextColor"
#define NOODLE_BACKGROUND_COLOR_CODING_KEY	@"backgroundColor"

- (instancetype)initWithCoder:(NSCoder *)decoder {
	if ((self = [super initWithCoder:decoder]) != nil) {
		if ([decoder allowsKeyedCoding]) {
			font = [decoder decodeObjectForKey:NOODLE_FONT_CODING_KEY];
			textColor = [decoder decodeObjectForKey:NOODLE_TEXT_COLOR_CODING_KEY];
			alternateTextColor = [decoder decodeObjectForKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY];
			backgroundColor = [decoder decodeObjectForKey:NOODLE_BACKGROUND_COLOR_CODING_KEY];
		} else {
			font = [decoder decodeObject];
			textColor = [decoder decodeObject];
			alternateTextColor = [decoder decodeObject];
			backgroundColor = [decoder decodeObject];
		}
		
		linesToMarkers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	
	if ([encoder allowsKeyedCoding]) {
		[encoder encodeObject:font forKey:NOODLE_FONT_CODING_KEY];
		[encoder encodeObject:textColor forKey:NOODLE_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:alternateTextColor forKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:backgroundColor forKey:NOODLE_BACKGROUND_COLOR_CODING_KEY];
	} else {
		[encoder encodeObject:font];
		[encoder encodeObject:textColor];
		[encoder encodeObject:alternateTextColor];
		[encoder encodeObject:backgroundColor];
	}
}

@end
