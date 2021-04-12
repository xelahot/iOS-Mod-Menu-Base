#import "TextfieldItem.h"

@implementation TextfieldItem

@synthesize IsOn = _IsOn;
@synthesize Description = _Description;
@synthesize DefaultValue = _DefaultValue;

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

- (void) setDefaultValue:(NSString *)pDefaultValue {
   _DefaultValue = pDefaultValue;
}

- (NSString *) DefaultValue {
   return _DefaultValue;
}

- (id) initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ isOn:(BOOL)isOn_ defaultValue:(NSString *)defaultValue_ {
   //Set object propreties
   self.Title = title_;

   self.Description = description_;
   self.IsOn = isOn_;
   self.DefaultValue = defaultValue_;

   return self;
}

@end