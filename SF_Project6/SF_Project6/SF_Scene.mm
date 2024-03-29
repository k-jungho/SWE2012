
#include "SF_Scene.h"
#include "SimpleAudioEngine.h"
#include "PacketManager.h"
#include "RecognitionAnalyzer.h"
#include <math.h> 

using namespace cocos2d;
using namespace CocosDenshion;

SF_Scene* pScene = NULL;

CCScene* SF_Scene::scene()
{
	// 'scene' is an autorelease object
	CCScene *scene = CCScene::node();
	
	// 'layer' is an autorelease object
	SF_Scene *layer = SF_Scene::node();
    
	// add layer as a child to scene
	scene->addChild(layer);
    pScene = layer;
    
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
//    player_num=-1;
//    wait_backgroud = CCSprite::spriteWithFile("하늘.jpg");
//    winSize = CCDirector::sharedDirector()->getWinSize();
//	// position the sprite on the center of the screen
//	wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
//    wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
//    wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
//    // add the sprite as a child to this layer
//	this->addChild(wait_backgroud, 0);
//    
//    CCMenuItemImage *Player1 = CCMenuItemImage::itemFromNormalImage("player1.png", NULL, this, menu_selector(SF_Scene::select1) );
//	Player1->setPosition( ccp(winSize.width/4, winSize.height/2) );
//    
//	// create menu, it's an autorelease object
//	pMenu1 = CCMenu::menuWithItems(Player1, NULL);
//	pMenu1->setPosition( CCPointZero );
//	this->addChild(pMenu1, 1);  
//    
//    CCMenuItemImage *Player2 = CCMenuItemImage::itemFromNormalImage("player2.png", NULL, this, menu_selector(SF_Scene::select2) );
//	Player2->setPosition( ccp(winSize.width/4*3, winSize.height/2) );
//    
//	// create menu, it's an autorelease object
//	pMenu2 = CCMenu::menuWithItems(Player2, NULL);
//	pMenu2->setPosition( CCPointZero );
//	this->addChild(pMenu2, 1);
    
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        select1(this);
        RecognitionAnalyzer::startRecognition();
    }
    else
    {
        // use this method on ios6
        select2(this);
    }
    

    
    //파워바 방향 설정
    Powerbar_Direction=true;
    //플레이어 턴 초기화
    present_turn=1;
    //게임의 종료 여부
    check_END=false;
    //각도부분 초기화
    target_angle=0;
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////
	return true;
}

