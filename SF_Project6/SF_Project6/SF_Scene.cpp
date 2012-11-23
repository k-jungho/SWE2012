#include "SF_Scene.h"
#include "SimpleAudioEngine.h"
#include <math.h>

using namespace cocos2d;
using namespace CocosDenshion;

CCScene* SF_Scene::scene()
{
	// 'scene' is an autorelease object
	CCScene *scene = CCScene::node();
	
	// 'layer' is an autorelease object
	SF_Scene *layer = SF_Scene::node();
    
	// add layer as a child to scene
	scene->addChild(layer);
    
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
bool SF_Scene::init()
{
	//////////////////////////////
	// 1. super init first
	if ( !CCLayer::init() )
	{
		return false;
	}
    
	/////////////////////////////
	// 2. add a menu item with "X" image, which is clicked to quit the program
	//    you may modify it.
    
	// add a "close" icon to exit the progress. it's an autorelease object
    
	/////////////////////////////
	// 3. add your codes below...
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    //모드 선택
    player_num=-1;
    wait_backgroud = CCSprite::spriteWithFile("하늘.jpg");
    winSize = CCDirector::sharedDirector()->getWinSize();
	// position the sprite on the center of the screen
	wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
    wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
    wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
    // add the sprite as a child to this layer
	this->addChild(wait_backgroud, 0);
    
    CCMenuItemImage *Player1 = CCMenuItemImage::itemFromNormalImage("player1.png", NULL, this, menu_selector(SF_Scene::select1) );
	Player1->setPosition( ccp(winSize.width/4, winSize.height/2) );
    
	// create menu, it's an autorelease object
	pMenu1 = CCMenu::menuWithItems(Player1, NULL);
	pMenu1->setPosition( CCPointZero );
	this->addChild(pMenu1, 1);  
    
    CCMenuItemImage *Player2 = CCMenuItemImage::itemFromNormalImage("player2.png", NULL, this, menu_selector(SF_Scene::select2) );
	Player2->setPosition( ccp(winSize.width/4*3, winSize.height/2) );
    
	// create menu, it's an autorelease object
	pMenu2 = CCMenu::menuWithItems(Player2, NULL);
	pMenu2->setPosition( CCPointZero );
	this->addChild(pMenu2, 1); 
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
	return true;
}

void SF_Scene::frame(float dt)	
{
    char c[32];
    //비행기를 움직임
    SF_vector Fighter_position;
    SF_vector Enemy_position;
    SF_vector Missile_position;
    int Layer_operator;
    
    Fighter.Aircraft_Move(winSize);
    Fighter_position=Fighter.Get_position();
    Enemy_position=Enemy.Get_position();
    //비행기 포지션에 따른 레이어 재배치
    if(Fighter_position.x>=winSize.width){
        Layer_operator=winSize.width;
    }else{
        Layer_operator=0;
    }
    
    pFighter->setPosition(ccp(Fighter_position.x-Layer_operator,Fighter_position.y));
    pEnemy->setPosition(ccp(Enemy_position.x-Layer_operator,Enemy_position.y));
    
    //미사일을 움직임
    for(int i=0; i<255; i++){
        if(N_Missile[i].enable==true){
            N_Missile[i].Missile_class.Missile_Move(winSize);
            Missile_position=N_Missile[i].Missile_class.Get_position();
            N_Missile[i].Missile->setPosition(ccp(Missile_position.x-Layer_operator,Missile_position.y));
        }
    }
    
    for(int j=0; j<255; j++){
        if(N_Missile[j].enable==true){
            if(N_Missile[j].Missile_class.Check_EndMissile(winSize)){
                this->removeChild(N_Missile[j].Missile, true);
                N_Missile[j].enable=false;
            }
        }
    }
    
    //각도 표시부
    double player_angle;
    SF_vector arrow_position;
    if(player_num==1){
        player_angle=Fighter.Get_angle();
        arrow_position.x=120*cos(player_angle)+Fighter.Get_position().x;
        arrow_position.y=120*sin(player_angle)+Fighter.Get_position().y;
    }
    else{ 
        player_angle=Enemy.Get_angle();
        arrow_position.x=120*cos(player_angle)+Enemy.Get_position().x;
        arrow_position.y=120*sin(player_angle)+Enemy.Get_position().y;
    }
    sprintf( c, "%f", player_angle);
    pLabel->setString(c);
    pLabel->setPosition( ccp(winSize.width / 2, winSize.height - 20) );
    pArrow->setPosition(ccp(arrow_position.x-Layer_operator,arrow_position.y));
}

void SF_Scene::didAccelerate(CCAcceleration* pAccelerationValue)
{
    Fighter.Add_velocity(pAccelerationValue->x,0 );
    
    if(player_num==1)
        Fighter.Add_angle(pAccelerationValue->y);
    else
        Enemy.Add_angle(-pAccelerationValue->y);
}

void SF_Scene::menuShootCallback(CCObject* pSender) //버튼 입력시 미사일 발사
{
    SF_vector present_position;
    present_position=Fighter.Get_position();
    N_Missile[Missile_count].Missile=CCSprite::spriteWithFile("bullet.png");
    N_Missile[Missile_count].Missile_class.Init_Missile(present_position.x, present_position.y,1);
    N_Missile[Missile_count].Missile->setPosition(ccp(present_position.x,present_position.y));
    N_Missile[Missile_count].enable=true;
    this->addChild(N_Missile[Missile_count].Missile,1);
    Missile_count++;
    
    if(Missile_count==255)
        Missile_count=0;
}

void SF_Scene::select1(CCObject* pSender){
    player_num=1;
    Fighter.Set_angle(0);
    setting_scene();
}

void SF_Scene::select2(CCObject* pSender){
    player_num=2;
    Enemy.Set_angle(180);
    setting_scene();
}

void SF_Scene::setting_scene(){
    this->removeChild(wait_backgroud, true);
    this->removeChild(pMenu1, true);
    this->removeChild(pMenu2, true);
    // add a "close" icon to exit the progress. it's an autorelease object
	CCMenuItemImage *pShootItem = CCMenuItemImage::itemFromNormalImage("CloseNormal.png", "CloseSelected.png", this, menu_selector(SF_Scene::menuShootCallback) );
	pShootItem->setPosition( ccp(40, 200) );
    
	// create menu, it's an autorelease object
	CCMenu* pMenu = CCMenu::menuWithItems(pShootItem, NULL);
	pMenu->setPosition( CCPointZero );
	this->addChild(pMenu, 1);    
    
	// add "HelloWorld" splash screen"
	CCSprite* pSprite = CCSprite::spriteWithFile("하늘.jpg");
    winSize = CCDirector::sharedDirector()->getWinSize();
	// position the sprite on the center of the screen
	pSprite->setScaleX(winSize.width/pSprite->getContentSize().width);
    pSprite->setScaleY(winSize.height/pSprite->getContentSize().height);
    pSprite->setPosition( ccp(winSize.width/2, winSize.height/2) );
    // add the sprite as a child to this layer
	this->addChild(pSprite, 0);
    
    //땅 형성
    CCSprite* pGround = CCSprite::spriteWithFile("ground.png");
    pGround->setScaleX(winSize.width/pGround->getContentSize().width);
    pGround->setScaleY(1.5);
    pGround->setPosition( ccp(winSize.width/2,winSize.height/8-35));
    this->addChild(pGround,1);
    
    //미니맵의 형성
    pMiniMap=CCSprite::spriteWithFile("MiniMap.png");
    pMiniMap->setRotation(90);
    pMiniMap->setScaleX(winSize.width/8/pMiniMap->getContentSize().width);
    pMiniMap->setScaleY(winSize.height/3/pMiniMap->getContentSize().height);
    pMiniMap->setPosition(ccp(winSize.width*6/7, winSize.height/8*7));
    pMiniMap->setOpacity(80);
    this->addChild(pMiniMap,2);
    
    //비행기 이미지 등록
    pFighter = CCSprite::spriteWithFile("Fighter.png");
    //pFighter->setRotation(90);
    Fighter.Init_Object(winSize.width/2, 2*86);
    pFighter->setPosition(ccp(Fighter.Get_position().x, Fighter.Get_position().y));
    this->addChild(pFighter,1);
    
    //적 탱크 이미지 등록
    pEnemy = CCSprite::spriteWithFile("Enemy.png");
    Enemy.Init_Object(winSize.width*1.5, 2*86);
    pEnemy->setFlipX(true);
    pEnemy->setScaleX(pFighter->getContentSize().width/pEnemy->getContentSize().width);
    pEnemy->setScaleY(pFighter->getContentSize().height/pEnemy->getContentSize().height);
    pEnemy->setPosition(ccp(Enemy.Get_position().x, Enemy.Get_position().y));
    this->addChild(pEnemy,1);
    
    //디버깅용 자이로센서 감지 등록
    char c[32];
    pLabel = CCLabelTTF::labelWithString("Hello World", "Thonburi", 34);
    sprintf( c, "%f, %f, %f", 0.0, 1.1, 2.2);
    pLabel->setString(c);
	pLabel->setPosition( ccp(winSize.width / 2, winSize.height - 20) );
	this->addChild(pLabel, 1);
    
    //화살 추가
    pArrow = CCSprite::spriteWithFile("Arrow.png");
    pArrow->setScaleX(0.1);
    pArrow->setScaleY(0.1);
    this->addChild(pArrow,1);
    
    //미사일 초기화
    Missile_count=0;
    Missile_base=0;
    
    setIsAccelerometerEnabled(true);
    
    schedule(schedule_selector(SF_Scene::frame), 1.f/60);
}

