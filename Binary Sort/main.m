//
//  main.m
//  Binary Sort
//
//  Created by Bethany Simmons on 12/3/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomArray : NSObject
@property NSMutableArray *myUnsortedArray;
@property NSArray *mySortedArray;
@property int numElements;
- (void)sortRandomArray;
+ (NSArray *)binarySortSubArray:(NSArray *)subArray;
- (void)print;
@end

@implementation RandomArray
- (id)init
{
    self = [super init];
    if (self) {
        _numElements = 100;
        _myUnsortedArray = [[NSMutableArray alloc]init];
        _mySortedArray = [[NSArray alloc]init];
        for (int i = 0; i<_numElements; i++) {
            [_myUnsortedArray addObject:[NSNumber numberWithInteger:arc4random_uniform(_numElements) + 1]];
        }
    }
    return self;
}
- (void)print
{
    NSLog(@"Unsorted array = %@",[_myUnsortedArray componentsJoinedByString:@", "]);
    NSLog(@"Sorted array = %@",[_mySortedArray componentsJoinedByString:@", "]);
}
- (void)sortRandomArray
{
    NSArray *leftSideArray = [[NSArray alloc]init];
    NSArray *rightSideArray;
    NSArray *reassembledArray = [[NSArray alloc]initWithArray:_myUnsortedArray];
    
    for (int numLeftElements = 1; numLeftElements<_numElements+1; numLeftElements ++) {
        rightSideArray = [_myUnsortedArray subarrayWithRange:NSMakeRange(numLeftElements, _numElements-numLeftElements)];
        leftSideArray = [reassembledArray subarrayWithRange:NSMakeRange(0, numLeftElements)];
        reassembledArray = [[RandomArray binarySortSubArray:leftSideArray] arrayByAddingObjectsFromArray:rightSideArray];
    }
    self.mySortedArray = reassembledArray;
     
}
+ (NSArray *)binarySortSubArray:(NSArray *)subArray;
{
    int lengthSubArray = (int)[subArray count];
    int lengthPreSortedArray = lengthSubArray - 1;
    NSNumber *leftNumber = [subArray objectAtIndex:0];
    NSNumber *numberToSort = [subArray objectAtIndex:lengthPreSortedArray];
    int leftValue = [leftNumber intValue];
    int intToSort = [numberToSort intValue];
    
    if (lengthSubArray == 1) {
        return subArray;
    } else if (lengthSubArray == 2) {
        if (intToSort < leftValue) {
            return @[numberToSort,leftNumber];
        }
        return subArray;
    }
    
    // Length >= 3...we have a sorted array on the left with a number to sort on the right
    NSArray *preSortedArray = [subArray subarrayWithRange:NSMakeRange(0, lengthPreSortedArray)];
    int midPoint = lengthPreSortedArray / 2;
    NSNumber *midNumber = [preSortedArray objectAtIndex:midPoint];
    int midValue = [midNumber intValue];
    
    NSArray *leftArray = [preSortedArray subarrayWithRange:NSMakeRange(0, midPoint)];
    NSArray *rightArray = [preSortedArray subarrayWithRange:NSMakeRange(midPoint, lengthPreSortedArray-midPoint)];
    
    NSArray *tempArray = [[NSArray alloc]init];
    if (intToSort < midValue) {
        tempArray = [leftArray arrayByAddingObjectsFromArray:@[numberToSort]];
        return [[RandomArray binarySortSubArray:tempArray] arrayByAddingObjectsFromArray:rightArray];
    } else if (intToSort > midValue) {
        tempArray = [rightArray arrayByAddingObjectsFromArray:@[numberToSort]];
        return [leftArray arrayByAddingObjectsFromArray:[RandomArray binarySortSubArray:tempArray]];
    } else {
        return [[leftArray arrayByAddingObjectsFromArray:@[numberToSort]] arrayByAddingObjectsFromArray:rightArray];
    }
}
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        RandomArray *myRandomArray = [[RandomArray alloc]init];
        [myRandomArray sortRandomArray];
        [myRandomArray print];
    }
    return 0;
}

