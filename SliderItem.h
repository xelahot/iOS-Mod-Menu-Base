#import "MenuItem.h"

@interface SliderItem : MenuItem

@property (nonatomic) NSString *Description;
@property (nonatomic) BOOL IsOn;
//Tells if the value is an int or float to adjust the format specifier for the UI
@property (nonatomic) BOOL IsFloating;
@property (nonatomic) float DefaultValue;
@property (nonatomic) float MinValue;
@property (nonatomic) float MaxValue;

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ isFloating:(BOOL)isFloating_ defaultValue:(float)defaultValue_ minValue:(float)minValue_ maxValue:(float)maxValue_;

@end