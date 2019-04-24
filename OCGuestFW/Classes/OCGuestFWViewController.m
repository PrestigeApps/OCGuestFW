//
//  OCGuestFWViewController.m
//  OCGuestFW
//
//  Created by Felix Navarro on 03/03/2019.
//  Copyright © 2019 Cloud Hospitality. All rights reserved.
//


#import "OCGuestFWViewController.h"
#import "OCGuestFWQuerys.h"
#import <SaltoJustINMobile/SSJustinMobile.h>
#import <SeosMobileKeysSDK/SeosMobileKeysSDK.h>
//#import "ASSAAbloyIntegration.h"

#define APPLICATION_ID @"AAH-CLOUDHOSPITALITY"
#define LOCK_SERVICE_CODE_AAMK 1
#define LOCK_SERVICE_CODE_HID 2

@interface OCGuestFWViewController ()
    @property(nonatomic) MobileKeysManager *mobileKeysManager;
    @property(nonatomic) NSMutableArray *mobileKeys;
    @property(nonatomic) NSMutableDictionary *keyTags;
    @property(nonatomic) CLLocationManager *locationManager;
    @property(nonatomic) NSDate *timeOfLastConnection;
@end

@implementation OCGuestFWViewController

BOOL _applicationIsStarting;
NSArray *_lockServiceCodes;
NSArray * _currentlyEnabledOpeningModes;

Boolean m_bluetooth;
Boolean m_isLoad;
AVPlayer *player;
NSBundle *frameWorkBundle;
//ASSAAbloyIntegration *m_assaabloy;

NSDictionary *langs;
NSDictionary *actual_langs;
NSMutableArray *images;
NSString *returnCode = @"1002";

NSString *m_keylesstype;
NSString *m_guestmobile_id;

