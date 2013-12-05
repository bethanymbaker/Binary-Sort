//
//  main.m
//  Binary Sort
//
//  Created by Bethany Simmons on 12/3/13.
//  Copyright (c) 2013 Bethany Simmons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandomArray : NSObject
@property NSMutableArray *myArray;
@property NSArray *mySortedArray;
@property int numElements;
- (void)sortRandomArray;
//- (NSArray *)binarySortSubArray:(NSArray *)subArray;
+ (NSArray *)binarySortSubArray:(NSArray *)subArray;
@end

@implementation RandomArray
- (id)init
{
    self = [super init];
    if (self) {
        _numElements = 5;
        _myArray = [[NSMutableArray alloc]init];
        for (int i = 0; i<_numElements; i++) {
            NSUInteger r = arc4random_uniform(_numElements) + 1;
            NSNumber *wrappedInt = [NSNumber numberWithInteger:r];
            [_myArray addObject:wrappedInt];
        }
    }
    return self;
}
- (void)sortRandomArray
{
    NSArray *subArray = [[NSArray alloc]init];
    NSArray *tempArray = [[NSArray alloc]initWithArray:self.myArray];
    NSArray *rightSideArray;
    NSRange range;
    
    for (int length = 1; length<_numElements+1; length ++) {
        rightSideArray = [[NSArray alloc]initWithArray:self.myArray];
        range = NSMakeRange(length, _numElements-length);
        rightSideArray = [rightSideArray subarrayWithRange:range];
        
        subArray = [tempArray subarrayWithRange:NSMakeRange(0, length)];
        //tempArray = [self binarySortSubArray:subArray];
        tempArray = [RandomArray binarySortSubArray:subArray];
        tempArray = [tempArray arrayByAddingObjectsFromArray:rightSideArray];
    }
    self.mySortedArray = [[NSArray alloc]initWithArray:tempArray];
     
}
+ (NSArray *)binarySortSubArray:(NSArray *)subArray;
{
    int lengthSubArray = (int)[subArray count];
    NSNumber *leftNumber = [subArray objectAtIndex:0];
    NSNumber *rightNumber = [subArray objectAtIndex:lengthSubArray-1];
    int leftValue = [leftNumber intValue];
    int rightValue = [rightNumber intValue];
    
    if (lengthSubArray == 1) {
        return subArray;
    } else if (lengthSubArray == 2) {
        if (rightValue < leftValue) {
            return @[rightNumber,leftNumber];
        }
        return subArray;
    }
    
    // Length >= 3...we have a sorted array on the left with a number to sort on the right
    int lengthPreSortedArray = lengthSubArray - 1;
    
    NSNumber *numberToSort = [subArray objectAtIndex:lengthPreSortedArray];
    int intToSort = [numberToSort intValue];
    
    NSArray *preSortedArray = [subArray subarrayWithRange:NSMakeRange(0, lengthPreSortedArray)];
    int midPoint = lengthPreSortedArray / 2;
    NSNumber *midNumber = [preSortedArray objectAtIndex:midPoint];
    int midValue = [midNumber intValue];
    
    NSRange rangeLeft = NSMakeRange(0, midPoint);
    NSRange rangeRight = NSMakeRange(midPoint, lengthPreSortedArray-midPoint);
    
    NSArray *leftArray = [preSortedArray subarrayWithRange:rangeLeft];
    NSArray *rightArray = [preSortedArray subarrayWithRange:rangeRight];
    
    NSArray *tempArray = [[NSArray alloc]init];
    if (intToSort < midValue) {
        tempArray = [leftArray arrayByAddingObjectsFromArray:@[numberToSort]];
        tempArray = [RandomArray binarySortSubArray:tempArray];
        tempArray = [tempArray arrayByAddingObjectsFromArray:rightArray];
        return tempArray;
    } else if (intToSort > midValue) {
        tempArray = [rightArray arrayByAddingObjectsFromArray:@[numberToSort]];
        tempArray = [RandomArray binarySortSubArray:tempArray];
        tempArray = [leftArray arrayByAddingObjectsFromArray:tempArray];
        return tempArray;
    } else {
        tempArray = [leftArray arrayByAddingObjectsFromArray:@[numberToSort]];
        tempArray = [tempArray arrayByAddingObjectsFromArray:rightArray];
        return tempArray;
    }
}
@end



int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        RandomArray *myRandomArray = [[RandomArray alloc]init];
        [myRandomArray sortRandomArray];
        
        NSLog(@"Unsorted array = %@",myRandomArray.myArray);
        NSLog(@"Sorted array = %@",myRandomArray.mySortedArray);
        
    }
    return 0;
}