void SF_Scene::frame(float dt)	
{
    if(check_END==false){
    //비행기를 움직임
    SF_vector Fighter_position;
    SF_vector Enemy_position;
    SF_vector Missile_position;
    
    Fighter.Aircraft_Move(winSize);
    Enemy.Aircraft_Move(winSize);
    
    Fighter_position=Fighter.Get_position();
    Enemy_position=Enemy.Get_position();
    
    if(present_turn==1){
        //비행기 포지션에 따른 레이어 재배치
        if(Fighter_position.x>=winSize.width){
            Layer_operator=winSize.width;
        }else{
            Layer_operator=0;
        }
        
        if(player_num==1){
            //파워게이지를 움직임
            if(Move_bar==true)
                Move_Powerbar();
            this->setIsTouchEnabled(true);
        }else if(player_num==2){
            
        }
    }else if(present_turn==2){
        //비행기 포지션에 따른 레이어 재배치
        if(Enemy_position.x>=winSize.width){
            Layer_operator=winSize.width;
        }else{
            Layer_operator=0;
        }
        
        if(player_num==1){
            
        }else if(player_num==2){
            //파워게이지를 움직임
            if(Move_bar==true)
                Move_Powerbar();
            this->setIsTouchEnabled(true);
        }
    }
    //포탄에 따라 레이어를 한번 더 추가로 변경
    if(check_shoot==true){
        if(Missile.Get_position().x >= winSize.width){
            Layer_operator=winSize.width;
        }else{
            Layer_operator=0;
        }
    }
    //미니맵을 움직임
    MiniMap_dot();
    //HP그리기
    Draw_HPbar();
    //각도계를 움직임
    Move_angle();
        
    pFighter->setPosition(ccp(Fighter_position.x-Layer_operator,Fighter_position.y));
    pEnemy->setPosition(ccp(Enemy_position.x-Layer_operator,Enemy_position.y));
    //////////////////////////////////////////////////////////////////////////////
    //미사일을 움직임
    if(check_shoot==true){
        Missile.Missile_Move(winSize);
        Missile_position=Missile.Get_position();
        pMissile->setPosition(ccp(Missile_position.x-Layer_operator,Missile_position.y));
        
        if(Missile.Check_EndMissile(winSize)){
            this->removeChild(pMissile,true);
            count_frame=0;
            check_shoot=false;
            this->removeChild(pYellowdot, true);
            if(present_turn==1){
                present_turn=-1;
                if(player_num==1)
                    [PacketManager SendPacket:PROTOCOL_END pos:Missile_position vel:Missile_position];
            }
            else if(present_turn==2){
                present_turn=-2;
                if(player_num==2)
                    [PacketManager SendPacket:PROTOCOL_END pos:Missile_position vel:Missile_position];
            }
        }
    }
    //미사일 요격을 감지 & HP가 0이 되면 게임 종료
    Check_hit();

    //각도 표시부
    double player_angle;
    SF_vector arrow_position;
    if(player_num==1){
        player_angle=Fighter.Get_angle();
        arrow_position.x=100*cos(player_angle)+Fighter.Get_position().x;
        arrow_position.y=100*sin(player_angle)+Fighter.Get_position().y;
    }
    else if(player_num==2){
        player_angle=Enemy.Get_angle();
        arrow_position.x=100*cos(player_angle)+Enemy.Get_position().x;
        arrow_position.y=100*sin(player_angle)+Enemy.Get_position().y;
    }
    pArrow->setPosition(ccp(arrow_position.x-Layer_operator,arrow_position.y));
    pArrow->setRotation(90-player_angle*180/PI);
    
    //남은 시간 표수 부분
    Write_Time();
    
    //턴을 넘기는 부분
    if(check_shoot==false)
        count_frame+=dt;
    
    if(present_turn == player_num && count_frame - prev_elapsedTime >= 0.1)
    {
        prev_elapsedTime = count_frame;
        //        ~~.sendpacket(0, ~~);
    }
    
    if(present_turn==1 || present_turn==2){
        if(count_frame >= 20){
            if(present_turn==1){
                count_frame=0;
                present_turn=-1;
                Move_bar=true;
                if(player_num==1)
                    [PacketManager SendPacket:PROTOCOL_END pos:Missile_position vel:Missile_position];
            }else if(present_turn==2){
                count_frame=0;
                present_turn=-2;
                Move_bar=true;
                if(player_num==2)
                    [PacketManager SendPacket:PROTOCOL_END pos:Missile_position vel:Missile_position];
                }
            }
        }else if(present_turn==-1 || present_turn==-2){
            Enemy.Set_velocity(0, 0);
            Fighter.Set_velocity(0, 0);
            this->setIsTouchEnabled(false);
            if(count_frame >=2){//나중에 상대방 시작패킷 받으면 시작하는걸로 바꿔
                present_turn += 3;
            
                if(present_turn == player_num)
                {
                    //~~.sendpacket(4, ~~);
                    RecognitionAnalyzer::startRecognition();
                }
                else
                {
                    RecognitionAnalyzer::endRecognition();
                }
                count_frame = 0;
                check_shoot=false;
                prev_elapsedTime = 0;
            }
        }
        if(Fighter.Get_HP()<=0 || Enemy.Get_HP()<=0){
            //게임 종료
            Game_END();
            check_END=true;
        }
    }
    
    static float syncTimer = 0.f;
    syncTimer += dt;
    
    if( syncTimer > 0.2f )
    {
        if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
        {
            [PacketManager SendPacket:PROTOCOL_SYNC pos:Fighter.Get_position() vel:Fighter.Get_position()];
        }
        else
        {
            [PacketManager SendPacket:PROTOCOL_SYNC pos:Enemy.Get_position() vel:Enemy.Get_position()];
        }
        syncTimer = 0.f;
    }
    if( (voice_type = RecognitionAnalyzer::getResponseFromView()) != RESPONSE_NONE ){
        menuShootCallback(this);
        
        //voice_type에 따라 메소드 호출
        /*switch(voice_type){
                
        }*/
    }
    
}