- (void)viewDidLoad {
    m_isLoad = NO;
    langs  = @{
       @"es" : @{
           @"dlW_Espera" : @"Espera...",
           @"lng_cancel" : @"Cancelar",
           @"lng_solicitarllave" : @"Solicitar mi llave",
           @"lng_nosehapodidogenerartullave" : @"No se ha podido generar tu llave",
           @"lng_tullavesehageneradocorrectamente" : @"Tu llave se ha generado correctamente",
           @"lng_acercatutelefonoalacerradura" : @"Acerca tu teléfono a la cerradura",
           @"lng_elbluetoothnoestaactivado" : @"El bluetooth no está activado. Accede a la configuración del dispositivo para activarlo.",
           @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia" : @"La puerta a la que intentas acceder no esta vinculada con tu estancia",
           @"lng_lapuertasehaabiertocorrectamente" : @"La puerta se ha abierto correctamente"
       },
       @"en" : @{
           @"dlW_Espera" : @"Wait...",
           @"lng_cancel" : @"Cancel",
           @"lng_solicitarllave" : @"Request your key",
           @"lng_nosehapodidogenerartullave" : @"Unable to create your key",
           @"lng_tullavesehageneradocorrectamente" : @"Key successfully created",
           @"lng_acercatutelefonoalacerradura" : @"Bring your mobile closer to the lock",
           @"lng_elbluetoothnoestaactivado" : @"The bluetooth is not active. Access your mobile settings and turn it on.",
           @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia" : @"The door you are trying to open does not belong to your stay",
           @"lng_lapuertasehaabiertocorrectamente" : @"Door successfully opened"
           },
       @"fr" : @{
           @"dlW_Espera" : @"Attente...",
           @"lng_cancel" : @"Annuler",
           @"lng_solicitarllave" : @"Demander la clé",
           @"lng_nosehapodidogenerartullave" : @"Impossible de générer la clé",
           @"lng_tullavesehageneradocorrectamente" : @"La clé a été générée correctement",
           @"lng_acercatutelefonoalacerradura" : @"A propos votre téléphone à la serrure",
           @"lng_elbluetoothnoestaactivado" : @"Le bluetooth n'est pas activé. Accéder aux paramètres de @l'appareil pour l'activer.",
           @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia" : @"La porte à laquelle vous @essayez d'accéder n'est pas liée à votre séjour",
           @"lng_lapuertasehaabiertocorrectamente" : @"La porte a été ouverte correctement"
       },
       @"ca" : @{
           @"dlW_Espera" : @"Un segon...",
           @"lng_cancel" : @"Cancel·lar",
           @"lng_solicitarllave" : @"Sol·licitar la meva clau",
           @"lng_nosehapodidogenerartullave" : @"No s'ha pogut generar la teva clau",
           @"lng_tullavesehageneradocorrectamente" : @"La teva clau s'ha generat correctament",
           @"lng_acercatutelefonoalacerradura" : @"Apropa el teu telèfon al pany",
           @"lng_elbluetoothnoestaactivado" : @"El bluetooth no està activat. Accedeix a la configuració del dispositiu per activar-ho",
           @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia" : @"La porta a la que intentes accedir no està vinculada amb la teva estancia",
           @"lng_lapuertasehaabiertocorrectamente" : @"La porta s'ha obert correctament"
       },
       @"de" : @{
           @"dlW_Espera" : @"Warten...",
           @"lng_cancel" : @"Stornieren",
           @"lng_solicitarllave" : @"Meinen Key anfordern",
           @"lng_nosehapodidogenerartullave" : @"Ihr Schlüssel konnte nicht generiert werden",
           @"lng_tullavesehageneradocorrectamente" : @"Ihr Schlüssel wurde korrekt generiert",
           @"lng_acercatutelefonoalacerradura" : @"Bringen Sie Ihr Handy näher an das Schloss heran",
           @"lng_elbluetoothnoestaactivado" : @"Bluetooth ist nicht aktiviert. Zugriff auf die Geräteeinstellungen, um das Gerät zu aktivieren.",
           @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia" : @"Die Tür, die Sie zu betreten versuchen, ist nicht mit Ihrem Aufenthalt verbunden",
           @"lng_lapuertasehaabiertocorrectamente" : @"Tür hat sich korrekt geöffnet"
       }
       
   };
    
    
    [super viewDidLoad];
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    frameWorkBundle = [NSBundle bundleForClass:[self class]];

    images = [NSMutableArray array];
    @try {
        //for (int i = 0; i < 239; i++) {
            NSString *img = [NSString stringWithFormat:@"%d", 0];
            NSLog(@"%@", img);
            UIImage *uiimage = [UIImage imageNamed: img inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            [images addObject: uiimage];
        //}
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        
    }
}

- (void) initApp {
    //NSLog(@"%@", [NSString stringWithFormat:@"INTENT\nchannelkey: %@\nroomstay_id: %@\nroomnumber: %@\nlangcode: %@", self.channelkey, self.roomstay_id, self.roomnumber, self.langcode]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingWentWrong_channelkey) name:@"somethingWentWrong_channelkey" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingWentWrong_channelkey) name:@"somethingWentWrong_property" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingWentWrong_roomstay) name:@"somethingWentWrong_roomstay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingWentWrongKey) name:@"somethingWentWrongKey" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProperty) name:@"channelkey_ok" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoomstay:) name:@"property_ok" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingfinish) name:@"roomstay_ok" object:nil];
    
    // ASSA ABLOY INTEGRATION
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingWentWrongKey) name:@"somethingWentWrong_assaabloystart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startfinishASSAAbloy) name:@"assaabloystart_ok" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invitationGenerated:) name:@"invitationcode_ok" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyGenerated:) name:@"generatedkey_ok" object:nil];
    
    
    
    if ([langs objectForKey:self.langcode] != nil) {
        actual_langs = [langs objectForKey:self.langcode];
    } else {
        actual_langs = [langs objectForKey: @"en"];
    }
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
    action:@selector(handleSingleTap:)];

    [self.view addGestureRecognizer:singleFingerTap];
    
    [self performSelector:@selector(handleExit) withObject:nil afterDelay:(NSTimeInterval)15];
    
    NSString * get = [actual_langs objectForKey:@"lng_solicitarllave"];//[frameWorkBundle localizedStringForKey:@"lng_solicitarllave" value:@"" table:@""];
    //NSString * cancel = [actual_langs objectForKey:@"lng_cancel"];//[frameWorkBundle localizedStringForKey:@"lng_cancel" value:@"" table:@""];
    
    [self.m_bt_getkey setTitle:get forState:UIControlStateNormal];
    m_isLoad = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *m_def_channelkey = [[defaults stringForKey:@"channelkey"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *m_def_roomstay_id = [defaults stringForKey:@"roomstay_id"];
    NSString *m_def_roomnumber = [defaults stringForKey:@"roomnumber"];
    //
    
    //NSString *m_def_langcode = [defaults stringForKey:@"langcode"];
    
    
    //NSLog(@"%@", [NSString stringWithFormat:@"defaults \nchannelkey: %@\nroomstay_id: %@\nroomnumber: %@\nlangcode: %@", m_def_channelkey, m_def_roomstay_id, m_def_roomnumber, m_def_langcode]);
    
    
    //NSLog(@"%@", [NSString stringWithFormat:@"COMPARE \nchannelkey: %d\nroomstay_id: %d\nroomnumber: %d", ![self.channelkey isEqualToString:m_def_channelkey], ![self.roomstay_id isEqualToString:m_def_roomstay_id] , ![self.roomnumber isEqualToString:m_def_roomnumber]]);
    
    if (![self.channelkey isEqualToString:m_def_channelkey] || ![self.roomstay_id isEqualToString:m_def_roomstay_id] || ![self.roomnumber isEqualToString:m_def_roomnumber]) {
        [self setStatusView:(LOADING)];
        [OCGuestFWQuerys dbb_load_credentials:self.channelkey];
    } else {
//        NSInteger m_def_keycode = [defaults integerForKey:@"keycode"];
        
        if([self haslocationpermision]) {
            if (!m_bluetooth) {
                //NSLog(@"ENTRA NO BLUETOOTH");
                [self setStatusView:(NO_BLUETOOTH)];
                [self finishExecution];
                return;
            }
            [self openDoor];
            [self setStatusView:(OPEN_TRY)];
        } else {
            returnCode = @"1005";
            [self setStatusView:(NO_KEY_DOOR)];
            [self finishExecution];
        }
    }
}

- (void) setStatusView: (ViewState) status {
    NSString *label;
    NSString *image;
    Boolean bt_hidden = YES;
    Boolean m_animated = NO;
    //Boolean video_hidden = YES;
    switch (status) {
        case NO_KEY:
            label = @"";
            image = @"fw_door_disabled256";
            bt_hidden = NO;
        break;
        case LOADING:
            label = @"dlW_Espera";
            image = @"fw_door_disabled256";
        break;
        case KEY_GENERATED_ERROR:
            label = @"lng_nosehapodidogenerartullave";
            image = @"fw_door_gendenied256";
        break;
        case KEY_GENERATED:
            label = @"lng_tullavesehageneradocorrectamente";
            image = @"fw_door_genok256";
        break;
        case OPEN_TRY:
            label = @"lng_acercatutelefonoalacerradura";
            m_animated = YES;
            image = @"fw_door_genok256";
            //video_hidden = NO;
        break;
        case NO_BLUETOOTH:
            label = @"lng_elbluetoothnoestaactivado";
            image = @"fw_bluetooth256";
        break;
        case NO_KEY_DOOR:
            label = @"lng_lapuertaalaqueintentasaccedernoestavinculadacontuestancia";
            image = @"fw_door_denied256";
        break;
        case KEY_DOOR_OK:
            label = @"lng_lapuertasehaabiertocorrectamente";
            image = @"fw_door_ok256";
            break;
            
        default:
        break;
    }
   
    //NSLog(@"%@ - %@", label, image);
    NSString *text = [actual_langs objectForKey: label];//[frameWorkBundle localizedStringForKey:label value:@"" table:@""];
    UIImage *uiimage = [UIImage imageNamed: image inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
    
    self.m_lb_key.text = text;
    self.m_bt_getkey.hidden = bt_hidden;
    //self.m_view_video.hidden = video_hidden;
    if (m_animated) {
        
        self.m_image.animationImages = images;/*[NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"image1.gif"],
                                             [UIImage imageNamed:@"image2.gif"],
                                             [UIImage imageNamed:@"image3.gif"],
                                             [UIImage imageNamed:@"image4.gif"], nil];*/
        self.m_image.animationDuration = 10.0f;
        self.m_image.animationRepeatCount = 0;
        [self.m_image startAnimating];
        //[self.view addSubview: animatedImageView];
    } else {
        [self.m_image setImage: uiimage];
        [self.m_image stopAnimating];
    }
    self.m_image.hidden = NO;
/*    if (!video_hidden){
        [player play];
    } else {
        [player pause];
    }
*/
    
}
- (void) getProperty {
    [OCGuestFWQuerys dbb_load_property_config];
}
- (void) getRoomstay: (NSNotification *) notification {
    
    NSDictionary *dict = notification.userInfo;
    
    m_keylesstype = @"1";//[dict objectForKey:@"keyless_type"];
    
    NSLog(@"Keyless_type: %@", m_keylesstype);
    
    [OCGuestFWQuerys dbb_load_roomstay:self.roomstay_id];
}

- (void) loadingfinish {
    
    switch (m_keylesstype.integerValue) {
        case Vingcard:
        case VingcardD:
            //m_assaabloy = [[ASSAAbloyIntegration alloc] init];
            _mobileKeysManager = [self createInitializedMobileKeysManager];
            // The location manager is used to ask the user for permission to use location services.
            _locationManager = [[CLLocationManager alloc] init];
            // Lock service codes are used to specify what readers the Manager should scan for
            _lockServiceCodes = @[];
            // Used for calculating time between vibration alerts
            _timeOfLastConnection = [NSDate dateWithTimeIntervalSince1970:1.0];
            // Opening modes enabled on startup
            _currentlyEnabledOpeningModes = @[@(MobileKeysOpeningTypeProximity)];
            [self start];
        break;
        default:
            [self setStatusView:(NO_KEY)];
        break;
    }
    
//    [self setStatusView:(NO_KEY)];
}

- (void) startfinishASSAAbloy {
    NSLog(@"%@", @"ASSA Abloy correctly initialized");
    [self setStatusView:(NO_KEY)];
}

- (void) invitationGenerated: (NSNotification *) notification {
    NSDictionary *dict = notification.userInfo;
    m_guestmobile_id = [dict valueForKey:@"guestmobile_id"];
    NSLog(@"SAVE KEYCODE %@", m_guestmobile_id);
    [OCGuestFWQuerys dbb_getroomkey];
}

- (void) keyGenerated: (NSNotification *) notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    
    NSDictionary *dict = notification.userInfo;
    NSString *keycode = [dict valueForKey:@"keycode"];
    //NSLog(@"SAVE KEYCODE %@", keycode);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.channelkey forKey:@"channelkey"];
    [defaults setObject:self.roomstay_id forKey:@"roomstay_id"];
    [defaults setObject:self.roomnumber forKey:@"roomnumber"];
    [defaults setObject:self.langcode forKey:@"langcode"];
    [defaults setObject:keycode forKey:@"keycode"];
    [defaults synchronize];
    
    [self setStatusView:(KEY_GENERATED)];
    returnCode = @"2000";
    [self performSelector:@selector(handleExit) withObject:nil afterDelay:(NSTimeInterval)4];
}

- (void) somethingWentWrong_channelkey {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    [self setStatusView:(KEY_GENERATED_ERROR)];
    [self finishExecution];
    returnCode = @"2001";
    
}
- (void) somethingWentWrong_roomstay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    [self setStatusView:(KEY_GENERATED_ERROR)];
    [self finishExecution];
    returnCode = @"2002";
    
}

