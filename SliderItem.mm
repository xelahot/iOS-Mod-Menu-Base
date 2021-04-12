#import "SliderItem.h"

@implementation SliderItem

@synthesize IsOn = _IsOn;
@synthesize Description = _Description;
@synthesize IsFloating = _IsFloating;
@synthesize DefaultValue = _DefaultValue;
@synthesize MinValue = _MinValue;
@synthesize MaxValue = _MaxValue;

- (void) setIsOn:(BOOL)pIsOn {
   _IsOn = pIsOn;
}

- (BOOL) IsOn {
   return _IsOn;
}

- (void) setDescription:(NSString *)pDescription {
   _Description = pDescription;
}

- (NSString*) Description {
   return _Description;
}

- (void) setIsFloating:(BOOL)pIsFloating {
   _IsFloating = pIsFloating;
}

- (BOOL) IsFloating {
   return _IsFloating;
}

- (void) setDefaultValue:(float)pDefaultValue {
   _DefaultValue = pDefaultValue;
}

- (float) DefaultValue {
   return _DefaultValue;
}

- (void) setMinValue:(float)pMinValue {
   _MinValue = pMinValue;
}

- (float) MinValue {
   return _MinValue;
}

- (void) setMaxValue:(float)pMaxValue {
   _MaxValue = pMaxValue;
}

- (float) MaxValue {
   return _MaxValue;
}

- (id) initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ isFloating:(BOOL)isFloating_ defaultValue:(float)defaultValue_ minValue:(float)minValue_ maxValue:(float)maxValue_ {
   //Set object propreties
   self.Title = title_;

   self.Description = description_;
   self.IsOn = isOn_;
   self.IsFloating = isFloating_;
   self.DefaultValue = defaultValue_;
   self.MinValue = minValue_;
   self.MaxValue = maxValue_;

   return self;
}

@end