#import "InvokeItem.h"

@implementation InvokeItem

@synthesize FunctionPtr = _FunctionPtr;
@synthesize Description = _Description;

- (void) setFunctionPtr:(void (*)())pFunctionPtr {
   _FunctionPtr = pFunctionPtr;
}

- (void (*)()) FunctionPtr {
   return _FunctionPtr;
}

- (void) setDescription:(NSString *)pDescription {
   _Description = pDescription;
}

- (NSString*) Description {
   return _Description;
}

- (id)initWithTitle:(NSString *)title_ 
		description:(NSString *)description_ functionPtr:(void (*)())functionPtr_ {
   //Set object propreties
   self.Title = title_;

   self.Description = description_;
   self.FunctionPtr = functionPtr_;

   return self;
}

@end