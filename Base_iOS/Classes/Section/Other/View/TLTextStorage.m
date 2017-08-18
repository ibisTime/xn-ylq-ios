//
//  TLTextStorage.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLTextStorage.h"

@implementation TLTextStorage

{
    NSMutableAttributedString *_imp;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _imp = [NSMutableAttributedString new];
    }
    
    return self;
}


#pragma mark - Reading Text
- (NSString *)string
{
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}


#pragma mark - Text Editing
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [_imp replaceCharactersInRange:range withString:str];
    
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}


#pragma mark - Syntax highlighting

- (void)processEditing
{
    static NSRegularExpression *emoticonExpression;
    static NSRegularExpression *atExpression;
    
    emoticonExpression = emoticonExpression ?: [NSRegularExpression regularExpressionWithPattern:@"\\[[^ \\[\\]]+?\\]" options:0 error:NULL];
    
    atExpression = atExpression ?: [NSRegularExpression regularExpressionWithPattern:@"@[-_a-zA-Z0-9\u4E00-\u9FA5]+" options:0 error:NULL];
    
    
    // 清除原来的信息，在编辑范围内
    NSRange paragaphRange = [self.string paragraphRangeForRange:self.editedRange];
    
    [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
    
    // Find all iWords in range
    [atExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        // Add red highlight color
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:result.range];
        
    }];
    
    // Call super *after* changing the attrbutes, as it finalizes the attributes and calls the delegate methods.
    [super processEditing];
    
}

@end