void SF_Scene::didAccelerate(CCAcceleration* pAccelerationValue)
{
    if(present_turn==1){
        if(player_num==1){
            Fighter.Add_velocity(pAccelerationValue->x, 0);
            //Fighter.Add_angle(pAccelerationValue->y);
        }
    }else if(present_turn==2){
        if(player_num==2){
            Enemy.Add_velocity(pAccelerationValue->x,0 );
            //Enemy.Add_angle(-(pAccelerationValue->y));
        }
    }
}

void SF_Scene::menuShootCallback(CCObject* pSender) //버튼 입력시 미사일 발사
{
    if(voice_type==RESPONSE_PROCESSING){            //바 멈추기
        Move_bar=false;
    }else if(voice_type==RESPONSE_MISSILE || voice_type==RESPONSE_DOUBLE){
        Move_bar=true;
        if(player_num==present_turn){
            if(check_shoot==false){
                SF_vector present_position, Shoot_angle;
                double present_angle;
                double Shoot_power = Get_Powerposition();
            
                if(present_turn==1){
                    if(player_num==1){
                        present_position=Fighter.Get_position();
                        present_angle=Fighter.Get_angle();
                        Missile.Set_who(1);
                    }
                }else if(present_turn==2){
                    if(player_num==2){
                        present_position=Enemy.Get_position();
                        present_angle=Enemy.Get_angle();
                        Missile.Set_who(2);
                    }
                }
                Shoot_power=10+Shoot_power/8;
                Shoot_angle.x=Shoot_power*cos(present_angle);
                Shoot_angle.y=Shoot_power*sin(present_angle);
            
                pMissile=CCSprite::spriteWithFile("Bomb.png");
                if(voice_type==RESPONSE_DOUBLE && check_double==true){
                    Missile.Init_Missile(present_position,Shoot_angle,100);
                }
                else{
                    Missile.Init_Missile(present_position,Shoot_angle,50);
                }
                pMissile->setPosition(ccp(present_position.x,present_position.y));
                
                if(voice_type==RESPONSE_DOUBLE && check_double==true){
                    pItem_double->setOpacity(50);
                }
                else{
                    pMissile->setScaleX(0.5);
                    pMissile->setScaleY(0.5);
                }
                this->addChild(pMissile,1);
                check_shoot=true;
        
                CCSize minimap_size = pMiniMap->getContentSize();
                CCPoint minimap_position = pMiniMap->getPosition();
                SF_vector Missile_pos = Missile.Get_position();
            
                pYellowdot=CCSprite::spriteWithFile("Yellow_dot.png");
                pYellowdot->setOpacity(180);
                pYellowdot->setPosition(ccp(minimap_position.x-minimap_size.width/2+Missile_pos.x/(winSize.width*2)*minimap_size.width,minimap_position.y-40));
                this->addChild(pYellowdot,2);
            
                //패킷 전송부
                if(voice_type==RESPONSE_MISSILE){
                    [PacketManager SendPacket:PROTOCOL_SHOT pos: present_position vel:Shoot_angle];
                }else if(voice_type==RESPONSE_DOUBLE && check_double==true){
                    check_double=false;
                    [PacketManager SendPacket:PROTOCOL_DOUBLE pos: present_position vel:Shoot_angle];
                }
            }
        }
    }else if(voice_type==RESPONSE_MEDICINE){
        SF_vector temp;
        if(player_num==1){
            Fighter.ADD_HP(50);
        }else if(player_num==2){
            Enemy.ADD_HP(50);
        }
        [PacketManager SendPacket:PROTOCOL_HEAL pos: temp vel:temp];
        pItem_Heal->setOpacity(50);
        if(present_turn==1)
            present_turn=-1;
        else if(present_turn==2)
            present_turn=-2;
    }
}