- (void) somethingWentWrongKey {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    [self setStatusView:(KEY_GENERATED_ERROR)];
    [self finishExecution];
    returnCode = @"2003";
    
}

- (void)handleExit{
    [self dismissViewControllerAnimated:true completion:nil];
    self.callback ? self.callback(returnCode) : nil;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint _location = [recognizer locationInView:[recognizer.view superview]];
    
    CGPoint location= [self.rectView convertPoint:_location toView:self.m_View];
    CGPoint centerview = [self.rectView convertPoint:self.rectView.center toView:self.m_View];
    CGFloat _w = (self.rectView.bounds.size.width / 2);
    CGFloat _h = (self.rectView.bounds.size.height / 2);
    
    CGFloat xmin = centerview.x - _w;
    CGFloat xmax = centerview.x + _w;
    CGFloat ymin = centerview.y - _h;
    CGFloat ymax = centerview.y + _h;
    
    //NSLog(@"\nCVIEW: %f - %f \n\n\nCVIEW2: %f - %f \n\nXMIN: %f\nYMIN: %f\nXMAX: %f\nYMAX: %f\n\nPX: %f - PY: %f", centerview.x, centerview.y,location.x, location.y, xmin, ymin, xmax, ymax, location.x, location.y);
    if ((xmin <= location.x && location.x <= xmax) && (ymin <= location.y && location.y <= ymax)) {
        return;
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // You should test all scenarios
    if (central.state != CBManagerStatePoweredOn ) {
        //NSLog(@"NO BLUETOOTH");
        m_bluetooth = NO;
        returnCode = @"1003";
        if (m_isLoad) {
            [self setStatusView:(NO_BLUETOOTH)];
        }
        //return;
    }
    if (central.state == CBManagerStatePoweredOn) {
        m_bluetooth = YES;
        //NSLog(@"SI BLUETOOTH");
    }
    
    [self initApp];
}

- (void) openDoor {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    NSString *m_def_keycode = [[NSUserDefaults standardUserDefaults] stringForKey:@"keycode"];
    
    NSError * keyGenerationError;
    SSMobileKey *key = [[SSMobileKey alloc] initWithHexData:m_def_keycode
                                                      error:&keyGenerationError];
    
    if (keyGenerationError != nil) {
        //NSLog(@"OP1 %@", [keyGenerationError description]);
        [self finishExecution];
        return;
    }
    
    //NSLog(@"Dentro Pruebas Salto desde Framework \n %@", m_def_keycode);
    // Invoke the method to start the opening process
    [SSJustinBleInstance startLockOpeningWithMobileKey:key peripheralFound:^{
        // A SALTO lock is found and it will connect to it and start the secure process
        
    } success:^(NSInteger opResult) {
        // Authentication process finished with result code
        NSString *resultMessage;
        if (opResult == AUTH_SUCCESS_UNKNOWN_RESULT) {
            resultMessage = nil;
        } else if (opResult == AUTH_SUCCESS_ACCESS_GRANTED) {
            [self setStatusView:(KEY_DOOR_OK)];
            returnCode = @"1000";
            resultMessage = @"\nAccess granted";
        } else if (opResult == AUTH_SUCCESS_ACCESS_REJECTED) {
            [self setStatusView:(NO_KEY_DOOR)];
            returnCode = @"1001";
            resultMessage = @"\nAccess rejected";
        }
        [self finishExecution];
        //NSLog(@"OP2 %@", resultMessage);
        
    } failure:^(NSError *error) {
        // An error has occurred
        returnCode = @"1002";
        [self setStatusView:(NO_KEY_DOOR)];
        [self finishExecution];
    }];
}

- (IBAction)bt_key:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleExit) object:nil];
    /*[self somethingWentWrong];
     return;*/
    //[OCGuestFWQuerys dbb_load_credentials: self.channelkey];
    [self setStatusView:(LOADING)];
    [OCGuestFWQuerys dbb_requestinvitation: self.roomnumber];
    //NSLog(@"bt pulsado");
}

