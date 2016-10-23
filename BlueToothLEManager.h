
#import <Foundation/Foundation.h>
@import CoreBluetooth;

@interface BlueToothLEManager : NSObject < CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, readonly)  CBCentralManager *centralManager;
@property (strong, nonatomic)  NSMutableOrderedSet *foundDevices;

@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;

// this function is now part of the device connected callback.
- ( void ) getServices: (CBPeripheral *) periph;

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
@end