void SF_Scene::select1(CCObject* pSender){
    player_num=1;
    Fighter.Set_angle(0);
    setting_scene();
    [PacketManager SendPacket:PROTOCOL_SYNC pos:Fighter.Get_position() vel:Fighter.Get_position()];
}

void SF_Scene::select2(CCObject* pSender){
    player_num=2;
    Enemy.Set_angle(PI);
    setting_scene();
    [PacketManager SendPacket:PROTOCOL_SYNC pos:Enemy.Get_position() vel:Enemy.Get_position()];
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
    
    CCPoint Minimap_position =  pMiniMap->getPosition();
    CCSize Minimap_size = pMiniMap->getContentSize();
    pGreendot=CCSprite::spriteWithFile("green_dot.png");
    pGreendot->setOpacity(180);
    pReddot=CCSprite::spriteWithFile("red_dot.png");
    pReddot->setOpacity(180);
    
    if(player_num==1){
        pGreendot->setPosition(ccp(Minimap_position.x-Minimap_size.width/4,(Minimap_position.y-40)));
        this->addChild(pGreendot, 2);
        pReddot->setPosition(ccp(Minimap_position.x+Minimap_size.width/4,(Minimap_position.y-40)));
        this->addChild(pReddot, 2);
    }else if(player_num==2){
        pReddot->setPosition(ccp(Minimap_position.x-Minimap_size.width/4,(Minimap_position.y-40)));
        this->addChild(pReddot, 2);
        pGreendot->setPosition(ccp(Minimap_position.x+Minimap_size.width/4,(Minimap_position.y-40)));
        this->addChild(pGreendot, 2);
    }
    
    //비행기 이미지 등록
    pFighter = CCSprite::spriteWithFile("Fighter.png");
    //pFighter->setRotation(90);
    Fighter.Init_Aircraft(winSize.width/2, 2*86);
    Fighter.Set_angle(0);
    pFighter->setPosition(ccp(Fighter.Get_position().x, Fighter.Get_position().y));
    this->addChild(pFighter,1);
    pFighter_HPbar = CCSprite::spriteWithFile("HP.png");
    pFighter_HPbar->setScaleX(0.1);
    pFighter_HPbar->setScaleY(0.05);
    pFighter_HPbar->setPosition(ccp(Fighter.Get_position().x, Fighter.Get_position().y-70));
    this->addChild(pFighter_HPbar, 2);
    
    //적 탱크 이미지 등록
    pEnemy = CCSprite::spriteWithFile("Enemy.png");
    Enemy.Init_Aircraft(winSize.width*1.5, 2*86);
    Enemy.Set_angle(PI);
    pEnemy->setFlipX(true);
    pEnemy->setScaleX(pFighter->getContentSize().width/pEnemy->getContentSize().width);
    pEnemy->setScaleY(pFighter->getContentSize().height/pEnemy->getContentSize().height);
    pEnemy->setPosition(ccp(Enemy.Get_position().x, Enemy.Get_position().y));
    this->addChild(pEnemy,1);
    pEnemy_HPbar = CCSprite::spriteWithFile("HP.png");
    pEnemy_HPbar->setScaleX(0.1);
    pEnemy_HPbar->setScaleY(0.05);
    pEnemy_HPbar->setPosition(ccp(Enemy.Get_position().x, Enemy.Get_position().y-70));
    this->addChild(pEnemy_HPbar, 2);
    
    //디버깅용 자이로센서 감지 등록
    char c[32];
    pLabel = CCLabelTTF::labelWithString("Hello World", "Thonburi", 34);
    sprintf( c, "%f, %f, %f", 0.0, 1.1, 2.2);
    pLabel->setString(c);
	pLabel->setPosition( ccp(winSize.width / 2, winSize.height - 20) );
	this->addChild(pLabel, 1);
    
    //타이머 등록
    char a[32];
    pTimer = CCLabelTTF::labelWithString("Time", "Arial", 40);
    sprintf( a, "TIME");
    pTimer->setString(a);
    pTimer->setPosition(ccp(winSize.width-40,20));
    this->addChild(pTimer,2);
    
    //화살 추가
    pArrow = CCSprite::spriteWithFile("Arrow.png");
    pArrow->setScaleX(0.05);
    pArrow->setScaleY(0.05);
    pArrow->setRotation(90);
    this->addChild(pArrow,1);
    
    //파워게이지 추가
    pPowergauge = CCSprite::spriteWithFile("power_bar.png");
    pPowergauge->setScaleX(1);
    pPowergauge->setScaleY(1);
    pPowergauge->setPosition( ccp(200,winSize.height-60));
    this->addChild(pPowergauge,1);
    
    //파워게이지 체크바 추가 x값이 80~370
    pCheckbar = CCSprite::spriteWithFile("bar.png");
    pCheckbar->setScaleX(0.05);
    pCheckbar->setScaleY(0.05);
    pCheckbar->setRotation(90);
    pCheckbar->setPosition( ccp(200-120,winSize.height-60));
    this->addChild(pCheckbar,1);
    
    //아이템 셋팅
    pItem_Heal = CCSprite::spriteWithFile("Item_Heal.png");
    //pItem_Heal->setOpacity(200);
    //pItem_Heal->setScaleX(0.5);
    //pItem_Heal->setScaleY(0.5);
    pItem_Heal->setPosition(ccp(80,winSize.height-140));
    this->addChild(pItem_Heal,2);
    
    pItem_double = CCSprite::spriteWithFile("x2.png");
    //pItem_double->setScale(0.5);
    pItem_double->setPosition(ccp(160,winSize.height-140));
    this->addChild(pItem_double,2);
    
    //프레임 수를 세기 위해 초기화
    count_frame=0;
    //미사일 발사 여부 초기화
    check_shoot=false;
    //bar move init
    Move_bar=true;
    //아이템들 초기화
    check_double=true;
    check_heal=true;
    
    setIsAccelerometerEnabled(true);
    
    this->setIsTouchEnabled(true);
    schedule(schedule_selector(SF_Scene::frame), 1.f/60);
}