- (IBAction)bt_cancelkey:(id)sender {
    [self handleExit];
}


- (void)finishExecution {
    //NSLog(@"finishExecution");
    [self performSelector:@selector(handleExit) withObject:nil afterDelay:(NSTimeInterval)4];
}

- (Boolean) haslocationpermision {
    
    if(![CLLocationManager locationServicesEnabled]) return NO;
    if ([CLLocationManager authorizationStatus]==AVAuthorizationStatusDenied) return NO;
    
    return YES;
}


- (void)start {
    if ([self isEndpointSetup]) {
        _applicationIsStarting = YES;
    }
    // The startup will either give a callback to "mobileKeysDidStartup" or "mobileKeysDidFail"
    [_mobileKeysManager startup];
}

/*
 This is a factory method that creates an instance of the MobileKeysManager.
 */
- (MobileKeysManager *)createInitializedMobileKeysManager {
    
    NSString *version = [NSString stringWithFormat:@"%@-%@ (%@)", APPLICATION_ID, [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    NSDictionary *config = @{MobileKeysOptionApplicationId: APPLICATION_ID, MobileKeysOptionVersion: version};
    
    // Specify your own iBeacon UUID or use the internal one by not specifying this option
    // ***********************************************************************************
    // NSString *myBeaconUUIDString = @"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    // NSDictionary *config = @{MobileKeysOptionApplicationId: APPLICATION_ID, MobileKeysOptionVersion: version, MobileKeysOptionBeaconUUID: myBeaconUUIDString};
    
    return [[MobileKeysManager alloc] initWithDelegate:self options:config];
}
- (void)handleError:(NSError *)error {
    if (error != nil) {
        NSLog(@"ERROR %lxd : %@", (long) error.code, error.localizedDescription);
    }
}
- (BOOL)isEndpointSetup {
    NSError *error;
    BOOL setupComplete = [_mobileKeysManager isEndpointSetup:&error];
    [self handleError:error];
    return setupComplete;
}
- (void)setupEndpoint {
    if (self.isEndpointSetup) {
        [_mobileKeysManager updateEndpoint];
    }
}

/*
 Start Up
 */

- (void)mobileKeysDidStartup {
    if (_applicationIsStarting) {
        //        setupEndpoint();
        _applicationIsStarting = false;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"assaabloystart_ok" object:nil];
}

- (void)mobileKeysDidFailToStartup:(nonnull NSError *)error {
    
}

/*
 Setup Endpoint
 */

- (void)mobileKeysDidFailToSetupEndpoint:(nonnull NSError *)error {
    
}

- (void)mobileKeysDidSetupEndpoint {
    
}




@end
