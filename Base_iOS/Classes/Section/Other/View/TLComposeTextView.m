//
//  TLComposeTextView.m
//  Base_iOS
//
//  Created by 蔡卓越 on 2017/7/22.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "TLComposeTextView.h"

@implementation TLComposeTextView

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.placeholderLbl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer  {
    
    if (self = [super initWithFrame:frame textContainer:textContainer]) {
        
        [self addSubview:self.placeholderLbl];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    
    return self;
}

- (void)textChange {
    
    
    if (self.text && self.text.length > 0) {
        
        [self.placeholderLbl removeFromSuperview];
        
    } else {
        
        [self addSubview:self.placeholderLbl];
        
    }
    
    
}

- (NSMutableString *)copyText {
    
    if (!_copyText) {
        
        _copyText = [NSMutableString new];
    }
    return _copyText;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    
    
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    
    if (attributedText && attributedText.string.length > 0) {
        
        [self.placeholderLbl removeFromSuperview];
        
    } else {
        
        [self addSubview:self.placeholderLbl];
        
    }
    
    return;
    
}




- (void)setPlacholder:(NSString *)placholder {
    
    _placholder = [placholder copy];
    self.placeholderLbl.text = _placholder;
    
}

- (UILabel *)placeholderLbl {
    
    if (!_placeholderLbl) {
        _placeholderLbl =  [UILabel
                            
                            labelWithFrame:CGRectMake(12, 5, 200, 20)
                            textAligment:NSTextAlignmentLeft
                            backgroundColor:[UIColor whiteColor]
                            font:Font(15)
                            textColor:[UIColor colorWithHexString:@"#f0f0f0"]];
        //     _placeholderLbl.userInteractionEnabled = YES;
        
    }
    return _placeholderLbl;
    
}

@end