void SF_Scene::Move_Powerbar(){
    CCPoint bar_position;
    bar_position=pCheckbar->getPosition();
    
    if(Powerbar_Direction==true){
        bar_position.x+=1.5;
        pCheckbar->setPosition(bar_position);
    }
    else if(Powerbar_Direction==false){
        bar_position.x+=-1.5;
        pCheckbar->setPosition(bar_position);
    }
    
    bar_position=pCheckbar->getPosition();
    
    if(bar_position.x < 80 )
        Powerbar_Direction=true;
    else if(bar_position.x > 370)
        Powerbar_Direction=false;
}

double SF_Scene::Get_Powerposition(){ 
    double bar_x_position;
    
    bar_x_position=pCheckbar->getPosition().x;
    
    return (bar_x_position-80)/290*100;
}

void SF_Scene::MiniMap_dot(){
    CCSize minimap_size = pMiniMap->getContentSize();
    CCRect minimap_bountbox = pMiniMap->boundingBox();
    CCPoint minimap_position = pMiniMap->getPosition();
    SF_vector P1_position, P2_position;
    
    P1_position = Fighter.Get_position();
    P2_position = Enemy.Get_position();
    
    if(player_num == 1){
        pGreendot->setPosition(ccp(minimap_position.x-minimap_size.width/2+P1_position.x/(winSize.width*2)*minimap_size.width,(minimap_position.y-40)));
        pReddot->setPosition(ccp(minimap_position.x-minimap_size.width/2+P2_position.x/(winSize.width*2)*minimap_size.width,(minimap_position.y-40)));
    }else if(player_num == 2){
        pGreendot->setPosition(ccp(minimap_position.x-minimap_size.width/2+P2_position.x/(winSize.width*2)*minimap_size.width,(minimap_position.y-40)));
        pReddot->setPosition(ccp(minimap_position.x-minimap_size.width/2+P1_position.x/(winSize.width*2)*minimap_size.width,(minimap_position.y-40)));
    }
    
    if(check_shoot==true){
        SF_vector Missile_pos = Missile.Get_position();
        pYellowdot->setPosition(ccp(minimap_position.x-minimap_size.width/2+Missile_pos.x/(winSize.width*2)*minimap_size.width,minimap_position.y-minimap_bountbox.size.height/2+Missile_pos.y/(winSize.height)*minimap_bountbox.size.height));
    }
}

