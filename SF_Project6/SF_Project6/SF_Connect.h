//
//  SF_Connect.h
//  SF_Project6
//
//  Created by 김정호 on 12. 11. 26..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#ifndef __SF_Project6__SF_Connect__
#define __SF_Project6__SF_Connect__

#include "cocos2d.h"
#define MAX_SHOOT_POWER 40

class SF_Connect: public cocos2d::CCLayer
{
public:
	virtual bool init();
	static cocos2d::CCScene* scene();
    LAYER_NODE_FUNC(SF_Connect);
};

#endif /* defined(__SF_Project6__SF_Connect__) */
