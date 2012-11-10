/*
 NSManagedObjectContext+DCTExtras.m
 DCTCoreData
 
 Created by Daniel Tull on 4.11.2010.
 
 
 
 Copyright (C) 2010 Daniel Tull. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "NSManagedObjectContext+DCTExtras.h"

@implementation NSManagedObjectContext (DCTExtras)

- (id)dct_safeObjectWithID:(NSManagedObjectID *)objectID {
	
	if (!objectID) return nil;
	
	return [self objectWithID:objectID];
}


- (void)dct_performAndWaitWithObjectID:(NSManagedObjectID *)objectID block:(void (^)(NSManagedObject *object))block {
	
	[self performBlockAndWait:^{
		block([self objectWithID:objectID]);
	}];
}

- (void)dct_performWithObjectID:(NSManagedObjectID *)objectID block:(void (^)(NSManagedObject *object))block {
	
	NSAssert(objectID != nil, @"objectID should not be nil");
	NSAssert(block != nil, @"block should not be nil");
	
	[self performBlock:^{
		block([self objectWithID:objectID]);
	}];
}

- (void)dct_performWithObjectIDs:(NSArray *)objectIDs block:(void (^)(NSArray *objects))block {
	
	NSAssert(objectIDs != nil, @"objectIDs should not be nil");
	NSAssert(block != nil, @"block should not be nil");
	
	[self performBlock:^{
		
		NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[objectIDs count]];
		
		[objectIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objectID, NSUInteger idx, BOOL *stop) {
			[objects addObject:[self objectWithID:objectID]];
		}];
		
		block([objects copy]);
	}];
}

- (void)dct_performAndWaitWithObjectIDs:(NSArray *)objectIDs block:(void (^)(NSArray *objects))block {
	[self performBlockAndWait:^{
		
		NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:[objectIDs count]];
		
		[objectIDs enumerateObjectsUsingBlock:^(NSManagedObjectID *objectID, NSUInteger idx, BOOL *stop) {
			[objects addObject:[self objectWithID:objectID]];
		}];
		
		block([objects copy]);
	}];
}

- (NSManagedObjectModel *)dct_managedObjectModel {
	return [[self persistentStoreCoordinator] managedObjectModel];
}

@end