void SF_Scene::Draw_HPbar(){
    int Fighter_HP, Enemy_HP;
    SF_vector fighter_pos, enemy_pos;
    Fighter_HP = Fighter.Get_HP();
    Enemy_HP = Enemy.Get_HP();
    fighter_pos=Fighter.Get_position();
    enemy_pos=Enemy.Get_position();
    
    pFighter_HPbar->setScaleX((float)Fighter_HP/1000);
    pFighter_HPbar->setPosition(ccp(fighter_pos.x-Layer_operator,fighter_pos.y-70));
    pEnemy_HPbar->setScaleX((float)Enemy_HP/1000);
    pEnemy_HPbar->setPosition(ccp(enemy_pos.x-Layer_operator,enemy_pos.y-70));
}

void SF_Scene::Write_Time(){
    if(present_turn==1 || present_turn==2){
        int temp;
        char c[32];
        temp=20-(int)count_frame;
        sprintf(c,"%d",temp);
        pTimer->setString(c);
    }else{
        pTimer->setString("10");
    }
}

void SF_Scene::Check_hit(){
    if(check_shoot==true){  
        if(present_turn == player_num){                 //맞췄을 경우
            if(player_num==1){
                if(CCRect::CCRectIntersectsRect(pMissile->boundingBox(), pEnemy->boundingBox())){
                    Enemy.Sub_HP(Missile.Get_Missile_power());
                    check_shoot=false;
                    present_turn=-1;
                    SF_vector power;
                    power.x=Missile.Get_Missile_power();
                    [PacketManager SendPacket:PROTOCOL_HIT pos:Fighter.Get_position() vel:power];
                    this->removeChild(pMissile,true);
                    this->removeChild(pYellowdot, true);
                }
            }else if(player_num==2){
                if(CCRect::CCRectIntersectsRect(pMissile->boundingBox(), pFighter->boundingBox())){
                    Fighter.Sub_HP(Missile.Get_Missile_power());
                    check_shoot=false;
                    present_turn=-2;
                    SF_vector power;
                    power.x=Missile.Get_Missile_power();
                    [PacketManager SendPacket:PROTOCOL_HIT pos:Fighter.Get_position() vel:power];
                    this->removeChild(pMissile,true);
                    this->removeChild(pYellowdot, true);
                }
            }
        }
        
        //통신에 의해 내가 맞을때
        /*if(present_turn==2 && player_num==1){
            if(CCRect::CCRectIntersectsRect(pMissile->boundingBox(), pFighter->boundingBox())){
                Fighter.Sub_HP(Missile.Get_Missile_power());
                check_shoot=false;
                this->removeChild(pMissile,true);
                this->removeChild(pYellowdot, true);
            }
        }else if(present_turn==1 && player_num==2){
            if(CCRect::CCRectIntersectsRect(pMissile->boundingBox(), pEnemy->boundingBox())){
                Enemy.Sub_HP(Missile.Get_Missile_power());
                check_shoot=false;
                this->removeChild(pMissile, true);
                this->removeChild(pYellowdot, true);
            }
        }*/
    }
}

