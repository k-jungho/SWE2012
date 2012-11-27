//
//  SF_Connect.cpp
//  SF_Project6
//
//  Created by 김정호 on 12. 11. 26..
//  Copyright (c) 2012년 frf1226@nate.com. All rights reserved.
//

#include "SF_Connect.h"
using namespace cocos2d;

bool SF_Connect::init()
{
    if ( !CCLayer::init() )
	{
		return false;
	}
    return true;
}

CCScene* SF_Connect::scene()
{
    // 'scene' is an autorelease object
	CCScene *scene = CCScene::node();
	
	// 'layer' is an autorelease object
	SF_Connect *layer = SF_Connect::node();
    
	// add layer as a child to scene
	scene->addChild(layer);
    
	// return the scene
	return scene;
}