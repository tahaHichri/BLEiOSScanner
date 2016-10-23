
#import "BlueToothLEManager.h"

@implementation BlueToothLEManager

- (instancetype)init {
    self = [super init];
    NSLog(@"initializing BluetoothLEManager");
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _foundDevices = [NSMutableOrderedSet orderedSet];
    return self;
}



#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected to %@.\nFinding services ..",  peripheral.description);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    



}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral : (CBPeripheral *) peripheral
    advertisementData : (NSDictionary *) advertisementData
                 RSSI : (NSNumber *) RSSI
{
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    [ central cancelPeripheralConnection:peripheral ];
    
    // adding to set only if not already exisiting
    [ _foundDevices addObject: peripheral ];
    //  NSLog(@"Found devices %lu", _foundDevices.count );
    
}




- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
//    for (CBService *service in peripheral.services) {
//        NSLog(@"Discovered service %@", service);
//        
//            [peripheral discoverCharacteristics:nil forService:service];
//        
//        
//    }
    NSLog(@"ALL SERVICES %@", peripheral.services);
    
    for (int i=0; i < peripheral.services.count; i++)
    {
        CBService *s = [peripheral.services objectAtIndex:i];
        
        // Fetching characteristics for CURRENT service
        [peripheral discoverCharacteristics:nil forService:s];
    }
    


}





- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *) service
                                                                            error:(NSError *) error
{
    NSLog(@"Found %ld characterisitcs for service %@:\n", service.characteristics.count, service.UUID);

    for (CBCharacteristic *characteristic in service.characteristics)
    {
         NSLog(@"%@.", characteristic.UUID);
        
    }
    NSLog(@"\n \n \n");

    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
                [ peripheral discoverDescriptorsForCharacteristic:characteristic];
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {

        [ peripheral readValueForCharacteristic:characteristic ];
    }
    

}

-( void ) peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog( @"\nCharacteristic %@\nValue:\t%@.\nDescriptors count:\t%ld\n\n",
          characteristic.UUID,
          [[NSString alloc] initWithData: characteristic.value encoding:NSUTF8StringEncoding],
          characteristic.descriptors.count );
   

    for (int count=0; count < characteristic.descriptors.count; count++)
    {
        CBDescriptor *descript = [characteristic.descriptors objectAtIndex:count];
        
        // Fetching characteristics for CURRENT service
        [peripheral readValueForDescriptor:descript];
        
    }
    
}


-(void ) peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    NSLog(@"Value for descriptor [%@] = %@.", descriptor.value, descriptor.description );
}


-( void ) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Service: [%@] \t\t Characteristic [%@] \t VALUE: \t%@ \t %@\n", characteristic.service.UUID, characteristic.UUID, [[NSString alloc] initWithData: characteristic.value encoding:NSUTF8StringEncoding], characteristic.value.description );
    
    
    // trying to send and write request to a given harcoded characteristic, next I will change this to anoter characeristic of user choosing.
    
    char dataByte = 0x10;
    NSData *data = [NSData dataWithBytes:&dataByte length:1];
    
    
        [peripheral writeValue:data forCharacteristic:characteristic
                      type:CBCharacteristicWriteWithResponse];
    
   
    
    
    if ( characteristic.isNotifying )
        NSLog(@"notifying");
    else
        NSLog(@"not notifying");

}

- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    if ( error )
    {
        NSLog ( @"Error writing characteristic %@ \t value:\t%@", characteristic.UUID, [error localizedDescription] );
    } else {
        NSLog ( @"writing characteristic %@ \t  success, new value: %@", characteristic.UUID, characteristic.value.description );
    }
}



/*
 *  Bluetooth manager status and callbacks, won't have to change it.
 */


-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Start scan");
    
    // make sure platform supports Bluetooth 4.0 LE AND I am able to search for nearby devices.
    
    NSString *messtoshow;
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            messtoshow =[NSString stringWithFormat:@"State unknown, update imminent."];
            break;
        }
        case CBCentralManagerStateResetting:
        {
            messtoshow =[NSString stringWithFormat:@"The connection with the system service was momentarily lost, update imminent."];
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            messtoshow =[NSString stringWithFormat:@"The platform doesn't support Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            messtoshow =[NSString stringWithFormat:@"The app is not authorized to use Bluetooth Low Energy"];
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            messtoshow =[NSString stringWithFormat:@"Bluetooth is currently powered off."];
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            messtoshow=[NSString stringWithFormat:@"Bluetooth is currently powered on and available to use."];
            [_centralManager scanForPeripheralsWithServices:nil options:nil];


            break;
        }
            
    }
    NSLog( messtoshow );
}

@end