void SF_Scene::Game_END(){
    //this->removeChild(wait_backgroud, true);
    //this->removeChild(pFighter, true);
    //this->removeChild(pEnemy, true);
    //this->removeChild(pPowergauge, true);
    //this->removeChild(pMiniMap, true);
    //this->removeChild(pCheckbar, true);
    //this->removeChild(pReddot, true);
    //this->removeChild(pGreendot, true);
    this->removeAllChildrenWithCleanup(true);
    this->setIsTouchEnabled(false);
    
    if(player_num==1){
        if(Fighter.Get_HP()>0){
            wait_backgroud = CCSprite::spriteWithFile("win_Scene.jpg");
            // position the sprite on the center of the screen
            wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
            wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
            wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
            // add the sprite as a child to this layer
            this->addChild(wait_backgroud, 0);
        }else{
            wait_backgroud = CCSprite::spriteWithFile("Lose_Scene.png");
            // position the sprite on the center of the screen
            wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
            wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
            wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
            // add the sprite as a child to this layer
            this->addChild(wait_backgroud, 0);
        }
    }else if(player_num==2){
        if(Fighter.Get_HP()>0){
            wait_backgroud = CCSprite::spriteWithFile("Lose_Scene.png");
            // position the sprite on the center of the screen
            wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
            wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
            wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
            // add the sprite as a child to this layer
            this->addChild(wait_backgroud, 0);
        }else{
            wait_backgroud = CCSprite::spriteWithFile("win_Scene.jpg");
            // position the sprite on the center of the screen
            wait_backgroud->setScaleX(winSize.width/wait_backgroud->getContentSize().width);
            wait_backgroud->setScaleY(winSize.height/wait_backgroud->getContentSize().height);
            wait_backgroud->setPosition( ccp(winSize.width/2, winSize.height/2) );
            // add the sprite as a child to this layer
            this->addChild(wait_backgroud, 0);
        }
    }
}

void SF_Scene::registerWithTouchDispatcher(){
    CCTouchDispatcher::sharedDispatcher()->addTargetedDelegate(this, 0, true);
}

void SF_Scene::ccTouchMoved(CCTouch* touch, UIEvent* event){
    CCPoint touchLocation = touch->locationInView( touch->view());
    CCPoint pos = CCDirector::sharedDirector()->convertToGL(touchLocation);
}

void SF_Scene::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    CCPoint touchLocation = pTouch->locationInView( pTouch->view());
    CCPoint pos = CCDirector::sharedDirector()->convertToGL(touchLocation);
    CCPoint target_vector;
    SF_vector player_pos;
    
    if(player_num==1){
        player_pos=Fighter.Get_position();
    }else if(player_num==2){
        player_pos=Enemy.Get_position();
    }
    player_pos.x-=Layer_operator;
    target_vector.x=pos.x-player_pos.x;
    target_vector.y=pos.y-player_pos.y;
    target_angle=acos(target_vector.x/sqrt(target_vector.x*target_vector.x+target_vector.y*target_vector.y));
    target_angle *= target_vector.y<0?-1:1;
    target_angle=target_angle/PI*180;
    if(target_angle<0)
        target_angle+=360;
}

bool SF_Scene::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent){
    CCPoint touchLocation = pTouch->locationInView( pTouch->view());
    CCPoint pos = CCDirector::sharedDirector()->convertToGL(touchLocation);
    CCPoint target_vector;
    SF_vector player_pos;
    double vector_length=sqrt(target_vector.x*target_vector.x+target_vector.y*target_vector.y);
    
    if(player_num==1){
        player_pos=Fighter.Get_position();
    }else if(player_num==2){
        player_pos=Enemy.Get_position();
    }
    player_pos.x-=Layer_operator;
    target_vector.x=pos.x-player_pos.x;
    target_vector.y=pos.y-player_pos.y;
    target_angle=acos(target_vector.x/vector_length);
    
    target_angle *= target_vector.y<0?-1:1;
    target_angle=target_angle/PI*180;
    if(target_angle<0)
        target_angle+=360;
    
    return true;
}

void SF_Scene::Move_angle(){
    double present_angle;
    double gap;
    
    if(player_num==present_turn){
        if(player_num==1){
            present_angle=Fighter.Get_angle();
            
            //감는 방향 설정
            gap=target_angle-present_angle/PI*180;
            if(gap>=2 || gap< -2){
                if(gap<=180 && gap > 0){
                    Fighter.Add_angle((double)1);
                }else if(gap<=0 && gap>=-180){
                    Fighter.Add_angle((double)-1);
                }
            }
        }else if(player_num==2){
            present_angle=Enemy.Get_angle();
            
            //감는 방향 설정
            gap=target_angle-present_angle/PI*180;
            if(gap>=2 || gap< -2){
                if(gap <= 180){
                    Enemy.Add_angle((double)1);
                }else{
                    Enemy.Add_angle((double)-1);
                }
            }
        }
    }
    
    char c[32];
    sprintf( c, "%f %f", present_angle, target_angle);
    pLabel->setString(c);
    pLabel->setPosition( ccp(winSize.width / 2, winSize.height - 20) );
}

