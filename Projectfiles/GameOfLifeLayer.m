/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "GameOfLifeLayer.h"

@interface GameOfLifeLayer (PrivateMethods)
@end

NSMutableArray* grid;
NSMutableArray* numNeighbors;

@implementation GameOfLifeLayer

-(id) init
{
	if ((self = [super init]))
	{
		grid = [[NSMutableArray alloc] init]; //this initializes the array
        for (int k = 0; k < NUM_ROWS; ++ k) //rows
        {
            NSMutableArray* subArr = [[NSMutableArray alloc] init ];
            for (int s = 0; s < NUM_COLUMNS; ++ s) //columns
            {
                NSNumber *item = [NSNumber numberWithInt: 0];
                [subArr addObject:item];
                
            }
            [grid addObject:subArr];
        }
        
        numNeighbors = [[NSMutableArray alloc] init]; //this initializes the array
        for (int k = 0; k < NUM_ROWS; ++ k) //rows
        {
            NSMutableArray* subArr = [[NSMutableArray alloc] init];
            for (int s = 0; s < NUM_COLUMNS; ++ s) //columns
            {
                
                NSNumber *item = @0;
                //an abbreviation for [NSNumber numberWithInt: 0] is @0
                [subArr addObject:item];
                
            }
            [numNeighbors addObject:subArr];
        }
	}

	return self;
}

@end
