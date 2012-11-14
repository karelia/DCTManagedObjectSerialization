//
//  NSManagedObject+DCTManagedObjectSerialization.h
//  DCTManagedObjectSerialization
//
//  Created by Daniel Tull on 10.11.2012.
//  Copyright (c) 2012 Daniel Tull. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (DCTManagedObjectSerialization)

// By default, failure occurs if the value is of an unsuitable type, with NSFileReadCorruptFileError
// Override for custom handling of specific keys, or to add stricter error checking
- (BOOL)dct_setSerializedValue:(id)object forKey:(NSString *)key error:(NSError **)error;

// Performs deserialization
// You can override to tack on additional functionality *after* calling through to super, although overriding -dct_setSerializedValue:forKey:error: is often more appropriate
// The serialized form is guaranteed to adopt Key Value Coding, but that's it
- (void)dct_awakeFromSerializedRepresentation:(NSObject *)rep;

@end