void SF_Scene::receiveData(NSData * data)
{
    SF_vector position, velocity;
    Byte* buffer = (Byte*) [data bytes];
    
    memcpy(&position.x, buffer+1+0*sizeof(double), sizeof(double));
    memcpy(&position.y, buffer+1+1*sizeof(double), sizeof(double));
    memcpy(&velocity.x, buffer+1+2*sizeof(double), sizeof(double));
    memcpy(&velocity.y, buffer+1+3*sizeof(double), sizeof(double));
    
    switch (buffer[0]) {
        case PROTOCOL_START:
            break;
        case PROTOCOL_END:
            if(present_turn==1)
                present_turn=-1;
            else if(present_turn==2)
                present_turn=-2;
            check_shoot=false;
            this->removeChild(pMissile, true);
            this->removeChild(pYellowdot,true);
            break;
        case PROTOCOL_SYNC:
            if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
            {
                Enemy.Set_Position(position.x, position.y);
            }
            else
            {
                Fighter.Set_Position(position.x, position.y);
            }
            
            break;
        case PROTOCOL_HIT:
            this->removeChild(pMissile, true);
            this->removeChild(pYellowdot, true);
            check_shoot=false;
            if(player_num==1){
                Fighter.Sub_HP(velocity.x);
            }else if(player_num==2){
                Enemy.Sub_HP(velocity.x);
            }
            if(present_turn==1)
                present_turn=-1;
            else if(present_turn==2)
                present_turn=-2;
            break;
        case PROTOCOL_SHOT:
        {
            check_shoot=true;
            pMissile=CCSprite::spriteWithFile("Bomb.png");
            Missile.Init_Missile(position,velocity,50);
            pMissile->setPosition(ccp(position.x,position.y));
            pMissile->setScaleX(0.5);
            pMissile->setScaleY(0.5);
            this->addChild(pMissile,1);
            
            if(player_num==1)
                Missile.Set_who(2);
            else
                Missile.Set_who(2);
            
            CCSize minimap_size = pMiniMap->getContentSize();
            CCPoint minimap_position = pMiniMap->getPosition();
            SF_vector Missile_pos = Missile.Get_position();
            
            pYellowdot=CCSprite::spriteWithFile("Yellow_dot.png");
            pYellowdot->setOpacity(180);
            pYellowdot->setPosition(ccp(minimap_position.x-minimap_size.width/2+Missile_pos.x/(winSize.width*2)*minimap_size.width,minimap_position.y-40));
            this->addChild(pYellowdot,2);
        }
            break;
        case PROTOCOL_DOUBLE:
        {
            check_shoot=true;
            pMissile=CCSprite::spriteWithFile("Bomb.png");
            Missile.Init_Missile(position,velocity,100);
            pMissile->setPosition(ccp(position.x,position.y));
            //pMissile->setScaleX(0.5);
            //pMissile->setScaleY(0.5);
            this->addChild(pMissile,1);
            
            if(player_num==1)
                Missile.Set_who(2);
            else
                Missile.Set_who(2);
            
            CCSize minimap_size = pMiniMap->getContentSize();
            CCPoint minimap_position = pMiniMap->getPosition();
            SF_vector Missile_pos = Missile.Get_position();
            
            pYellowdot=CCSprite::spriteWithFile("Yellow_dot.png");
            pYellowdot->setOpacity(180);
            pYellowdot->setPosition(ccp(minimap_position.x-minimap_size.width/2+Missile_pos.x/(winSize.width*2)*minimap_size.width,minimap_position.y-40));
            this->addChild(pYellowdot,2);
        }
            break;
        case PROTOCOL_HEAL:
            if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
            {
                Enemy.ADD_HP(50);
            }
            else
            {
                Fighter.ADD_HP(50);
            }
            if(present_turn==1)
                present_turn=-1;
            else if(present_turn==2)
                present_turn=-2;
            break;
    }
    CCLog("receive : %f, %f, %f, %f", position.x, position.y, velocity.x, velocity.y);
}