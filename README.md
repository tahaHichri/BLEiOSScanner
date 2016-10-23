# BLEiOSScanner

Connecting to a Bluetooth 4.0 LE can be tricky especially on iOS where the real address of devices is hidden behind the generated UUID.
This class will help you:
- discover advertising Bluetooth LE peripherals ( servers ).
- Connect to a specific device.
- list available services.
- read each service characteristics.
- read available descritors.
- list allowed permission for read/write.


<h2>How to use it</h2>
1 - Move class files into your project ( you can use drag-n-drop ) using xCode.


2 - Include BluetoothLEManager class in your ViewController
```objective-c
#import "BlueToothLEManager.h"
@interface ViewController ()
@property (strong) BlueToothLEManager *bluetoothManager;
@end
```

3 - declare BluetoothLEManager and intialize it
```objective-c
@interface ViewController ()
@property (strong) BlueToothLEManager *bluetoothManager;
@end



- (void)viewDidLoad {
    [super viewDidLoad];
  // code
    self.bluetoothManager = [[BlueToothLEManager alloc] init];
}
```


<b>NOTE:</b> You can use TableView to display the list of devices. the discovered devices are stored in <i>foundDevices</i>
Don't forget to set the tableView delegate and source
example:
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.bluetoothManager = [[BlueToothLEManager alloc] init];
}
```

<h2>Excerpt of console log ( the remaining has been deliberately omitted )</h2>
<img src="http://i.imgur.com/pk8Z9wY.jpg" alt="preview of console">



   Copyright 2016 hishri taha.
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.


